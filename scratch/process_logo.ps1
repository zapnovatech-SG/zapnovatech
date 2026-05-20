Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile("C:\Users\Ho\.gemini\antigravity\brain\9410bfe8-efee-4409-9b3d-2bd2f9ea73a7\zapnova_logo_clean_v1_1778925521878.png")
$bmp = New-Object System.Drawing.Bitmap($img)
$img.Dispose()

# Simple background removal (black to transparent)
for ($y = 0; $y -lt $bmp.Height; $y++) {
    for ($x = 0; $x -lt $bmp.Width; $x++) {
        $pixel = $bmp.GetPixel($x, $y)
        # If it's very dark, make it transparent
        if ($pixel.R -lt 10 -and $pixel.G -lt 10 -and $pixel.B -lt 10) {
            $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
        }
    }
}

$bmp.Save("g:\Shared drives\Webpage Design\zapnova_logo_clean.png", [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
Write-Host "Logo saved with transparency."
