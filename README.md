# Nightmare-Kart-SpeedRunTool

F1 NoClip
  W A S D Move
  Numpad 4 6 Yaw
  Numpad 8 5 Pitch
F2 Save Position Rotation Velocity
F3 Restore Position Rotation Velocity
F4 Slow NoClip Speed
F5 Fast NoClip Speed
F8 Show Object Visible
F8 Hide Floor

F12 Telelport same in console input Teleport
INSERT ToggleDebugCamera same in console input ToggleDebugCamera
DELETE Change ViewMode Between Lit / Unlit


# Install UE4SS experimental-latest
https://github.com/UE4SS-RE/RE-UE4SS/releases/tag/experimental-latest
UE4SS_v3.0.1-xxxx-xxxxxx.zip

Put to 
Root\NMKART\Binaries\Win64
Will Seen NMKART-Win64-Shipping.exe

UnZip UE4SS
Root\NMKART\Binaries\Win64\NMKART-Win64-Shipping.exe
Root\NMKART\Binaries\Win64\ue4ss
Root\NMKART\Binaries\Win64\dwmapi.dll

Open UE4SS Console

ue4ss/UE4SS-settings.ini

[Debug]
; Whether to enable the external UE4SS debug console.
ConsoleEnabled = 0
GuiConsoleEnabled = 1 // Set 1
GuiConsoleVisible = 1 // Set 1

Install Mod

Unzip SpeedRunTool.zip
To
Root\NMKART\Binaries\Win64\ue4ss\mods

Root\NMKART\Binaries\Win64\ue4ss\mods\SpeedRunTool
Root\NMKART\Binaries\Win64\ue4ss\mods\SpeedRunTool\Scripts\main.lua

Modify mods.txt

Add SpeedRunTool : 1

View Collision

```text
%LOCALAPPDATA%\NMKART\Saved\Config\WindowsNoEditor\Engine.ini
```

[SystemSettings]
r.ForceDebugViewModes=1
