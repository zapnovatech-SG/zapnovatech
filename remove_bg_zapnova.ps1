Add-Type -AssemblyName System.Drawing

$img = [System.Drawing.Image]::FromFile("g:\Shared drives\Webpage Design\Zapnova_image_icon_transparent1.png")
$bmp = New-Object System.Drawing.Bitmap($img)
$img.Dispose()

$width = $bmp.Width
$height = $bmp.Height

# Create a visited array
$visited = New-Object 'bool[,]' $width, $height

# Queue-based flood fill from all 4 edges (exterior background only)
$queue = New-Object System.Collections.Generic.Queue[System.Drawing.Point]

# Seed from all border pixels
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

    $pixel = $bmp.GetPixel($x, $y)
    # Only flood-fill near-white pixels (background)
    # Using a slightly higher tolerance for Zapnova background
    if ($pixel.R -gt 230 -and $pixel.G -gt 230 -and $pixel.B -gt 230) {
        $visited[$x, $y] = $true
        $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 255, 255, 255))
        $queue.Enqueue([System.Drawing.Point]::new($x + 1, $y))
        $queue.Enqueue([System.Drawing.Point]::new($x - 1, $y))
        $queue.Enqueue([System.Drawing.Point]::new($x, $y + 1))
        $queue.Enqueue([System.Drawing.Point]::new($x, $y - 1))
    } else {
        $visited[$x, $y] = $true
    }
}

$bmp.Save("g:\Shared drives\Webpage Design\Zapnova_image_icon_final.png", [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
Write-Host "Done! Saved as Zapnova_image_icon_final.png"
