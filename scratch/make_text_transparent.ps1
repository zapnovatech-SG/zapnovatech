Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile("g:\Shared drives\Webpage Design\Zapnova_logo_final.png")
$bmp = New-Object System.Drawing.Bitmap($img)
$img.Dispose()

$width = $bmp.Width
$height = $bmp.Height
$newBmp = New-Object System.Drawing.Bitmap($width, $height)

for ($y = 0; $y -lt $height; $y++) {
    for ($x = 0; $x -lt $width; $x++) {
        $pixel = $bmp.GetPixel($x, $y)
        
        # Bottom 30% area where the text "ZAPNOVA" resides
        if ($y -gt ($height * 0.7)) {
            # Target all white/near-white pixels in the text area
            if ($pixel.R -gt 220 -and $pixel.G -gt 220 -and $pixel.B -gt 220) {
                # Make transparent
                $newBmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 255, 255, 255))
            } else {
                $newBmp.SetPixel($x, $y, $pixel)
            }
        } else {
            # Machine area: keep as is (preserving its white parts)
            $newBmp.SetPixel($x, $y, $pixel)
        }
    }
}

$newBmp.Save("g:\Shared drives\Webpage Design\Zapnova_logo_final_text_transparent.png", [System.Drawing.Imaging.ImageFormat]::Png)
$newBmp.Dispose()
$bmp.Dispose()
Write-Host "Done! Saved as Zapnova_logo_final_text_transparent.png"
