Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile("g:\Shared drives\Webpage Design\Zapnova_image_icon.png")
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

# 2. Identify the machine block (top content)
$contentRows = @()
for ($y = 0; $y -lt $height; $y++) {
    $hasContent = $false
    for ($x = 0; $x -lt $width; $x++) { if ($bmp.GetPixel($x, $y).A -gt 10) { $hasContent = $true; break } }
    if ($hasContent) { $contentRows += $y }
}

$machineEndRow = $contentRows[0]
for ($i = 0; $i -lt ($contentRows.Count - 1); $i++) {
    if ($contentRows[$i+1] - $contentRows[$i] -gt 5) { $machineEndRow = $contentRows[$i]; break }
}

# 3. Crop tightly around the machine only
$mTop = $contentRows[0]; $mBottom = $machineEndRow; $mLeft = $width; $mRight = 0
for ($y = $mTop; $y -le $mBottom; $y++) {
    for ($x = 0; $x -lt $width; $x++) {
        if ($bmp.GetPixel($x, $y).A -gt 10) {
            if ($x -lt $mLeft) { $mLeft = $x }
            if ($x -gt $mRight) { $mRight = $x }
        }
    }
}

$mWidth = $mRight - $mLeft + 1; $mHeight = $mBottom - $mTop + 1
if ($mWidth -gt 0 -and $mHeight -gt 0) {
    $rect = New-Object System.Drawing.Rectangle($mLeft, $mTop, $mWidth, $mHeight)
    $cropped = $bmp.Clone($rect, $bmp.PixelFormat)
    $cropped.Save("g:\Shared drives\Webpage Design\Zapnova_logo_machine_only_final.png", [System.Drawing.Imaging.ImageFormat]::Png)
    $cropped.Dispose()
    Write-Host "Machine-only logo saved. Size: $mWidth x $mHeight"
}

$bmp.Dispose()
