Add-Type -AssemblyName System.Drawing
$img = New-Object System.Drawing.Bitmap('g:\Shared drives\Webpage Design\Copy of Zapnova ET Name Card-Ho.jpeg')
$minX = $img.Width; $maxX = 0; $minY = $img.Height; $maxY = 0;
# Scan the bottom-left quadrant for the Felix logo
for ($x = 0; $x -lt ($img.Width / 2); $x++) {
    for ($y = ($img.Height / 2); $y -lt $img.Height; $y++) {
        $pixel = $img.GetPixel($x, $y)
        if ($pixel.R -gt 200 -and $pixel.G -lt 100 -and $pixel.B -lt 100) {
            if ($x -lt $minX) { $minX = $x }
            if ($x -gt $maxX) { $maxX = $x }
            if ($y -lt $minY) { $minY = $y }
            if ($y -gt $maxY) { $maxY = $y }
        }
    }
}
if ($maxX -gt $minX) {
    # Add a tiny 2px padding to avoid cutting the edges
    $rect = New-Object System.Drawing.Rectangle(($minX-2), ($minY-2), ($maxX - $minX + 4), ($maxY - $minY + 4))
    $bmp = New-Object System.Drawing.Bitmap($rect.Width, $rect.Height)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.DrawImage($img, (New-Object System.Drawing.Rectangle(0, 0, $bmp.Width, $bmp.Height)), $rect, [System.Drawing.GraphicsUnit]::Pixel)
    $bmp.Save('g:\Shared drives\Webpage Design\felix_logo_clean.png', [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
    "Clean Felix logo detected and saved to felix_logo_clean.png"
} else {
    "Red logo not found in the expected area."
}
$img.Dispose()
