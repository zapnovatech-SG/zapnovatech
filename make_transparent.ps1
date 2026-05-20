Add-Type -AssemblyName System.Drawing
$img = New-Object System.Drawing.Bitmap('g:\Shared drives\Webpage Design\kobird_logo.jpg')
$bmp = New-Object System.Drawing.Bitmap($img.Width, $img.Height)
$g = [System.Drawing.Graphics]::FromImage($bmp)

for ($x = 0; $x -lt $img.Width; $x++) {
    for ($y = 0; $y -lt $img.Height; $y++) {
        $pixel = $img.GetPixel($x, $y)
        # Check for near-white background (R, G, B > 240)
        if ($pixel.R -gt 240 -and $pixel.G -gt 240 -and $pixel.B -gt 240) {
            $bmp.SetPixel($x, $y, [System.Drawing.Color]::Transparent)
        } else {
            $bmp.SetPixel($x, $y, $pixel)
        }
    }
}

$bmp.Save('g:\Shared drives\Webpage Design\kobird_logo_transparent.png', [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose()
$bmp.Dispose()
$img.Dispose()
"Kobird logo converted to transparent PNG: kobird_logo_transparent.png"
