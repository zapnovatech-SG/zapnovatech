Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile("g:\Shared drives\Webpage Design\Zapnova_image_icon.png")
$bmp = New-Object System.Drawing.Bitmap($img)
$img.Dispose()

$width = $bmp.Width
$height = $bmp.Height

# 1. Make background transparent (white -> transparent)
# We'll use a flood fill from corners to avoid removing white inside the logo
$queue = New-Object System.Collections.Generic.Queue[System.Drawing.Point]
$visited = New-Object 'bool[,]' $width, $height

# Seed from all edges
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
    $x = $pt.X
    $y = $pt.Y

    if ($x -lt 0 -or $x -ge $width -or $y -lt 0 -or $y -ge $height) { continue }
    if ($visited[$x, $y]) { continue }
    $visited[$x, $y] = $true

    $pixel = $bmp.GetPixel($x, $y)
    # If it's pure white or very close (allowing for anti-aliasing)
    if ($pixel.R -gt 240 -and $pixel.G -gt 240 -and $pixel.B -gt 240) {
        $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 255, 255, 255))
        $queue.Enqueue([System.Drawing.Point]::new($x + 1, $y))
        $queue.Enqueue([System.Drawing.Point]::new($x - 1, $y))
        $queue.Enqueue([System.Drawing.Point]::new($x, $y + 1))
        $queue.Enqueue([System.Drawing.Point]::new($x, $y - 1))
    }
}

# 2. Find crop bounds
$top = $height
$bottom = 0
$left = $width
$right = 0

for ($y = 0; $y -lt $height; $y++) {
    for ($x = 0; $x -lt $width; $x++) {
        $pixel = $bmp.GetPixel($x, $y)
        if ($pixel.A -gt 0) {
            if ($x -lt $left) { $left = $x }
            if ($x -gt $right) { $right = $x }
            if ($y -lt $top) { $top = $y }
            if ($y -gt $bottom) { $bottom = $y }
        }
    }
}

$cWidth = $right - $left + 1
$cHeight = $bottom - $top + 1

if ($cWidth -gt 0 -and $cHeight -gt 0) {
    $rect = New-Object System.Drawing.Rectangle($left, $top, $cWidth, $cHeight)
    $cropped = $bmp.Clone($rect, $bmp.PixelFormat)
    $cropped.Save("g:\Shared drives\Webpage Design\Zapnova_image_icon_final_v2.png", [System.Drawing.Imaging.ImageFormat]::Png)
    $cropped.Dispose()
    Write-Host "Processed and cropped logo saved as Zapnova_image_icon_final_v2.png. Size: $cWidth x $cHeight"
} else {
    Write-Host "No content found after background removal."
}

$bmp.Dispose()
