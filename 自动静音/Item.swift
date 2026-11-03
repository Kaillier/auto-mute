import AppKit
import Combine
import CoreAudio
import ServiceManagement

/// Coordinates the two safety passes: before sleep and immediately after wake.
final class MuteController: ObservableObject {
    @Published private(set) var isMuted = false
    @Published private(set) var outputDeviceName = "检测中…"
    @Published var muteBeforeSleep: Bool {
        didSet { preferences.set(muteBeforeSleep, forKey: Keys.muteBeforeSleep) }
    }
    @Published var muteAfterWake: Bool {
        didSet { preferences.set(muteAfterWake, forKey: Keys.muteAfterWake) }
    }
    @Published var launchAtLogin: Bool {
        didSet { setLaunchAtLogin(launchAtLogin) }
    }

    private let preferences = UserDefaults.standard
    private enum Keys {
        static let muteBeforeSleep = "muteBeforeSleep"
        static let muteAfterWake = "muteAfterWake"
    }
    private var workspaceObservers: [NSObjectProtocol] = []
    private var deviceListenerInstalled = false

    init() {
        muteBeforeSleep = preferences.object(forKey: Keys.muteBeforeSleep) as? Bool ?? true
        muteAfterWake = preferences.object(forKey: Keys.muteAfterWake) as? Bool ?? true
        if SMAppService.mainApp.status == .notRegistered { try? SMAppService.mainApp.register() }
        launchAtLogin = SMAppService.mainApp.status == .enabled
        refreshOutputDevice()
        installSystemObservers()
        installDefaultDeviceListener()
    }

    deinit {
        let workspace = NSWorkspace.shared.notificationCenter
        workspaceObservers.forEach(workspace.removeObserver)
        removeDefaultDeviceListener()
    }

    func toggleMute() { setMuted(!isMuted) }

    private func setLaunchAtLogin(_ enabled: Bool) {
        do {
            if enabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            // The system can require the user to approve the item in System Settings.
            DispatchQueue.main.async { self.launchAtLogin = SMAppService.mainApp.status == .enabled }
        }
    }
    func mute() { setMuted(true) }

    private func setMuted(_ muted: Bool) {
        guard let deviceID = defaultOutputDevice(), isBuiltInSpeaker(deviceID) else {
            refreshOutputDevice()
            return
        }
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyMute,
            mScope: kAudioDevicePropertyScopeOutput,
            mElement: kAudioObjectPropertyElementMain
        )
        var value: UInt32 = muted ? 1 : 0
        let status = AudioObjectSetPropertyData(
            deviceID, &address, 0, nil,
            UInt32(MemoryLayout<UInt32>.size), &value
        )
        if status == noErr {
            DispatchQueue.main.async {
                self.isMuted = muted
                self.refreshOutputDevice()
            }
        }
    }

    private func installSystemObservers() {
        let workspace = NSWorkspace.shared.notificationCenter
        let willSleep = workspace.addObserver(
            forName: NSWorkspace.willSleepNotification, object: nil, queue: .main
        ) { [weak self] _ in
            guard let self, self.muteBeforeSleep else { return }
            self.mute()
        }
        let didWake = workspace.addObserver(
            forName: NSWorkspace.didWakeNotification, object: nil, queue: .main
        ) { [weak self] _ in
            guard let self, self.muteAfterWake else { return }
            self.mute()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in self?.mute() }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) { [weak self] in self?.mute() }
        }
        workspaceObservers = [willSleep, didWake]
    }

    private func installDefaultDeviceListener() {
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDefaultOutputDevice,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )
        let status = AudioObjectAddPropertyListenerBlock(
            AudioObjectID(kAudioObjectSystemObject), &address, DispatchQueue.main
        ) { [weak self] _, _ in
            self?.refreshOutputDevice()
            if self?.muteAfterWake == true { self?.mute() }
        }
        deviceListenerInstalled = status == noErr
    }

    private func removeDefaultDeviceListener() {
        // The listener lives for the lifetime of this menu-bar controller.
        // The process exits together with the controller, so no teardown is needed here.
    }

    private func refreshOutputDevice() {
        guard let deviceID = defaultOutputDevice() else {
            outputDeviceName = "无可用输出设备"
            return
        }
        let name = deviceName(deviceID) ?? "默认输出设备"
        outputDeviceName = isBuiltInSpeaker(deviceID) ? name : "\(name)（不自动静音）"
        if isBuiltInSpeaker(deviceID) {
            isMuted = readMuteState(deviceID) ?? isMuted
        } else {
            isMuted = false
        }
    }

    /// Only the Mac's internal speaker is controlled. Headphones, Bluetooth and USB outputs are left alone.
    private func isBuiltInSpeaker(_ deviceID: AudioDeviceID) -> Bool {
        guard let transport = transportType(deviceID), transport == kAudioDeviceTransportTypeBuiltIn else { return false }
        let name = (deviceName(deviceID) ?? "").lowercased()
        let speakerWords = ["speaker", "speakers", "扬声器", "内置扬声器", "内建扬声器"]
        let headphoneWords = ["headphone", "headset", "耳机", "airpods", "bluetooth", "蓝牙"]
        return speakerWords.contains(where: name.contains) && !headphoneWords.contains(where: name.contains)
    }

    private func transportType(_ deviceID: AudioDeviceID) -> UInt32? {
        var value: UInt32 = 0
        var size = UInt32(MemoryLayout<UInt32>.size)
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyTransportType,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )
        let status = AudioObjectGetPropertyData(deviceID, &address, 0, nil, &size, &value)
        return status == noErr ? value : nil
    }

    private func defaultOutputDevice() -> AudioDeviceID? {
        var deviceID = AudioDeviceID(kAudioObjectUnknown)
        var size = UInt32(MemoryLayout<AudioDeviceID>.size)
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDefaultOutputDevice,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )
        let status = AudioObjectGetPropertyData(
            AudioObjectID(kAudioObjectSystemObject), &address, 0, nil, &size, &deviceID
        )
        return status == noErr && deviceID != kAudioObjectUnknown ? deviceID : nil
    }

    private func readMuteState(_ deviceID: AudioDeviceID) -> Bool? {
        var value: UInt32 = 0
        var size = UInt32(MemoryLayout<UInt32>.size)
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyMute,
            mScope: kAudioDevicePropertyScopeOutput,
            mElement: kAudioObjectPropertyElementMain
        )
        let status = AudioObjectGetPropertyData(deviceID, &address, 0, nil, &size, &value)
        return status == noErr ? value != 0 : nil
    }

    private func deviceName(_ deviceID: AudioDeviceID) -> String? {
        var name: Unmanaged<CFString>?
        var size = UInt32(MemoryLayout<Unmanaged<CFString>?>.size)
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioObjectPropertyName,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )
        let status = withUnsafeMutablePointer(to: &name) { pointer in
            AudioObjectGetPropertyData(deviceID, &address, 0, nil, &size, pointer)
        }
        return status == noErr ? name?.takeUnretainedValue() as String? : nil
    }
}
