Add-Type -AssemblyName System.Drawing

$img = [System.Drawing.Image]::FromFile("g:\Shared drives\Webpage Design\aicoh_mark.png")
$bmp = New-Object System.Drawing.Bitmap($img)
$img.Dispose()

$width = $bmp.Width
$height = $bmp.Height

# 1. Find the bounding box of the RED pixels
$minX = $width; $maxX = 0; $minY = $height; $maxY = 0
$foundRed = $false

for ($y = 0; $y -lt $height; $y++) {
    for ($x = 0; $x -lt $width; $x++) {
        $pixel = $bmp.GetPixel($x, $y)
        # Check for red (roughly CC0000)
        if ($pixel.R -gt 150 -and $pixel.G -lt 100 -and $pixel.B -lt 100) {
            if ($x -lt $minX) { $minX = $x }
            if ($x -gt $maxX) { $maxX = $x }
            if ($y -lt $minY) { $minY = $y }
            if ($y -gt $maxY) { $maxY = $y }
            $foundRed = $true
        }
    }
}

if ($foundRed) {
    # 2. Iterate again and make everything outside the red box transparent
    # And keep white pixels that are INSIDE the red box
    for ($y = 0; $y -lt $height; $y++) {
        for ($x = 0; $x -lt $width; $x++) {
            $pixel = $bmp.GetPixel($x, $y)
            $isInside = ($x -ge $minX -and $x -le $maxX -and $y -ge $minY -and $y -le $maxY)
            
            if (-not $isInside) {
                # Outside the red square area -> Transparent
                $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 255, 255, 255))
            } else {
                # Inside the red square area
                # If it's near-white, keep it as white (to restore the A-shape)
                if ($pixel.R -gt 200 -and $pixel.G -gt 200 -and $pixel.B -gt 200) {
                    $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(255, 255, 255, 255))
                }
                # If it's something else (like grey antialiasing), keep it or make it transparent if it's outside the actual red shape
                # For now, we keep everything inside the box as-is except for white which we force to opaque white
            }
        }
    }
}

$bmp.Save("g:\Shared drives\Webpage Design\aicoh_mark_transparent.png", [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
Write-Host "Success! Internal white restored using red bounding box method."
