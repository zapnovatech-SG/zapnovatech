Add-Type -AssemblyName System.Drawing

$inputFile = "g:\Shared drives\zapnovatech\zapnovatech\diosna_logo.png"
$outputFile = "g:\Shared drives\zapnovatech\zapnovatech\diosna_logo_transparent.png"

$img = [System.Drawing.Image]::FromFile($inputFile)
$bmp = New-Object System.Drawing.Bitmap($img)
$img.Dispose()

$width = $bmp.Width
$height = $bmp.Height

# Make all near-white pixels transparent
for ($x = 0; $x -lt $width; $x++) {
    for ($y = 0; $y -lt $height; $y++) {
        $pixel = $bmp.GetPixel($x, $y)
        if ($pixel.R -gt 240 -and $pixel.G -gt 240 -and $pixel.B -gt 240) {
            $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 255, 255, 255))
        }
    }
}

# Find bounding box
$minX = $width
$minY = $height
$maxX = 0
$maxY = 0

for ($x = 0; $x -lt $width; $x++) {
    for ($y = 0; $y -lt $height; $y++) {
        $pixel = $bmp.GetPixel($x, $y)
        if ($pixel.A -ne 0) {
            if ($x -lt $minX) { $minX = $x }
            if ($y -lt $minY) { $minY = $y }
            if ($x -gt $maxX) { $maxX = $x }
            if ($y -gt $maxY) { $maxY = $y }
        }
    }
}

$cropWidth = $maxX - $minX + 1
$cropHeight = $maxY - $minY + 1

$cropRect = New-Object System.Drawing.Rectangle($minX, $minY, $cropWidth, $cropHeight)
$croppedBmp = $bmp.Clone($cropRect, $bmp.PixelFormat)

$croppedBmp.Save($outputFile, [System.Drawing.Imaging.ImageFormat]::Png)
$croppedBmp.Dispose()
$bmp.Dispose()
Write-Host "Done processing diosna_logo.png"
