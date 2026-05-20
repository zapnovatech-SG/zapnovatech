Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile("g:\Shared drives\Webpage Design\Zapnova_logo_final.png")
$bmp = New-Object System.Drawing.Bitmap($img)
$img.Dispose()

$width = $bmp.Width
$height = $bmp.Height

# Identify rows that have any content
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

# Find the gap between machine and text
# The machine is at the top, text at the bottom.
# Let's find the largest gap of empty rows.
$maxGapStart = -1
$maxGapEnd = -1
$maxGapSize = 0

for ($i = 0; $i -lt ($contentRows.Count - 1); $i++) {
    $gapSize = $contentRows[$i+1] - $contentRows[$i] - 1
    if ($gapSize -gt $maxGapSize) {
        $maxGapSize = $gapSize
        $maxGapStart = $contentRows[$i] + 1
        $maxGapEnd = $contentRows[$i+1] - 1
    }
}

Write-Host "Max gap found: $maxGapSize rows between $maxGapStart and $maxGapEnd"

if ($maxGapSize -gt 5) {
    # We'll reduce this gap to 10 pixels
    $targetGap = 10
    $rowsToRemove = $maxGapSize - $targetGap
    
    $newHeight = $height - $rowsToRemove
    $newBmp = New-Object System.Drawing.Bitmap($width, $newHeight)
    
    # Copy top part
    for ($y = 0; $y -lt $maxGapStart; $y++) {
        for ($x = 0; $x -lt $width; $x++) {
            $newBmp.SetPixel($x, $y, $bmp.GetPixel($x, $y))
        }
    }
    
    # Copy bottom part shifted up
    for ($y = $maxGapEnd - $targetGap + 1; $y -lt $height; $y++) {
        $targetY = $y - $rowsToRemove
        if ($targetY -ge 0 -and $targetY -lt $newHeight) {
            for ($x = 0; $x -lt $width; $x++) {
                $newBmp.SetPixel($x, $targetY, $bmp.GetPixel($x, $y))
            }
        }
    }
    
    $newBmp.Save("g:\Shared drives\Webpage Design\Zapnova_logo_final_compact.png", [System.Drawing.Imaging.ImageFormat]::Png)
    $newBmp.Dispose()
    Write-Host "Compact logo saved. New height: $newHeight"
} else {
    Write-Host "No significant gap found to compact."
}

$bmp.Dispose()
