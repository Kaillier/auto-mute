# 自动静音 · Auto Mute

[简体中文](#简体中文) | [English](#english)

## 简体中文

自动静音是一个 macOS 菜单栏小工具，在合盖睡眠前和开盖唤醒后自动静音 **Mac 内置扬声器**。解锁后不会自动恢复音量，由你手动决定何时开启声音。

### 功能特色

- **双重静音保护**：系统即将睡眠时静音，唤醒后再次静音并短暂重试。
- **只控制内置扬声器**：耳机、AirPods、蓝牙设备和 USB 音箱不受影响。
- **不自动恢复声音**：解锁后继续保持静音，直到你手动解除。
- **切回扬声器时保护**：开启“唤醒时自动静音”后，输出设备切换回内置扬声器时也会执行静音。
- **菜单栏常驻**：通过扬声器图标快速操作，不占用 Dock 位置。
- **登录时自动运行**：登录 Mac 后自动在后台运行。
- **中英文界面**：自动跟随系统语言，修改系统语言后重新打开应用即可生效。
- **按需设置**：合盖静音、唤醒静音和登录时自动运行均可单独开关。

### 安装

1. 获取 `自动静音.dmg` 安装包，双击打开。
2. 将“自动静音”图标拖到“应用程序”文件夹。
3. 打开“应用程序”文件夹，双击“自动静音”。
4. 启动后，在屏幕顶部菜单栏找到扬声器图标。

### 首次设置

点击菜单栏中的扬声器图标，确认“合盖时自动静音”和“唤醒时自动静音”已开启。

如希望应用在每次登录 Mac 后自动运行，请开启“登录时自动运行”。若系统提示需要允许登录项，请前往 **系统设置 → 通用 → 登录项**，按提示允许“自动静音”运行。

“登录时自动运行”指完成用户登录后启动应用。平时合盖睡眠时，已经运行的应用会继续在下一次唤醒时发挥作用。

### 日常使用

通常无需额外操作：

> 合盖进入睡眠 → 尝试静音 → 开盖唤醒 → 再次静音 → 解锁后仍保持静音 → 手动开启声音

需要声音时，可以使用系统音量控制，或在菜单栏中选择“解除静音”。应用的手动静音和解除静音操作仅在当前输出为内置扬声器时生效。

菜单栏还提供以下选项：

| 选项 | 作用 |
| --- | --- |
| 立即静音 / 解除静音 | 手动控制内置扬声器 |
| 合盖时自动静音 | 在系统即将进入睡眠时执行静音 |
| 唤醒时自动静音 | 唤醒后执行静音，并在切回内置扬声器时静音 |
| 登录时自动运行 | 登录 Mac 后自动启动应用 |
| 设置… | 查看当前输出设备和状态，调整开关 |
| 退出 | 关闭应用，停止后续自动静音 |

### 卸载

1. 在菜单栏中关闭“登录时自动运行”。
2. 选择“退出”。
3. 在“应用程序”文件夹中，将“自动静音”移到废纸篓。

### 使用说明

- 应用需要保持运行才能自动静音，退出后不会继续处理睡眠和唤醒事件。
- “合盖静音”通过系统睡眠事件触发；若合盖后 Mac 仍在运行，例如使用外接显示器的合盖模式，这一步可能不会触发。
- 自动静音依赖系统通知和音频设备响应，无法保证所有设备和情况下都完全没有瞬间声音。
- 应用不会关闭彻底关机后的系统启动音；如有需要，请在 macOS“声音”设置中关闭“开机时播放声音”。

---

## English

Auto Mute is a macOS menu bar utility that automatically mutes your Mac’s **built-in speakers** before sleep and after wake. It does not restore sound when you unlock your Mac—you decide when to unmute.

### Features

- **Two opportunities to mute**: mutes before system sleep and again after wake, with brief retries.
- **Built-in speakers only**: leaves headphones, AirPods, Bluetooth devices, and USB speakers unchanged.
- **No automatic unmuting**: keeps the speakers muted after unlock until you manually unmute.
- **Protection when switching back**: with wake muting enabled, also mutes when the output switches back to the built-in speakers.
- **Menu bar access**: quick controls from a speaker icon, without a Dock icon.
- **Launch at login**: runs automatically in the background after you sign in.
- **Chinese and English**: follows your system language automatically. Quit and reopen the app after changing the system language.
- **Separate controls**: configure sleep muting, wake muting, and launch at login independently.

### Installation

1. Get the `自动静音.dmg` installer and double-click it.
2. Drag “Auto Mute” to the Applications folder.
3. Open Applications and double-click “Auto Mute”.
4. Find the speaker icon in the menu bar at the top of your screen.

### First-time Setup

Click the speaker icon and check that **Mute Before Sleep** and **Mute After Wake** are enabled.

To start the app each time you sign in, enable **Launch at Login**. If macOS asks for login item approval, go to **System Settings → General → Login Items** and follow the prompt to allow “Auto Mute”.

Launch at login starts the app after you sign in to your user account. During everyday lid-close sleep, an already-running app resumes its work when the Mac wakes.

### Everyday Use

Usually, no extra action is needed:

> Close the lid for sleep → attempt to mute → reopen and wake → mute again → stay muted after unlock → manually turn sound on

When you want sound, use the system volume controls or choose **Unmute** from the menu bar. The app’s manual mute and unmute controls work only when the current output is the built-in speakers.

The interface follows your system language. When using English, the menu provides:

| Menu option | What it does |
| --- | --- |
| Mute Now / Unmute | Mute / unmute the built-in speakers manually |
| Mute Before Sleep | Mute before the system goes to sleep |
| Mute After Wake | Mute after wake and when switching back to the built-in speakers |
| Launch at Login | Launch automatically after sign-in |
| Settings… | View the current output device and status, and adjust settings |
| Quit | Quit the app and stop future automatic muting |

### Uninstallation

1. Disable **Launch at Login** in the menu bar.
2. Choose **Quit**.
3. Move “Auto Mute” from Applications to the Trash.

### Notes

- The app must be running to mute automatically. Once you quit it, sleep and wake events are no longer handled.
- Lid-close muting is triggered by system sleep. If your Mac stays awake with the lid closed, such as when using an external display, this step may not run.
- Automatic muting depends on system notifications and the audio device’s response. It cannot guarantee zero brief sounds on every device or in every situation.
- The app does not disable the startup sound after a full shutdown. To disable it, turn off **Play sound on startup** in macOS Sound settings.
