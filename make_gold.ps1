Add-Type -AssemblyName System.Drawing
$img = New-Object System.Drawing.Bitmap('g:\Shared drives\Webpage Design\kobird_logo_white.png')
$bmp = New-Object System.Drawing.Bitmap($img.Width, $img.Height)

# Gold color: #D4AF37 -> R: 212, G: 175, B: 55
$goldColor = [System.Drawing.Color]::FromArgb(255, 212, 175, 55)

for ($x = 0; $x -lt $img.Width; $x++) {
    for ($y = 0; $y -lt $img.Height; $y++) {
        $pixel = $img.GetPixel($x, $y)
        # If the pixel is opaque (white), change it to gold
        if ($pixel.A -gt 0) {
            # Blend the gold color with the original alpha for anti-aliasing
            $newColor = [System.Drawing.Color]::FromArgb($pixel.A, 212, 175, 55)
            $bmp.SetPixel($x, $y, $newColor)
        } else {
            $bmp.SetPixel($x, $y, [System.Drawing.Color]::Transparent)
        }
    }
}

$bmp.Save('g:\Shared drives\Webpage Design\kobird_logo_gold.png', [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
$img.Dispose()
"Kobird logo transformed to gold: kobird_logo_gold.png"
