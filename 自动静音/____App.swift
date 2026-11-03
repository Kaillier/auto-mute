import SwiftUI
import AppKit

@main
struct AutoMuteApp: App {
    @StateObject private var controller = MuteController()

    var body: some Scene {
        MenuBarExtra {
            MenuContent(controller: controller)
        } label: {
            Image(systemName: controller.isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
        }
        .menuBarExtraStyle(.menu)

        Settings {
            SettingsView(controller: controller)
        }
    }
}

private struct MenuContent: View {
    @ObservedObject var controller: MuteController

    var body: some View {
        Text("自动静音").font(.headline)
        Divider()
        Button(controller.isMuted ? "解除静音" : "立即静音") { controller.toggleMute() }
        Toggle("合盖时自动静音", isOn: $controller.muteBeforeSleep)
        Toggle("唤醒时自动静音", isOn: $controller.muteAfterWake)
        Toggle("登录时自动运行", isOn: $controller.launchAtLogin)
        Divider()
        SettingsLink { Text("设置…") }
        Button("退出") { NSApplication.shared.terminate(nil) }
            .keyboardShortcut("q")
    }
}

private struct SettingsView: View {
    @ObservedObject var controller: MuteController

    var body: some View {
        Form {
            Section {
                Toggle("合盖前自动静音", isOn: $controller.muteBeforeSleep)
                Toggle("唤醒后自动静音", isOn: $controller.muteAfterWake)
                Toggle("登录时自动运行", isOn: $controller.launchAtLogin)
            } footer: {
                Text("应用会在合盖和唤醒两个时机分别执行一次静音。解除静音需要你手动操作.")
                    .foregroundStyle(.secondary)
            }
            Section("当前状态") {
                LabeledContent("输出设备", value: controller.outputDeviceName)
                LabeledContent("状态", value: controller.isMuted ? "已静音" : "有声")
                Button("立即静音") { controller.mute() }
            }
        }
        .formStyle(.grouped)
        .frame(width: 420)
        .padding()
    }
}
