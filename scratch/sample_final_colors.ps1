Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile("g:\Shared drives\Webpage Design\Zapnova_logo_final.png")
$bmp = New-Object System.Drawing.Bitmap($img)
$img.Dispose()

$colors = @{}
# Sample the whole image
for ($y = 0; $y -lt $bmp.Height; $y += 5) {
    for ($x = 0; $x -lt $bmp.Width; $x += 5) {
        $pixel = $bmp.GetPixel($x, $y)
        if ($pixel.A -gt 0) {
            $hex = "#$($pixel.R.ToString('X2'))$($pixel.G.ToString('X2'))$($pixel.B.ToString('X2'))"
            $colors[$hex]++
        }
    }
}
$colors.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 20 | Out-String | Write-Host
$bmp.Dispose()
