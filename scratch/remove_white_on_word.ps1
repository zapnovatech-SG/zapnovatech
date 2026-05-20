Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile("g:\Shared drives\Webpage Design\Zapnova_logo_final.png")
$bmp = New-Object System.Drawing.Bitmap($img)
$img.Dispose()

$width = $bmp.Width
$height = $bmp.Height
$newBmp = New-Object System.Drawing.Bitmap($width, $height)

# Threshold for "Red"
function IsRed($c) {
    return ($c.R -gt 200 -and $c.G -lt 100 -and $c.B -lt 100)
}

# Threshold for "White"
function IsWhite($c) {
    return ($c.R -gt 230 -and $c.G -gt 230 -and $c.B -gt 230)
}

# Create a map of red pixels
$redMap = New-Object 'bool[,]' $width, $height
for ($y = 0; $y -lt $height; $y++) {
    for ($x = 0; $x -lt $width; $x++) {
        $pixel = $bmp.GetPixel($x, $y)
        if (IsRed $pixel) {
            $redMap[$x, $y] = $true
        }
    }
}

# Process the image
for ($y = 0; $y -lt $height; $y++) {
    for ($x = 0; $x -lt $width; $x++) {
        $pixel = $bmp.GetPixel($x, $y)
        
        if (IsWhite $pixel) {
            # Check if there's a red pixel nearby (radius 5)
            $foundRed = $false
            for ($dy = -5; $dy -le 5; $dy++) {
                for ($dx = -5; $dx -le 5; $dx++) {
                    $nx = $x + $dx
                    $ny = $y + $dy
                    if ($nx -ge 0 -and $nx -lt $width -and $ny -ge 0 -and $ny -lt $height) {
                        if ($redMap[$nx, $ny]) {
                            $foundRed = $true
                            break
                        }
                    }
                }
                if ($foundRed) { break }
            }
            
            if ($foundRed) {
                # This is white "on the word" (outline/shadow), make it transparent
                $newBmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 255, 255, 255))
            } else {
                # This is white but not near red (maybe machine outline), keep it
                $newBmp.SetPixel($x, $y, $pixel)
            }
        } else {
            # Not white, keep it (includes red and other colors)
            $newBmp.SetPixel($x, $y, $pixel)
        }
    }
}

$newBmp.Save("g:\Shared drives\Webpage Design\Zapnova_logo_final_no_white.png", [System.Drawing.Imaging.ImageFormat]::Png)
$newBmp.Dispose()
$bmp.Dispose()
Write-Host "Done! Saved as Zapnova_logo_final_no_white.png"
