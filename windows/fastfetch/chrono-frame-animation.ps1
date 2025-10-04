# Enable ANSI escape codes in Windows
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$frames = @(
    "C:\\Users\\nucle\\.config\\fastfetch\\chrono-frame-1.txt",
    "C:\\Users\\nucle\\.config\\fastfetch\\chrono-frame-2.txt", 
    "C:\\Users\\nucle\\.config\\fastfetch\\chrono-frame-3.txt",
    "C:\\Users\\nucle\\.config\\fastfetch\\chrono-frame-4.txt"
)

# Function to move cursor and overwrite
function Show-Frame {
    param($frameFile)
    
    # Move cursor to top and clear lines
    Write-Host "`e[H" -NoNewline
    
    # Read and display frame
    Get-Content $frameFile | ForEach-Object {
        Write-Host "`e[2K$_"  # Clear line and write new content
    }
}

# Animation loop
for ($i = 0; $i -lt $frames.Length; $i++) {
    Show-Frame $frames[$i]
    Start-Sleep -Milliseconds 800
}

# Keep final frame displayed
Write-Host ""
