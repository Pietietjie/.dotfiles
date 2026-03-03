param(
    [Parameter(Position=0)]
    [string]$Direction
)

$config = "$env:APPDATA\alacritty\alacritty.toml"
$content = Get-Content -Path $config -Raw
$match = [regex]::Match($content, 'opacity = ([\d.]+)')
if (-not $match.Success) { exit 1 }

$current = [double]::Parse($match.Groups[1].Value, [System.Globalization.CultureInfo]::InvariantCulture)
$new = if ($Direction -eq '+') { [Math]::Min(1.0, $current + 0.05) } else { [Math]::Max(0.0, $current - 0.05) }
$newStr = $new.ToString('F2', [System.Globalization.CultureInfo]::InvariantCulture)

$content = $content.Replace($match.Value, "opacity = $newStr")
Set-Content -Path $config -Value $content -NoNewline
