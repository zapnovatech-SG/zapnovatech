Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile("g:\Shared drives\Webpage Design\Zapnova_logo_final.png")
$bmp = New-Object System.Drawing.Bitmap($img)
$img.Dispose()

$width = $bmp.Width
$height = $bmp.Height

# We'll fill all transparency in the machine area that is NOT the background.
# How to define background? Pixels reachable from (0,0) without passing through "dark" pixels.
# The machine body is white. We want to fill it.

$newBmp = New-Object System.Drawing.Bitmap($width, $height)
# Copy original
for ($y = 0; $y -lt $height; $y++) {
    for ($x = 0; $x -lt $width; $x++) {
        $newBmp.SetPixel($x, $y, $bmp.GetPixel($x, $y))
    }
}

# Fill a specific box area that represents the machine body
# Based on the screenshot, it's roughly the middle part.
# Let's be more precise: any transparent pixel in the top 75% 
# that is surrounded by white/black should be white.

for ($y = 1; $y -lt ($height * 0.7); $y++) {
    for ($x = 1; $x -lt ($width - 1); $x++) {
        $pixel = $newBmp.GetPixel($x, $y)
        if ($pixel.A -lt 50) { # Transparent
            # Check if this is "inside" the machine.
            # If we find white or black pixels to the left, right, top, and bottom, it's likely inside.
            $hasLeft = $false; for ($tx = 0; $tx -lt $x; $tx++) { if ($newBmp.GetPixel($tx, $y).A -gt 200) { $hasLeft = $true; break } }
            $hasRight = $false; for ($tx = $x + 1; $tx -lt $width; $tx++) { if ($newBmp.GetPixel($tx, $y).A -gt 200) { $hasRight = $true; break } }
            $hasTop = $false; for ($ty = 0; $ty -lt $y; $ty++) { if ($newBmp.GetPixel($x, $ty).A -gt 200) { $hasTop = $true; break } }
            $hasBottom = $false; for ($ty = $y + 1; $ty -lt ($height * 0.75); $ty++) { if ($newBmp.GetPixel($x, $ty).A -gt 200) { $hasBottom = $true; break } }
            
            if ($hasLeft -and $hasRight -and $hasTop -and $hasBottom) {
                $newBmp.SetPixel($x, $y, [System.Drawing.Color]::White)
            }
        }
    }
}

$newBmp.Save("g:\Shared drives\Webpage Design\Zapnova_logo_final_filled.png", [System.Drawing.Imaging.ImageFormat]::Png)
$newBmp.Dispose()
$bmp.Dispose()
Write-Host "Machine body filled with white."
