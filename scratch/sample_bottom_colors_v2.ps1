Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile("g:\Shared drives\Webpage Design\Zapnova_logo_final.png")
$bmp = New-Object System.Drawing.Bitmap($img)
$img.Dispose()

$width = $bmp.Width
$height = $bmp.Height
$colors = @{}

# Sample the bottom 30%
for ($y = [int]($height * 0.7); $y -lt $height; $y++) {
    for ($x = 0; $x -lt $width; $x++) {
        $pixel = $bmp.GetPixel($x, $y)
        if ($pixel.A -gt 0) {
            $hex = "#$($pixel.R.ToString('X2'))$($pixel.G.ToString('X2'))$($pixel.B.ToString('X2'))"
            $colors[$hex]++
        }
    }
}
$colors.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 20 | ForEach-Object { Write-Host "$($_.Key) : $($_.Value)" }
$bmp.Dispose()
