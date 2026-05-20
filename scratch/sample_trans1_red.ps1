Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile("g:\Shared drives\Webpage Design\Zapnova_image_icon_transparent1.png")
$bmp = New-Object System.Drawing.Bitmap($img)
$img.Dispose()

$width = $bmp.Width
$height = $bmp.Height
$colors = @{}

# Sample the whole image for RED
for ($y = 0; $y -lt $height; $y += 20) {
    for ($x = 0; $x -lt $width; $x += 20) {
        $pixel = $bmp.GetPixel($x, $y)
        if ($pixel.R -gt 200 -and $pixel.G -lt 100 -and $pixel.B -lt 100) {
            $hex = "#$($pixel.R.ToString('X2'))$($pixel.G.ToString('X2'))$($pixel.B.ToString('X2'))"
            $colors[$hex]++
        }
    }
}
$colors.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 10 | ForEach-Object { Write-Host "$($_.Key) : $($_.Value)" }
$bmp.Dispose()
