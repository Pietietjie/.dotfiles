param(
    [Parameter(Position=0)]
    [string]$Direction
)

Write-Host "Direction: '$Direction'"

$config = "$env:APPDATA\alacritty\alacritty.toml"
Write-Host "Config path: $config"

$content = Get-Content -Path $config -Raw
Write-Host "Config loaded: $($content.Length) chars"

$match = [regex]::Match($content, 'opacity = ([\d.]+)')
Write-Host "Regex match success: $($match.Success)"
if (-not $match.Success) {
    Write-Host "ERROR: Could not find 'opacity = ...' in config"
    exit 1
}
Write-Host "Matched: '$($match.Value)'"

$current = [double]::Parse($match.Groups[1].Value, [System.Globalization.CultureInfo]::InvariantCulture)
Write-Host "Current opacity: $current"

$new = if ($Direction -eq '+') { [Math]::Min(1.0, $current + 0.05) } else { [Math]::Max(0.0, $current - 0.05) }
Write-Host "New opacity: $new"

$newStr = $new.ToString('F2', [System.Globalization.CultureInfo]::InvariantCulture)
Write-Host "New opacity string: '$newStr'"

$content = $content.Replace($match.Value, "opacity = $newStr")
Write-Host "Replacement: '$($match.Value)' -> 'opacity = $newStr'"

Set-Content -Path $config -Value $content -NoNewline
Write-Host "Config written successfully"
