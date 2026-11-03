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
                .accessibilityLabel(Text("Auto Mute"))
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
        Text("Auto Mute").font(.headline)
        Divider()
        Button(controller.isMuted ? LocalizedStringKey("Unmute") : LocalizedStringKey("Mute Now")) { controller.toggleMute() }
        Toggle("Mute Before Sleep", isOn: $controller.muteBeforeSleep)
        Toggle("Mute After Wake", isOn: $controller.muteAfterWake)
        Toggle("Launch at Login", isOn: $controller.launchAtLogin)
        Divider()
        SettingsLink { Text("Settings…") }
        Button("Quit") { NSApplication.shared.terminate(nil) }
            .keyboardShortcut("q")
    }
}

private struct SettingsView: View {
    @ObservedObject var controller: MuteController

    var body: some View {
        Form {
            Section {
                Toggle("Mute Before Sleep", isOn: $controller.muteBeforeSleep)
                Toggle("Mute After Wake", isOn: $controller.muteAfterWake)
                Toggle("Launch at Login", isOn: $controller.launchAtLogin)
            } footer: {
                Text("The built-in speakers are muted before sleep and after wake. Unmute manually when you want sound.")
                    .foregroundStyle(.secondary)
            }
            Section("Current Status") {
                LabeledContent("Output Device", value: controller.outputDeviceName)
                LabeledContent("Status") {
                    Text(controller.isMuted ? LocalizedStringKey("Muted") : LocalizedStringKey("Sound On"))
                }
                Button("Mute Now") { controller.mute() }
            }
        }
        .formStyle(.grouped)
        .frame(width: 480)
        .padding()
    }
}
