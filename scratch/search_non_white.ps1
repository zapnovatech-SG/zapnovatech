Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile("g:\Shared drives\Webpage Design\Zapnova_image_icon.png")
$bmp = New-Object System.Drawing.Bitmap($img)
$img.Dispose()

$width = $bmp.Width
$height = $bmp.Height
$found = $false

for ($y = [int]($height * 0.8); $y -lt $height; $y++) {
    for ($x = 0; $x -lt $width; $x++) {
        $pixel = $bmp.GetPixel($x, $y)
        if ($pixel.R -lt 250 -or $pixel.G -lt 250 -or $pixel.B -lt 250) {
            Write-Host "Found non-white at ($x, $y): #$($pixel.R.ToString('X2'))$($pixel.G.ToString('X2'))$($pixel.B.ToString('X2'))"
            $found = $true
            break
        }
    }
    if ($found) { break }
}

if (-not $found) { Write-Host "Bottom 20% is pure white." }
$bmp.Dispose()
