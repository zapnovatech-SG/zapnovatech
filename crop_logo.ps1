Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile("g:\Shared drives\Webpage Design\sanko_logo_final.png")
$bmp = New-Object System.Drawing.Bitmap($img)
$img.Dispose()

$top = $bmp.Height
$bottom = 0
$left = $bmp.Width
$right = 0

for ($y = 0; $y -lt $bmp.Height; $y++) {
    for ($x = 0; $x -lt $bmp.Width; $x++) {
        $pixel = $bmp.GetPixel($x, $y)
        if ($pixel.A -gt 0) {
            if ($x -lt $left) { $left = $x }
            if ($x -gt $right) { $right = $x }
            if ($y -lt $top) { $top = $y }
            if ($y -gt $bottom) { $bottom = $y }
        }
    }
}

$width = $right - $left + 1
$height = $bottom - $top + 1

if ($width -gt 0 -and $height -gt 0) {
    $rect = New-Object System.Drawing.Rectangle($left, $top, $width, $height)
    $cropped = $bmp.Clone($rect, $bmp.PixelFormat)
    $cropped.Save("g:\Shared drives\Webpage Design\sanko_logo_cropped.png", [System.Drawing.Imaging.ImageFormat]::Png)
    $cropped.Dispose()
    Write-Host "Cropped image saved to sanko_logo_cropped.png. Size: $width x $height"
} else {
    Write-Host "No non-transparent pixels found."
}

$bmp.Dispose()
