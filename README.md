# Nightmare-Kart-SpeedRunTool

## Keybinds

| Key | Action |
|---|---|
| `F1` | NoClip |
| `W A S D` | Move |
| `Q E` | Down / Up |
| `Numpad 4 / 6` | Yaw |
| `Numpad 8 / 5` | Pitch |
| `F2` | Save Position / Rotation / Velocity |
| `F3` | Restore Position / Rotation / Velocity |
| `F4` | Slow NoClip Speed |
| `F5` | Fast NoClip Speed |
| `F8` | Show Object Visible |
| `F9` | Visible Floor / Hide Floor |
| `F12` | Teleport (same as console `Teleport` command) |
| `INSERT` | Toggle Debug Camera (same as console `ToggleDebugCamera` command) |
| `DELETE` | Change ViewMode between Lit / Unlit |

---

## Install UE4SS (experimental-latest)

Download: [UE4SS-RE/RE-UE4SS — experimental-latest](https://github.com/UE4SS-RE/RE-UE4SS/releases/tag/experimental-latest)

File: `UE4SS_v3.0.1-xxxx-xxxxxx.zip`

**Unzip UE4SS to:**
```
Root\NMKART\Binaries\Win64
```

You should now see:
```
Root\NMKART\Binaries\Win64\NMKART-Win64-Shipping.exe
Root\NMKART\Binaries\Win64\ue4ss
Root\NMKART\Binaries\Win64\dwmapi.dll
```

**Open the UE4SS console** by editing:
```
ue4ss/UE4SS-settings.ini
```

```ini
[Debug]
; Whether to enable the external UE4SS debug console.
ConsoleEnabled = 0
GuiConsoleEnabled = 1   ; Set 1
GuiConsoleVisible = 1   ; Set 1
```

---

## Install the Mod

**Unzip `SpeedRunTool.zip` to:**
```
Root\NMKART\Binaries\Win64\ue4ss\mods
```

Result:
```
Root\NMKART\Binaries\Win64\ue4ss\mods\SpeedRunTool
Root\NMKART\Binaries\Win64\ue4ss\mods\SpeedRunTool\Scripts\main.lua
```

**Modify `mods.txt`** — add:
```
SpeedRunTool : 1
```

---

## View Collision

Edit:
```
%LOCALAPPDATA%\NMKART\Saved\Config\WindowsNoEditor\Engine.ini
```

```ini
[SystemSettings]
r.ForceDebugViewModes=1
```

## Reference

https://forums.unrealengine.com/t/buffer-visualization-in-executable-build-of-my-project/27059/6
