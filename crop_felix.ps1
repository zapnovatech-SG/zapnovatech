Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile('g:\Shared drives\Webpage Design\Copy of Zapnova ET Name Card-Ho.jpeg')
# The Felix logo is in the bottom left, above the blue bar.
# Card height is ~563. Blue bar is at the bottom.
$rect = New-Object System.Drawing.Rectangle(66, 440, 200, 110)
$bmp = New-Object System.Drawing.Bitmap($rect.Width, $rect.Height)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.DrawImage($img, (New-Object System.Drawing.Rectangle(0, 0, $bmp.Width, $bmp.Height)), $rect, [System.Drawing.GraphicsUnit]::Pixel)
$bmp.Save('g:\Shared drives\Webpage Design\felix_logo.png', [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose()
$bmp.Dispose()
$img.Dispose()
"Felix logo saved to felix_logo.png"
