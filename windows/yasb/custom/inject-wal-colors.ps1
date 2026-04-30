# PowerShell script to inject pywal colors into yasb styles.css
$colorsPath = "$HOME\\.cache\\wal\\colors.json"
$stylesPath = "$HOME\\.config\\yasb\\styles.css"

if (!(Test-Path $colorsPath)) {
    Write-Host "colors.json not found. Run wal first."
    exit 1
}

$rawJson = Get-Content -Raw -Path $colorsPath
$rawJson = $rawJson -replace '\\', '\\\\'
$colors = $rawJson | ConvertFrom-Json
$variablesSection = @"
:root {
    /* Special */
    --backgroundcol: var(--colors0);
    --foregroundcol: var(--colors15);
    --cursorcol: var(--colors15);
    /* 16 pywal colors */
    --colors0: $($colors.colors.color0);
    --colors1: $($colors.colors.color1);
    --colors2: $($colors.colors.color2);
    --colors3: $($colors.colors.color3);
    --colors4: $($colors.colors.color4);
    --colors5: $($colors.colors.color5);
    --colors6: $($colors.colors.color6);
    --colors7: $($colors.colors.color7);
    --colors8: $($colors.colors.color8);
    --colors9: $($colors.colors.color9);
    --colors10: $($colors.colors.color10);
    --colors11: $($colors.colors.color11);
    --colors12: $($colors.colors.color12);
    --colors13: $($colors.colors.color13);
    --colors14: $($colors.colors.color14);
    --colors15: $($colors.colors.color15);
    /* Theme compatibility variables */
    --mantle: $($colors.colors.color0);
    --base: $($colors.colors.color1);
    --surface1: $($colors.colors.color2);
    --text: $($colors.colors.color15);
    --icon: $($colors.colors.color7);
    --mauve: $($colors.colors.color5);
    --sapphire: $($colors.colors.color4);
    --red: $($colors.colors.color1);
    --fadedgreen: $($colors.colors.color2);
}
"@

$stylesContent = Get-Content -Raw -Path $stylesPath

# Find the start and end of the :root block
$rootStart = $stylesContent.IndexOf(":root")
if ($rootStart -ge 0) {
    # Find the opening brace
    $braceStart = $stylesContent.IndexOf("{", $rootStart)
    if ($braceStart -ge 0) {
        # Count braces to find the matching closing brace
        $braceCount = 1
        $pos = $braceStart + 1
        while ($pos -lt $stylesContent.Length -and $braceCount -gt 0) {
            if ($stylesContent[$pos] -eq '{') {
                $braceCount++
            } elseif ($stylesContent[$pos] -eq '}') {
                $braceCount--
            }
            $pos++
        }
        
        if ($braceCount -eq 0) {
            # Replace the entire :root block
            $beforeRoot = $stylesContent.Substring(0, $rootStart)
            $afterRoot = $stylesContent.Substring($pos)
            $newStylesContent = $beforeRoot + $variablesSection + $afterRoot
        } else {
            # Fallback: append if we can't find proper closing brace
            $newStylesContent = "$variablesSection`n$stylesContent"
        }
    } else {
        # Fallback: append if we can't find opening brace
        $newStylesContent = "$variablesSection`n$stylesContent"
    }
} else {
    # No :root found, prepend it
    $newStylesContent = "$variablesSection`n$stylesContent"
}
$newStylesContent = $newStylesContent.TrimEnd()
$newStylesContent | Set-Content -Path $stylesPath
