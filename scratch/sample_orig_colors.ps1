Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile("g:\Shared drives\Webpage Design\Zapnova_image_icon.png")
$bmp = New-Object System.Drawing.Bitmap($img)
$img.Dispose()

$colors = @{}
for ($y = 0; $y -lt 100; $y++) {
    for ($x = 0; $x -lt 100; $x++) {
        $pixel = $bmp.GetPixel($x, $y)
        $hex = "#$($pixel.R.ToString('X2'))$($pixel.G.ToString('X2'))$($pixel.B.ToString('X2'))"
        $colors[$hex]++
    }
}
$colors.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 10 | Out-String | Write-Host
$bmp.Dispose()
