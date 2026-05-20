Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile("g:\Shared drives\Webpage Design\Zapnova_text_final.png")
$bmp = New-Object System.Drawing.Bitmap($img)
$img.Dispose()

$width = $bmp.Width
$height = $bmp.Height
$newBmp = New-Object System.Drawing.Bitmap($width, $height)

for ($y = 0; $y -lt $height; $y++) {
    for ($x = 0; $x -lt $width; $x++) {
        $pixel = $bmp.GetPixel($x, $y)
        
        # Aggressive filter: keep only if it is clearly "Red"
        # and has significant alpha.
        # This will eliminate the pinkish anti-aliasing pixels (white lining).
        if ($pixel.A -gt 50 -and $pixel.R -gt ($pixel.G + 40) -and $pixel.R -gt ($pixel.B + 40)) {
            $newBmp.SetPixel($x, $y, $pixel)
        } else {
            $newBmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
        }
    }
}

$newBmp.Save("g:\Shared drives\Webpage Design\Zapnova_text_final_no_lining.png", [System.Drawing.Imaging.ImageFormat]::Png)
$newBmp.Dispose()
$bmp.Dispose()
Write-Host "Aggressive white-lining removal complete."
