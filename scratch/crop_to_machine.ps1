Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile("g:\Shared drives\Webpage Design\Zapnova_logo_final.png")
$bmp = New-Object System.Drawing.Bitmap($img)
$img.Dispose()

$width = $bmp.Width
$height = $bmp.Height

# We'll identify the two separate blocks of content (Machine and Text)
$contentRows = @()
for ($y = 0; $y -lt $height; $y++) {
    $hasContent = $false
    for ($x = 0; $x -lt $width; $x++) {
        if ($bmp.GetPixel($x, $y).A -gt 10) {
            $hasContent = $true
            break
        }
    }
    if ($hasContent) {
        $contentRows += $y
    }
}

# The machine is the first block.
# The text is the second block.
# We find where the first block ends (a gap in contentRows)
$machineEndRow = $contentRows[0]
for ($i = 0; $i -lt ($contentRows.Count - 1); $i++) {
    if ($contentRows[$i+1] - $contentRows[$i] -gt 5) {
        # Found a significant gap! The first block ends here.
        $machineEndRow = $contentRows[$i]
        break
    }
}

# Now find the side bounds of ONLY the machine block
$mTop = $contentRows[0]
$mBottom = $machineEndRow
$mLeft = $width
$mRight = 0

for ($y = $mTop; $y -le $mBottom; $y++) {
    for ($x = 0; $x -lt $width; $x++) {
        $pixel = $bmp.GetPixel($x, $y)
        if ($pixel.A -gt 10) {
            if ($x -lt $mLeft) { $mLeft = $x }
            if ($x -gt $mRight) { $mRight = $x }
        }
    }
}

$mWidth = $mRight - $mLeft + 1
$mHeight = $mBottom - $mTop + 1

if ($mWidth -gt 0 -and $mHeight -gt 0) {
    $rect = New-Object System.Drawing.Rectangle($mLeft, $mTop, $mWidth, $mHeight)
    $cropped = $bmp.Clone($rect, $bmp.PixelFormat)
    $cropped.Save("g:\Shared drives\Webpage Design\Zapnova_logo_final_machine_only.png", [System.Drawing.Imaging.ImageFormat]::Png)
    $cropped.Dispose()
    Write-Host "Machine-only logo saved. Size: $mWidth x $mHeight"
} else {
    Write-Host "Failed to identify machine block."
}

$bmp.Dispose()
