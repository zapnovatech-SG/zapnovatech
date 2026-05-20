Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile("g:\Shared drives\Webpage Design\Zapnova_logo_final.png")
$bmp = New-Object System.Drawing.Bitmap($img)
$img.Dispose()

$width = $bmp.Width
$height = $bmp.Height

$top = $height
$bottom = 0
$left = $width
$right = 0

for ($y = 0; $y -lt $height; $y++) {
    for ($x = 0; $x -lt $width; $x++) {
        $pixel = $bmp.GetPixel($x, $y)
        # Very aggressive: anything with alpha > 10 is content
        if ($pixel.A -gt 10) {
            if ($x -lt $left) { $left = $x }
            if ($x -gt $right) { $right = $x }
            if ($y -lt $top) { $top = $y }
            if ($y -gt $bottom) { $bottom = $y }
        }
    }
}

$cWidth = $right - $left + 1
$cHeight = $bottom - $top + 1

if ($cWidth -gt 0 -and $cHeight -gt 0) {
    $rect = New-Object System.Drawing.Rectangle($left, $top, $cWidth, $cHeight)
    $cropped = $bmp.Clone($rect, $bmp.PixelFormat)
    $cropped.Save("g:\Shared drives\Webpage Design\Zapnova_logo_final_tight.png", [System.Drawing.Imaging.ImageFormat]::Png)
    $cropped.Dispose()
    Write-Host "Tight crop saved. Size: $cWidth x $cHeight"
    Write-Host "Original was: $width x $height"
} else {
    Write-Host "No content found."
}

$bmp.Dispose()
