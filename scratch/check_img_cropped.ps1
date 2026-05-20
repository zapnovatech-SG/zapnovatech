Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile("g:\Shared drives\Webpage Design\Zapnova_image_icon_cropped.png")
Write-Host "Width: $($img.Width)"
Write-Host "Height: $($img.Height)"
$img.Dispose()
