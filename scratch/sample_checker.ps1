Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile("g:\Shared drives\Webpage Design\Zapnova_image_icon_cropped.png")
$bmp = New-Object System.Drawing.Bitmap($img)
$img.Dispose()

$p1 = $bmp.GetPixel(0,0)
$p2 = $bmp.GetPixel(32,0) # Assuming 32px checkerboard
$p3 = $bmp.GetPixel(0,32)
$p4 = $bmp.GetPixel(32,32)

Write-Host "P1: #$($p1.R.ToString('X2'))$($p1.G.ToString('X2'))$($p1.B.ToString('X2'))"
Write-Host "P2: #$($p2.R.ToString('X2'))$($p2.G.ToString('X2'))$($p2.B.ToString('X2'))"
Write-Host "P3: #$($p3.R.ToString('X2'))$($p3.G.ToString('X2'))$($p3.B.ToString('X2'))"
Write-Host "P4: #$($p4.R.ToString('X2'))$($p4.G.ToString('X2'))$($p4.B.ToString('X2'))"

$bmp.Dispose()
