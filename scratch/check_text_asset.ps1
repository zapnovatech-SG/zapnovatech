Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile("g:\Shared drives\Webpage Design\Zapnova_text.png")
Write-Host "Width: $($img.Width)"
Write-Host "Height: $($img.Height)"

$bmp = New-Object System.Drawing.Bitmap($img)
$img.Dispose()

$colors = @{}
# Sample 100x100 corner
for ($y = 0; $y -lt 100; $y++) {
    for ($x = 0; $x -lt 100; $x++) {
        $pixel = $bmp.GetPixel($x, $y)
        $hex = "#$($pixel.R.ToString('X2'))$($pixel.G.ToString('X2'))$($pixel.B.ToString('X2'))"
        $colors[$hex]++
    }
}
$colors.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 5 | ForEach-Object { Write-Host "$($_.Key) : $($_.Value)" }
$bmp.Dispose()
