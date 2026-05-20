Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile("g:\Shared drives\Webpage Design\Zapnova_image_icon.png")
$bmp = New-Object System.Drawing.Bitmap($img)
$img.Dispose()

# Sample 10x10 grid
for ($y = 0; $y -lt $bmp.Height; $y += ($bmp.Height / 10)) {
    $line = ""
    for ($x = 0; $x -lt $bmp.Width; $x += ($bmp.Width / 10)) {
        $pixel = $bmp.GetPixel($x, $y)
        if ($pixel.A -eq 0) {
            $line += ". "
        } else {
            $line += "X "
        }
    }
    Write-Host $line
}
$bmp.Dispose()
