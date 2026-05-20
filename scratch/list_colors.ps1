Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile("g:\Shared drives\Webpage Design\Zapnova_logo_final.png")
$bmp = New-Object System.Drawing.Bitmap($img)
$img.Dispose()

$colors = @{}
for ($y = 0; $y -lt $bmp.Height; $y += 2) {
    for ($x = 0; $x -lt $bmp.Width; $x += 2) {
        $pixel = $bmp.GetPixel($x, $y)
        if ($pixel.A -gt 0) {
            $hex = "#$($pixel.R.ToString('X2'))$($pixel.G.ToString('X2'))$($pixel.B.ToString('X2'))"
            $colors[$hex]++
        }
    }
}
$colors.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 50 | ForEach-Object { Write-Host "$($_.Key) : $($_.Value)" }
$bmp.Dispose()
