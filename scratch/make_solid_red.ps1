Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile("g:\Shared drives\Webpage Design\Zapnova_logo_final.png")
$bmp = New-Object System.Drawing.Bitmap($img)
$img.Dispose()

$width = $bmp.Width
$height = $bmp.Height
$newBmp = New-Object System.Drawing.Bitmap($width, $height)

$solidRed = [System.Drawing.Color]::FromArgb(255, 255, 0, 0)

for ($y = 0; $y -lt $height; $y++) {
    for ($x = 0; $x -lt $width; $x++) {
        $pixel = $bmp.GetPixel($x, $y)
        
        # Bottom 25% is where the text "ZAPNOVA" is
        if ($y -gt ($height * 0.75)) {
            # If it's white, near-white, or red, make it SOLID RED
            if ($pixel.A -gt 10) { # Not transparent
                if (($pixel.R -gt 200 -and $pixel.G -gt 200 -and $pixel.B -gt 200) -or ($pixel.R -gt 150 -and $pixel.G -lt 150 -and $pixel.B -lt 150)) {
                    $newBmp.SetPixel($x, $y, $solidRed)
                } else {
                    $newBmp.SetPixel($x, $y, $pixel)
                }
            } else {
                $newBmp.SetPixel($x, $y, $pixel)
            }
        } else {
            # Top 75% (Machine area) - Keep as is
            $newBmp.SetPixel($x, $y, $pixel)
        }
    }
}

$newBmp.Save("g:\Shared drives\Webpage Design\Zapnova_logo_final_solid_red.png", [System.Drawing.Imaging.ImageFormat]::Png)
$newBmp.Dispose()
$bmp.Dispose()
Write-Host "Done! Saved as Zapnova_logo_final_solid_red.png"
