<#
.DESCRIPTION
   Check EDR by known Drivers
.EXAMPLE
   Invoke-EDRCheck
   iex (iwr https://raw.githubusercontent.com/BankSecurity/Red_Team/master/Discovery/Check_EDR_Presence.ps1);Invoke-EDRCheck
#>
function Invoke-EDRCheck{
    [Alias('EDRCheck')]
    Param(<#NoParams#>)
    # Sub CustomObj
    Function Obj{
        Param([Parameter(Mandatory=1)][HashTable]$Props)
        Return New-Object PSCustomObject -Property $Props
        }
    # Driver Check
    $Result = Switch ((Get-ChildItem $env:SystemDrive\Windows\System32\drivers | where  Name -match .sys$).name){       
        ##########################################################################      
        #-------DRIVER---------####################-------------EDR-------------##
        atrsdfw.sys            {Obj @{Driver=$_;EDR= 'Altiris Symantec'         }}
        avgtpx86.sys           {Obj @{Driver=$_;EDR= 'AVG Technologies'         }}
        avgtpx64.sys           {Obj @{Driver=$_;EDR= 'AVG Technologies'         }}
        naswSP.sys             {Obj @{Driver=$_;EDR= 'Avast'                    }}
        edrsensor.sys          {Obj @{Driver=$_;EDR= 'BitDefender SRL'          }}
        CarbonBlackK.sys       {Obj @{Driver=$_;EDR= 'Carbon Black'             }}
        parity.sys             {Obj @{Driver=$_;ERD= 'Carbon Black'             }}
        csacentr.sys           {Obj @{Driver=$_;EDR= 'Cisco'                    }}
        csaenh.sys             {Obj @{Driver=$_;EDR= 'Cisco'                    }}
        csareg.sys             {Obj @{Driver=$_;EDR= 'Cisco'                    }}
        csascr.sys             {Obj @{Driver=$_;EDR= 'Cisco'                    }}
        csaav.sys              {Obj @{Driver=$_;EDR= 'Cisco'                    }}
        csaam.sys              {Obj @{Driver=$_;EDR= 'Cisco'                    }}
        rvsavd.sys             {Obj @{Driver=$_;EDR= 'CJSC Returnil Software'   }}
        cfrmd.sys              {Obj @{Driver=$_;EDR= 'Comodo Security'          }}
        cmdccav.sys            {Obj @{Driver=$_;EDR= 'Comodo Security'          }}
        cmdguard.sys           {Obj @{Driver=$_;EDR= 'Comodo Security'          }}
        CmdMnEfs.sys           {Obj @{Driver=$_;EDR= 'Comodo Security'          }}
        MyDLPMF.sys            {Obj @{Driver=$_;EDR= 'Comodo Security'          }}
        im.sys                 {Obj @{Driver=$_;EDR= 'CrowdStrike'              }}
		    CSDeviceControl.sys    {Obj @{Driver=$_;EDR= 'CrowdStrike'              }}
        csagent.sys            {Obj @{Driver=$_;EDR= 'CrowdStrike'              }}
        CybKernelTracker.sys   {Obj @{Driver=$_;EDR= 'CyberArk Software'        }}
        CRExecPrev.sys         {Obj @{Driver=$_;EDR= 'Cybereason'               }}
        CyOptics.sys           {Obj @{Driver=$_;EDR= 'Cylance Inc.'             }}
        CyProtectDrv32.sys     {Obj @{Driver=$_;EDR= 'Cylance Inc.'             }}
        CyProtectDrv64.sys.sys {Obj @{Driver=$_;EDR= 'Cylance Inc.'             }}
        groundling32.sys       {Obj @{Driver=$_;EDR= 'Dell Secureworks'         }}
        groundling64.sys       {Obj @{Driver=$_;EDR= 'Dell Secureworks'         }}
        esensor.sys            {Obj @{Driver=$_;EDR= 'Endgame'                  }}
        edevmon.sys            {Obj @{Driver=$_;EDR= 'ESET'                     }}
        ehdrv.sys              {Obj @{Driver=$_;EDR= 'ESET'                     }}
        FeKern.sys             {Obj @{Driver=$_;EDR= 'FireEye'                  }}
        WFP_MRT.sys            {Obj @{Driver=$_;EDR= 'FireEye'                  }}
        xfsgk.sys              {Obj @{Driver=$_;EDR= 'F-Secure'                 }}
        fsatp.sys              {Obj @{Driver=$_;EDR= 'F-Secure'                 }}
        fshs.sys               {Obj @{Driver=$_;EDR= 'F-Secure'                 }}
        HexisFSMonitor.sys     {Obj @{Driver=$_;EDR= 'Hexis Cyber Solutions'    }}
        klifks.sys             {Obj @{Driver=$_;EDR= 'Kaspersky'                }}
        klifaa.sys             {Obj @{Driver=$_;EDR= 'Kaspersky'                }}
        Klifsm.sys             {Obj @{Driver=$_;EDR= 'Kaspersky'                }}
        mbamwatchdog.sys       {Obj @{Driver=$_;EDR= 'Malwarebytes'             }}
        mfeaskm.sys            {Obj @{Driver=$_;EDR= 'McAfee'                   }}
        mfencfilter.sys        {Obj @{Driver=$_;EDR= 'McAfee'                   }}
        PSINPROC.SYS           {Obj @{Driver=$_;EDR= 'Panda Security'           }}
        PSINFILE.SYS           {Obj @{Driver=$_;EDR= 'Panda Security'           }}
        amfsm.sys              {Obj @{Driver=$_;EDR= 'Panda Security'           }}
        amm8660.sys            {Obj @{Driver=$_;EDR= 'Panda Security'           }}
        amm6460.sys            {Obj @{Driver=$_;EDR= 'Panda Security'           }}
        eaw.sys                {Obj @{Driver=$_;EDR= 'Raytheon Cyber Solutions' }}
        SAFE-Agent.sys         {Obj @{Driver=$_;EDR= 'SAFE-Cyberdefense'        }}
        SentinelMonitor.sys    {Obj @{Driver=$_;EDR= 'SentinelOne'              }}
        SAVOnAccess.sys        {Obj @{Driver=$_;EDR= 'Sophos'                   }}
        savonaccess.sys        {Obj @{Driver=$_;EDR= 'Sophos'                   }}
        sld.sys                {Obj @{Driver=$_;EDR= 'Sophos'                   }}
        pgpwdefs.sys           {Obj @{Driver=$_;EDR= 'Symantec'                 }}
        GEProtection.sys       {Obj @{Driver=$_;EDR= 'Symantec'                 }}
        diflt.sys              {Obj @{Driver=$_;EDR= 'Symantec'                 }}
        sysMon.sys             {Obj @{Driver=$_;EDR= 'Symantec'                 }}
        ssrfsf.sys             {Obj @{Driver=$_;EDR= 'Symantec'                 }}
        emxdrv2.sys            {Obj @{Driver=$_;EDR= 'Symantec'                 }}
        reghook.sys            {Obj @{Driver=$_;EDR= 'Symantec'                 }}
        spbbcdrv.sys           {Obj @{Driver=$_;EDR= 'Symantec'                 }}
        bhdrvx86.sys           {Obj @{Driver=$_;EDR= 'Symantec'                 }}
        bhdrvx64.sys           {Obj @{Driver=$_;EDR= 'Symantec'                 }}
        SISIPSFileFilter       {Obj @{Driver=$_;EDR= 'Symantec'                 }}
        symevent.sys           {Obj @{Driver=$_;EDR= 'Symantec'                 }}
        vxfsrep.sys            {Obj @{Driver=$_;EDR= 'Symantec'                 }}
        VirtFile.sys           {Obj @{Driver=$_;EDR= 'Symantec'                 }}
        SymAFR.sys             {Obj @{Driver=$_;EDR= 'Symantec'                 }}
        symefasi.sys           {Obj @{Driver=$_;EDR= 'Symantec'                 }}
        symefa.sys             {Obj @{Driver=$_;EDR= 'Symantec'                 }}
        symefa64.sys           {Obj @{Driver=$_;EDR= 'Symantec'                 }}
        SymHsm.sys             {Obj @{Driver=$_;EDR= 'Symantec'                 }}
        evmf.sys               {Obj @{Driver=$_;EDR= 'Symantec'                 }}
        GEFCMP.sys             {Obj @{Driver=$_;EDR= 'Symantec'                 }}
        VFSEnc.sys             {Obj @{Driver=$_;EDR= 'Symantec'                 }}
        pgpfs.sys              {Obj @{Driver=$_;EDR= 'Symantec'                 }}
        fencry.sys             {Obj @{Driver=$_;EDR= 'Symantec'                 }}
        symrg.sys              {Obj @{Driver=$_;EDR= 'Symantec'                 }}
        ndgdmk.sys             {Obj @{Driver=$_;EDR= 'Verdasys Inc'             }}
        ssfmonm.sys            {Obj @{Driver=$_;EDR= 'Webroot Software'         }}
        }#########################################################################
        #
    # Res
    if(-Not$Result){Return 'No known EDR Driver found...'}
    else{Return $Result}
    }
#End
