Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile("g:\Shared drives\Webpage Design\Zapnova_text.png")
$bmp = New-Object System.Drawing.Bitmap($img)
$img.Dispose()

$width = $bmp.Width
$height = $bmp.Height

# 1. Remove background (flood fill from edges)
$queue = New-Object System.Collections.Generic.Queue[System.Drawing.Point]
$visited = New-Object 'bool[,]' $width, $height
for ($x = 0; $x -lt $width; $x++) { $queue.Enqueue([System.Drawing.Point]::new($x, 0)); $queue.Enqueue([System.Drawing.Point]::new($x, $height - 1)) }
for ($y = 0; $y -lt $height; $y++) { $queue.Enqueue([System.Drawing.Point]::new(0, $y)); $queue.Enqueue([System.Drawing.Point]::new($width - 1, $y)) }

while ($queue.Count -gt 0) {
    $pt = $queue.Dequeue()
    $x = $pt.X; $y = $pt.Y
    if ($x -lt 0 -or $x -ge $width -or $y -lt 0 -or $y -ge $height -or $visited[$x, $y]) { continue }
    $visited[$x, $y] = $true
    $pixel = $bmp.GetPixel($x, $y)
    if ($pixel.R -gt 240 -and $pixel.G -gt 240 -and $pixel.B -gt 240) {
        $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 255, 255, 255))
        $queue.Enqueue([System.Drawing.Point]::new($x + 1, $y)); $queue.Enqueue([System.Drawing.Point]::new($x - 1, $y))
        $queue.Enqueue([System.Drawing.Point]::new($x, $y + 1)); $queue.Enqueue([System.Drawing.Point]::new($x, $y - 1))
    }
}

# 2. Make any REMAINING white transparent (for hollow text)
for ($y = 0; $y -lt $height; $y++) {
    for ($x = 0; $x -lt $width; $x++) {
        $pixel = $bmp.GetPixel($x, $y)
        if ($pixel.A -gt 10 -and $pixel.R -gt 220 -and $pixel.G -gt 220 -and $pixel.B -gt 220) {
            $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 255, 255, 255))
        }
    }
}

# 3. Tight crop around the text
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

$cWidth = $right - $left + 1; $cHeight = $bottom - $top + 1
if ($cWidth -gt 0 -and $cHeight -gt 0) {
    $rect = New-Object System.Drawing.Rectangle($left, $top, $cWidth, $cHeight)
    $cropped = $bmp.Clone($rect, $bmp.PixelFormat)
    $cropped.Save("g:\Shared drives\Webpage Design\Zapnova_text_final.png", [System.Drawing.Imaging.ImageFormat]::Png)
    $cropped.Dispose()
    Write-Host "Processed and tightly cropped text asset saved. Size: $cWidth x $cHeight"
}

$bmp.Dispose()
