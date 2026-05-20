Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile("g:\Shared drives\Webpage Design\Zapnova_image_icon.png")
$bmp = New-Object System.Drawing.Bitmap($img)
$img.Dispose()

$width = $bmp.Width
$height = $bmp.Height
$colors = @{}

for ($y = 0; $y -lt $height; $y += 5) {
    for ($x = 0; $x -lt $width; $x += 5) {
        $pixel = $bmp.GetPixel($x, $y)
        if ($pixel.R -lt 255 -or $pixel.G -lt 255 -or $pixel.B -lt 255) {
            $hex = "#$($pixel.R.ToString('X2'))$($pixel.G.ToString('X2'))$($pixel.B.ToString('X2'))"
            $colors[$hex]++
        }
    }
}
$colors.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 20 | ForEach-Object { Write-Host "$($_.Key) : $($_.Value)" }
$bmp.Dispose()
