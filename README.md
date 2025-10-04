# Windows 11 Dotfiles Configuration

A comprehensive Windows 11 desktop environment configuration featuring tiling window management, custom terminal setup, and integrated system monitoring.

## System Overview

This repository contains configuration files for a fully customized Windows 11 development and daily-use environment. The setup prioritizes keyboard-driven workflow, visual consistency, and seamless integration between components.

### Core Components

**Window Management**
- **GlazeWM**: Primary tiling window manager with 9 workspaces across dual monitors
- **komorebi**: Alternative tiling window manager (identical workspace configuration)
- **YASB**: Custom status bar with system monitoring, workspace indicators, and media controls
- **tacky-borders**: Visual window border effects
- **whkd**: Windows hotkey daemon for global keybindings

**Terminal Environment**
- **WezTerm**: GPU-accelerated terminal emulator with modular Lua configuration
- **PowerShell 7**: Primary shell with extensive customization
- **oh-my-posh**: Cross-shell prompt theme engine (Catppuccin Mocha)
- **starship**: Alternative cross-shell prompt
- **fastfetch**: System information display with custom CHRON0'S-R1G branding

**Shell Enhancement Tools**
- **zoxide**: Smart directory navigation (replaces cd)
- **eza**: Modern ls replacement with icons
- **Terminal-Icons**: File and folder icons in terminal
- **posh-git**: Git status integration in prompt

## Architecture Highlights

### Modular Terminal Configuration

WezTerm uses a split-module architecture for maintainability:

```
wezterm/
├── wezterm.lua      # Main entry, platform detection, domain configuration
├── keys.lua         # Complete keybinding setup
├── fonts.lua        # Font configuration
├── decoration.lua   # Visual styling and tab formatting
└── work.lua         # Optional work-specific overrides (not tracked)
```

This separation allows easy customization of specific aspects without touching unrelated configuration.

### Dual Monitor Workspace Layout

Workspaces are distributed across two monitors for optimal workflow:

**Primary Monitor (0)**: Entertainment and gaming
- Workspace 1: Gaming
- Workspace 8: Tools
- Workspace 9: TV/Movies

**Secondary Monitor (1)**: Productivity and development
- Workspace 2: Web browsing
- Workspace 3: Code editor
- Workspace 4: Hacking/Security tools
- Workspace 5: Messaging (Discord, etc.)
- Workspace 6: Multimedia (Spotify)
- Workspace 7: Streaming/Broadcasting

### Intelligent Window Rules

Both window managers implement sophisticated rules for gaming applications:

**Floating Windows**: Game launchers and clients
- League Client, Riot Client
- Epic Games Launcher
- Steam client
- Game library interfaces

**Ignored Windows**: Fullscreen games
- League of Legends (in-game)
- Fortnite (in-game)
- Minecraft
- Unity/Unreal Engine games
- SDL-based applications

This prevents window manager interference with fullscreen games while keeping launchers accessible.

## PowerShell Profile Features

The PowerShell profile (`windows/pwsh/Microsoft.PowerShell_profile.ps1`) implements a robust initialization sequence:

1. **Path Management**: Ensures Scoop and WindowsApps are prioritized
2. **Conditional Module Loading**: Safely imports available modules (Chocolatey, gsudoModule, Terminal-Icons, posh-git)
3. **Prompt Customization**: oh-my-posh with Catppuccin theme
4. **Smart Navigation**: zoxide integration with custom aliases
5. **Visual Feedback**: Custom CHRON0'S-R1G ASCII banner and fastfetch system info

### Key Aliases and Functions

- `cd` → Smart directory jump via zoxide
- `cdi` → Interactive directory search
- `deact` → Virtual environment deactivation with profile reload
- `eza` → Enhanced file listing with icons
- `wal` → pywal color scheme management

## YASB Status Bar

The status bar is organized into three logical groupers:

**Left Section**
- Home menu with quick access links
- Recycle bin indicator
- Windows Update check
- Window manager controls

**Center Section**
- Notification widgets (OBS, GitHub, notes)
- Application launcher
- Clock with calendar popup
- Weather widget
- Wallpaper switcher

**Right Section**
- Active taskbar with window icons
- Media player controls
- System monitor (CPU, Memory, GPU, Disk)
- Bluetooth status
- Power menu

## WezTerm Keybinding Philosophy

Custom keybindings designed to minimize conflicts with PowerShell and other applications:

**Tab Management**
- `Ctrl+1-5`: Direct tab switching
- `Ctrl+Tab` / `Ctrl+Shift+Tab`: Navigate tabs sequentially
- `Ctrl+W`: Close current tab

**Pane Management**
- `Ctrl+Shift+Alt+H`: Split pane horizontally
- `Ctrl+Shift+Alt+X`: Close current pane
- `Ctrl+Z`: Toggle pane zoom

**Terminal Features**
- `Ctrl+F`: Search in scrollback
- `Ctrl+K`: Clear scrollback
- `Ctrl+Alt+O`: Toggle opacity (1.0 ↔ 0.5)
- `Ctrl+Up/Down`: Navigate between prompts (VSCode-style)

**Disabled Keybindings**
- `Shift+Ctrl+Left/Right`: Preserved for PowerShell word navigation

## Configuration Locations

Standard configuration paths follow Windows conventions:

```
C:\Users\nucle\
├── .config\
│   ├── fastfetch\config.jsonc
│   ├── komorebi\komorebi.json
│   └── yasb\
│       ├── config.yaml
│       └── styles.css
├── .glzr\glazewm\config.yaml
├── .wezterm.lua (symlinked to dotfiles)
├── scoop\apps\oh-my-posh\current\themes\
└── Documents\PowerShell\Microsoft.PowerShell_profile.ps1
```

## Quick Start Commands

### Reload Configurations

```powershell
# PowerShell profile
. $PROFILE

# WezTerm (in terminal)
Ctrl+R

# GlazeWM
Alt+Shift+R
```

### Query Window Manager State

```powershell
# GlazeWM window information
glazewm.exe command "query windows"

# komorebi window information
komorebic query windows
```

### Verify Tool Installation

```powershell
# Check essential tools
Get-Command oh-my-posh, fastfetch, zoxide, eza | Format-Table Name, Source

# Check loaded PowerShell modules
Get-Module
```

## Workspace Navigation

### GlazeWM Shortcuts

**Focus Workspaces**: `Alt+1` through `Alt+9`

**Move Windows**: `Alt+Shift+1` through `Alt+Shift+9` (moves and follows)

**Window States**
- `Alt+Shift+Space`: Toggle floating
- `Alt+Shift+T`: Toggle tiling
- `Alt+Shift+F`: Toggle fullscreen
- `Alt+Shift+Q`: Close window

**Window Movement**
- `Alt+H/J/K/L`: Move focus (Vim-style)
- `Alt+Shift+H/J/K/L`: Move window

**Resize Mode**: `Alt+Shift+R` (then use H/J/K/L or arrow keys)

## Integration Features

### WSL Support

WezTerm includes configured WSL domains:
- `WSL:Ubuntu`: Ubuntu distribution
- `WSL:Kali`: Kali Linux distribution

To default to WSL on startup, uncomment in `wezterm.lua`:
```lua
config.default_domain = 'WSL:Kali'
```

### Wallpaper Management

The YASB wallpaper widget integrates with pywal for automatic color scheme generation:

```yaml
run_after:
  - "wal -i '{image}'"
  - "pwsh -File C:\Users\nucle\.config\yasb\inject-wal-colors.ps1"
```

Wallpapers are loaded from: `C:\Users\nucle\Downloads\wALLpapers`

### OBS Integration

YASB includes live OBS recording status:
- Host: 192.168.2.38:4455
- Shows recording/paused/stopped state
- Blinking icon during recording
- Hidden when not recording

## Development Notes

### Safe Module Loading Pattern

The PowerShell profile uses defensive programming for module imports:

```powershell
foreach ($m in 'gsudoModule', 'Terminal-Icons', 'posh-git') {
    if (Get-Module -ListAvailable -Name $m) {
        Import-Module $m -ErrorAction SilentlyContinue
    }
}
```

This ensures the profile loads successfully even when modules are missing.

### zoxide Initialization

Custom initialization to support aliasing:

```powershell
Invoke-Expression (& { (zoxide init powershell --no-cmd | Out-String) })
Set-Alias -Name cd -Value __zoxide_z -Option AllScope -Scope Global -Force
Set-Alias -Name cdi -Value __zoxide_zi -Option AllScope -Scope Global -Force
```

### WezTerm Platform Detection

The configuration detects Windows 11 vs. other platforms:

```lua
local _, stdout, _ = wezterm.run_child_process({ "cmd.exe", "ver" })
local _, _, build, _ = stdout:match("Version ([0-9]+)%.([0-9]+)%.([0-9]+)%.([0-9]+)")
is_windows_11 = tonumber(build) >= 22000
```

This enables Windows 11-specific features like acrylic effects and modern window decorations.

## Troubleshooting

### Window Manager Conflicts

GlazeWM and komorebi cannot run simultaneously:

```powershell
# Stop komorebi before starting GlazeWM
Get-Process komorebi -ErrorAction SilentlyContinue | Stop-Process
glazewm.exe start
```

### Terminal Icons Missing

Verify Nerd Font installation and tool availability:

```powershell
Get-Command oh-my-posh, fastfetch | Format-Table Name, Source
```

Font used: **CaskaydiaMono Nerd Font** at 18pt

### zoxide Not Working

Check if zoxide is in PATH and properly initialized:

```powershell
Get-Command zoxide
zoxide query --list  # Should show tracked directories
```

### YASB Status Bar Issues

1. Verify GlazeWM is running: `Get-Process glazewm`
2. Check config syntax: `C:\Users\nucle\.config\yasb\config.yaml`
3. Review YASB logs (if available)
4. Restart via GlazeWM startup commands

## Version Control

This repository uses conventional commits for clear history:

```powershell
# Feature addition
git commit -m "feat(glazewm): add gaming window ignore rules"

# Configuration update
git commit -m "config(yasb): update system monitor layout"

# Breaking change
git commit -m "feat(wezterm)!: restructure keybindings

BREAKING CHANGE: Ctrl+Shift arrow keys now reserved for pane navigation"
```

## Security Notes

**API Keys and Tokens**: Several configuration files contain hardcoded credentials:
- YASB weather API key
- OBS WebSocket password
- GitHub token (currently empty)

Consider using environment variables for sensitive data in production setups.

## License

Personal dotfiles configuration - use and modify as needed.

## Additional Resources

For detailed architecture information and development guidance, see `WARP.md`.
