Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile("g:\Shared drives\Webpage Design\Zapnova_image_icon.png")
$bmp = New-Object System.Drawing.Bitmap($img)
$img.Dispose()

$width = $bmp.Width
$height = $bmp.Height

# 1. Remove background (flood fill from edges)
$queue = New-Object System.Collections.Generic.Queue[System.Drawing.Point]
$visited = New-Object 'bool[,]' $width, $height

for ($x = 0; $x -lt $width; $x++) {
    $queue.Enqueue([System.Drawing.Point]::new($x, 0))
    $queue.Enqueue([System.Drawing.Point]::new($x, $height - 1))
}
for ($y = 0; $y -lt $height; $y++) {
    $queue.Enqueue([System.Drawing.Point]::new(0, $y))
    $queue.Enqueue([System.Drawing.Point]::new($width - 1, $y))
}

while ($queue.Count -gt 0) {
    $pt = $queue.Dequeue()
    $x = $pt.X; $y = $pt.Y
    if ($x -lt 0 -or $x -ge $width -or $y -lt 0 -or $y -ge $height -or $visited[$x, $y]) { continue }
    $visited[$x, $y] = $true
    
    $pixel = $bmp.GetPixel($x, $y)
    # Threshold for background white
    if ($pixel.R -gt 240 -and $pixel.G -gt 240 -and $pixel.B -gt 240) {
        $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 255, 255, 255))
        $queue.Enqueue([System.Drawing.Point]::new($x + 1, $y))
        $queue.Enqueue([System.Drawing.Point]::new($x - 1, $y))
        $queue.Enqueue([System.Drawing.Point]::new($x, $y + 1))
        $queue.Enqueue([System.Drawing.Point]::new($x, $y - 1))
    }
}

# 2. In the text area (bottom), make ANY remaining white transparent
# First, let's find the content bounds to know where the text is
$top = $height; $bottom = 0; $left = $width; $right = 0
for ($y = 0; $y -lt $height; $y++) {
    for ($x = 0; $x -lt $width; $x++) {
        if ($bmp.GetPixel($x, $y).A -gt 10) {
            if ($x -lt $left) { $left = $x }
            if ($x -gt $right) { $right = $x }
            if ($y -lt $top) { $top = $y }
            if ($y -gt $bottom) { $bottom = $y }
        }
    }
}

# The text is likely in the bottom part of the content bounds
$contentHeight = $bottom - $top + 1
$textThresholdY = $top + ($contentHeight * 0.7)

for ($y = [int]$textThresholdY; $y -le $bottom; $y++) {
    for ($x = $left; $x -le $right; $x++) {
        $pixel = $bmp.GetPixel($x, $y)
        # If it's white (centers/outlines of text), make it transparent
        if ($pixel.R -gt 220 -and $pixel.G -gt 220 -and $pixel.B -gt 220) {
            $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 255, 255, 255))
        }
    }
}

# 3. Tighten the transparent background (Crop again to final content)
$fTop = $height; $fBottom = 0; $fLeft = $width; $fRight = 0
for ($y = 0; $y -lt $height; $y++) {
    for ($x = 0; $x -lt $width; $x++) {
        if ($bmp.GetPixel($x, $y).A -gt 10) {
            if ($x -lt $fLeft) { $fLeft = $x }
            if ($x -gt $fRight) { $fRight = $x }
            if ($y -lt $fTop) { $fTop = $y }
            if ($y -gt $fBottom) { $fBottom = $y }
        }
    }
}

$fWidth = $fRight - $fLeft + 1
$fHeight = $fBottom - $fTop + 1

if ($fWidth -gt 0 -and $fHeight -gt 0) {
    $rect = New-Object System.Drawing.Rectangle($fLeft, $fTop, $fWidth, $fHeight)
    $cropped = $bmp.Clone($rect, $bmp.PixelFormat)
    $cropped.Save("g:\Shared drives\Webpage Design\Zapnova_logo_final_reprocessed.png", [System.Drawing.Imaging.ImageFormat]::Png)
    $cropped.Dispose()
    Write-Host "Reprocessed and tightened logo saved. Size: $fWidth x $fHeight"
} else {
    Write-Host "No content found."
}

$bmp.Dispose()
