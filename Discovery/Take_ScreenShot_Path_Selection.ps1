Function New-ScreenShot {
#USAGE:
# iex (iwr https://raw.githubusercontent.com/BankSecurity/Red_Team/master/Discovery/Take_ScreenShot_Path_Selection.ps1);New-ScreenShot -Full 
# --> Specify path manually 
# OR
# powershell.exe "iex (iwr https://raw.githubusercontent.com/BankSecurity/Red_Team/master/Discovery/Take_ScreenShot_Path_Selection.ps1);New-ScreenShot -Full -Path C:\Windows\Temp\ScreenShot.jpg"

[cmdletbinding(SupportsShouldProcess=$True)]

Param(
[Parameter(Position=0,Mandatory=$True,HelpMessage="Enter the path and filename")]
[ValidateNotNullorEmpty()]
[ValidateScript({
#verify the folder exists
$folder = Split-Path -Path $_

#Validation differs depending on whether v2 or v3
if ($PSVersionTable.psversion -eq "2.0") {
   Test-Path -Path $folder
}
else {
    if (! (Test-Path -Path $folder)) {
        #write a custom error message for v3
        Throw "Can't verify that $folder exists."
    }
    else {
        $True
    }
 }
})]
[string]$Path,
[switch]$Full,
[switch]$Passthru
)

If ($host.Runspace.ApartmentState -ne "STA") {
    Write-Warning "You must run this in a PowerShell session with an apartment state of STA"
    Return
}

#load the necessary assemblies
Add-Type -AssemblyName "System.Drawing","System.Windows.Forms"

if ($Full) {
    #capture the full desktop
    [Windows.Forms.Sendkeys]::SendWait("{PrtSc}")  
}
else {
    #capture the current window
    [Windows.Forms.Sendkeys]::SendWait("%{PrtSc}")  
}

#pause enough to give time for the capture to take place
start-sleep -Milliseconds 250

#create bitmap object from the screenshot
$bitmap = [Windows.Forms.Clipboard]::GetImage()  

#split off the file extension and use it as the type
[string]$filename=Split-Path -Path $Path -Leaf
[string]$FileExtension= $Filename.Split(".")[1].Trim()

#get the right format value based on the file extension
Switch ($FileExtension) {
    "png"  {$FileType=[System.Drawing.Imaging.ImageFormat]::Png}
    "bmp"  {$FileType=[System.Drawing.Imaging.ImageFormat]::Bmp}
    "gif"  {$FileType=[System.Drawing.Imaging.ImageFormat]::Gif}
    "emf"  {$FileType=[System.Drawing.Imaging.ImageFormat]::Emf}
    "jpg"  {$FileType=[System.Drawing.Imaging.ImageFormat]::Jpeg}
    "tiff" {$FileType=[System.Drawing.Imaging.ImageFormat]::Tiff}
    "wmf"  {$FileType=[System.Drawing.Imaging.ImageFormat]::Wmf}
    "exif" {$FileType=[System.Drawing.Imaging.ImageFormat]::Exif}

    Default {
      Write-Warning "Failed to find a valid graphic file type"
      $FileType=$False
      }
} #switch

#Save the file if a valid file type was determined
if ($FileType) {

 If ($PSCmdlet.ShouldProcess($path)) {
    Try {
        $bitmap.Save($Path.Trim(),$FileType)
        if ($Passthru) {
            #write the file object to the pipeline
            Get-Item -Path $Path.Trim()
        } #if $passthru
    } #try
    Catch {
        Write-Warning "Failed to save screen capture. $($_.Exception.Message)"
    } #catch
 } #if shouldprocess
} #if $filetype

#clear the clipboard
[Windows.Forms.Clipboard]::Clear()

} #end function
