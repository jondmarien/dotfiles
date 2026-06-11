# burpcord-status.ps1
# Mirrors Burpcord's ActivityProvider priority system via Burp Suite REST API
# Burp REST API: http://127.0.0.1:1339 (default)
# Returns JSON matching the fields Burpcord sets in Discord RPC

param(
    [string]$BurpApiUrl = "http://127.0.0.1:1339",
    [string]$ApiKey     = "X54AuY8WQRQQnb5XsQ7VKXzHlTw4q9nB"   # Set your Burp REST API key here if required
)

$headers = @{ "Content-Type" = "application/json" }
if ($ApiKey -ne "") { $headers["Authorization"] = $ApiKey }

function Get-BurpStatus {
    # --- 1. Check if Burp is even running (process check first, cheap) ---
    $burpProc = Get-Process -ErrorAction SilentlyContinue |
                Where-Object { $_.ProcessName -in @("java", "javaw", "BurpSuite", "BurpSuitePro", "BurpSuiteCommunity") -and
                               $_.MainWindowTitle -like "*Burp Suite*" }

    if (-not $burpProc) {
        return [PSCustomObject]@{
            status      = "OFFLINE"
            activity    = "Burp Suite not running"
            detail      = "Not Detected"
            state       = "Offline"
            icon        = "offline"
            priority    = 99
        }
    }

    # --- 2. Probe REST API endpoints (mirrors Burpcord's provider priority) ---
    # Priority order from Burpcord source:
    #   ProxyHandler (10) > ScannerListener (20) > RepeaterListener (30)
    #   IntruderListener (40) > WebSocketListener (50) > SiteMapProvider (60)
    #   ScopeProvider (70) > CollaboratorProvider (80)

    try {
        # Scanner: active scans (priority 20 in Burpcord)
        $scans = $null
        try {
            $scanResp = Invoke-RestMethod -Uri "$BurpApiUrl/v0.1/scan" -Headers $headers -Method Get -TimeoutSec 2 -ErrorAction Stop
            $scans = $scanResp
        } catch { }

        $activeScanCount = 0
        $issueCount = 0
        if ($scans -and $scans.Count -gt 0) {
            $activeScanCount = ($scans | Where-Object { $_.scan_status -in @("running", "paused") }).Count
            $issueCount = ($scans | ForEach-Object { $_.issue_events.Count } | Measure-Object -Sum).Sum
            if (-not $issueCount) { $issueCount = 0 }
        }

        # Proxy: intercept status (priority 10 — highest)
        $interceptOn = $false
        try {
            $proxyResp = Invoke-RestMethod -Uri "$BurpApiUrl/v0.1/proxy/intercept_messages" -Headers $headers -Method Get -TimeoutSec 2 -ErrorAction Stop
            $interceptOn = ($proxyResp -and $proxyResp.Count -gt 0)
        } catch { }

        # Build response mirroring Burpcord's updatePresence() logic
        if ($interceptOn) {
            # Highest priority: proxy intercept active
            return [PSCustomObject]@{
                status   = "ACTIVE"
                activity = "Proxy Intercepting"
                detail   = "Intercepting HTTP Traffic"
                state    = "Proxy: Intercept ON"
                icon     = "proxy"
                priority = 10
            }
        }
        elseif ($activeScanCount -gt 0) {
            return [PSCustomObject]@{
                status   = "ACTIVE"
                activity = "Scanning Targets"
                detail   = "Active Scans: $activeScanCount"
                state    = "Issues Found: $issueCount"
                icon     = "scanner"
                priority = 20
            }
        }
        elseif ($issueCount -gt 0) {
            return [PSCustomObject]@{
                status   = "ACTIVE"
                activity = "Reviewing Results"
                detail   = "Scan Complete"
                state    = "Issues Found: $issueCount"
                icon     = "scanner"
                priority = 20
            }
        }
        else {
            # Burp is up, REST API responds, but no active task — idle
            return [PSCustomObject]@{
                status   = "IDLE"
                activity = "Security Researching"
                detail   = "Burp Suite Professional"
                state    = "Idle"
                icon     = "idle"
                priority = 100
            }
        }
    }
    catch {
        # Burp process running but REST API unreachable
        return [PSCustomObject]@{
            status   = "RUNNING"
            activity = "Burp Suite Running"
            detail   = "Burp Suite Professional"
            state    = "REST API Unavailable"
            icon     = "running"
            priority = 100
        }
    }
}

$result = Get-BurpStatus
$result | ConvertTo-Json -Compress
