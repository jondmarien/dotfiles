# =============================================================================
# PATH FIXES - Ensure Scoop and WindowsApps are in PATH before anything else
# =============================================================================

#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module
# Only import WinGet CommandNotFound module on Windows PowerShell (not PowerShell Core)
if ($PSVersionTable.PSEdition -eq 'Desktop') {
    Import-Module -Name Microsoft.WinGet.CommandNotFound -ErrorAction SilentlyContinue
}
else {
    Write-Verbose "Skipping WinGet CommandNotFound module on PowerShell Core to avoid exceptions"
}
#f45873b3-b655-43a6-b217-97c00aa0db58

# =============================================================================
#
# Import Modules
#

# Safe-load Chocolatey profile if present
if ($env:ChocolateyInstall) {
    $chocoProfile = Join-Path $env:ChocolateyInstall 'helpers\chocolateyProfile.psm1'
    if (Test-Path $chocoProfile) {
        Import-Module $chocoProfile -ErrorAction SilentlyContinue
    }
}

# Safe-load optional modules if installed
foreach ($m in 'gsudoModule', 'Terminal-Icons', 'posh-git') {
    if (Get-Module -ListAvailable -Name $m) {
        Import-Module $m -ErrorAction SilentlyContinue
    }
}

# =============================================================================
#
# oh-my-posh configs
#

# Use oh-my-posh if available (fallback to default config if theme not found)
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    $ompArgs = @('init', 'pwsh')
    $ompCfg = 'C:\Users\nucle\scoop\apps\oh-my-posh\current\themes\catppuccin_mocha.omp.json'
    if (Test-Path $ompCfg) { $ompArgs += @('--config', $ompCfg) }
    & oh-my-posh @ompArgs | Invoke-Expression
}
else {
    Write-Verbose 'oh-my-posh not found; skipping prompt init'
}

# =============================================================================
#
# Custom Invoke Commands
#

function Invoke-Deactivate {
    if (Get-Command deactivate -ErrorAction SilentlyContinue) {
        deactivate
        Remove-Item Env:VIRTUAL_ENV -ErrorAction SilentlyContinue
        . $PROFILE
    }
}
Set-Alias -Name "deact" -Value "Invoke-Deactivate"

# =============================================================================
#
# Initialize zoxide (smart cd command)
#

# Initialize zoxide without default commands so we can set custom aliases
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    try {
        Invoke-Expression (& { (zoxide init powershell --no-cmd | Out-String) })
        
        # Set custom aliases: 'cd' for zoxide jump, 'cdi' for interactive search
        Set-Alias -Name cd -Value __zoxide_z -Option AllScope -Scope Global -Force
        Set-Alias -Name cdi -Value __zoxide_zi -Option AllScope -Scope Global -Force
    }
    catch {
        Write-Warning "Failed to initialize zoxide: $_"
    }
}
else {
    Write-Verbose "zoxide not found in PATH; skipping zoxide initialization"
}

function eza { eza.exe --icons=always $args }

function wal { python -m pywal @args }

# if (!(Get-Process whkd -ErrorAction SilentlyContinue))
# {
#   Start-Process whkd -WindowStyle hidden
# }

# =============================================================================
#
# Only run refreshenv in interactive sessions (not when running scripts)
#

if ([Environment]::UserInteractive -and $Host.Name -eq 'ConsoleHost') {
    # Check if refreshenv command exists before calling it
    if (Get-Command refreshenv -ErrorAction SilentlyContinue) {
        refreshenv > $null 2>&1
    }
}

# =============================================================================
#
# PROFILE ART WHEN SHELL STARTS UP 
#

# Hacker-style CHRON0'S-R1G ASCII art
function Show-ChronHackerBanner {
    $banner = @(
        "`e[1;32m  ____ _   _ ____   ___  _   _  ___  _ ____        ____  _  ____ `e[0m",
        "`e[1;35m / ___| | | |  _ \ / _ \| \ | |/ _ \( ) ___|      |  _ \/ |/ ___| `e[0m",
        "`e[1;33m| |   | |_| | |_) | | | |  \| | | | |/\___ \ _____| |_) | | |  _  `e[0m",
        "`e[1;32m| |___|  _  |  _ <| |_| | |\  | |_| |  ___) |_____|  _ <| | |_| | `e[0m",
        "`e[1;35m \____|_| |_|_| \_\\___/|_| \_|\___/  |____/      |_| \_\_|\____| `e[0m"
    )
    
    Write-Host ""
    foreach ($line in $banner) {
        Write-Host $line
    }
    Write-Host ""
}

# Display banner at startup
Show-ChronHackerBanner

# =============================================================================
#
# fastfetch + custom logo
#

if (Get-Command fastfetch -ErrorAction SilentlyContinue) {
    fastfetch --config "C:\Users\nucle\.config\fastfetch\config.jsonc"
}

$Env:KOMOREBI_CONFIG_HOME = 'C:\Users\nucle\.config\komorebi'