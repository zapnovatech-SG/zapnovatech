Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile("g:\Shared drives\Webpage Design\Zapnova_logo_final.png")
$bmp = New-Object System.Drawing.Bitmap($img)
$img.Dispose()

$width = $bmp.Width
$height = $bmp.Height

# Sample the middle of the machine body
for ($y = [int]($height * 0.3); $y -lt [int]($height * 0.7); $y += 10) {
    $line = ""
    for ($x = [int]($width * 0.2); $x -lt [int]($width * 0.8); $x += 10) {
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
