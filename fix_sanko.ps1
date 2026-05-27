Add-Type -AssemblyName System.Drawing

$inputFile = "g:\Shared drives\zapnovatech\zapnovatech\sanko_logo_cropped.png"
$outputFile = "g:\Shared drives\zapnovatech\zapnovatech\sanko_logo_perfect.png"

$img = [System.Drawing.Image]::FromFile($inputFile)
$bmp = New-Object System.Drawing.Bitmap($img)
$img.Dispose()

$width = $bmp.Width
$height = $bmp.Height

# Find the purest green color in the image
$minR = 255
$targetG = 0
$targetB = 0

for ($x = 0; $x -lt $width; $x++) {
    for ($y = 0; $y -lt $height; $y++) {
        $p = $bmp.GetPixel($x, $y)
        if ($p.A -gt 0 -and $p.G -gt 100) {
            if ($p.R -lt $minR) {
                $minR = $p.R
                $targetG = $p.G
                $targetB = $p.B
            }
        }
    }
}

Write-Host "Detected base green: R=$minR, G=$targetG, B=$targetB"

for ($x = 0; $x -lt $width; $x++) {
    for ($y = 0; $y -lt $height; $y++) {
        $pixel = $bmp.GetPixel($x, $y)
        if ($pixel.A -eq 0) { continue }
        
        # Estimate alpha assuming the pixel is a blend of the base green and white
        # R_pixel = R_base * A + 255 * (1 - A)
        # R_pixel = R_base * A + 255 - 255 * A
        # R_pixel - 255 = A * (R_base - 255)
        # A = (255 - R_pixel) / (255 - R_base)
        
        $a = 1.0
        if ($minR -ne 255) {
            $a = (255.0 - $pixel.R) / (255.0 - $minR)
        }
        
        if ($a -lt 0) { $a = 0 }
        if ($a -gt 1) { $a = 1 }
        
        # Multiply by original alpha just in case it was already semi-transparent
        $finalA = [int]($a * $pixel.A)
        
        # Set pixel to the base green with the new alpha
        if ($finalA -le 5) {
            $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
        } else {
            $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($finalA, $minR, $targetG, $targetB))
        }
    }
}

$bmp.Save($outputFile, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
Write-Host "Done saving sanko_logo_perfect.png"
