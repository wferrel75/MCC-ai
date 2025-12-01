Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class NetAPI32{
    public const int ErrorSuccess = 0;

    [DllImport("Netapi32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
    public static extern int NetGetJoinInformation(string server, out IntPtr domain, out NetJoinStatus status);

    [DllImport("Netapi32.dll")]
    public static extern int NetApiBufferFree(IntPtr Buffer);

    public enum NetJoinStatus
    {
        NetSetupUnknownStatus = 0,
        NetSetupUnjoined,
        NetSetupWorkgroupName,
        NetSetupDomainName
    }

    public enum DSREG_JOIN_TYPE {
        DSREG_UNKNOWN_JOIN,
        DSREG_DEVICE_JOIN,
        DSREG_WORKPLACE_JOIN
    }

	[StructLayout(LayoutKind.Sequential, CharSet=CharSet.Unicode)]
    public struct DSREG_JOIN_INFO
    {
        public DSREG_JOIN_TYPE joinType;
        public IntPtr pJoinCertificate;
        [MarshalAs(UnmanagedType.LPWStr)] public string DeviceId;
        [MarshalAs(UnmanagedType.LPWStr)] public string IdpDomain;
        [MarshalAs(UnmanagedType.LPWStr)] public string TenantId;
        [MarshalAs(UnmanagedType.LPWStr)] public string JoinUserEmail;
        [MarshalAs(UnmanagedType.LPWStr)] public string TenantDisplayName;
        [MarshalAs(UnmanagedType.LPWStr)] public string MdmEnrollmentUrl;
        [MarshalAs(UnmanagedType.LPWStr)] public string MdmTermsOfUseUrl;
        [MarshalAs(UnmanagedType.LPWStr)] public string MdmComplianceUrl;
        [MarshalAs(UnmanagedType.LPWStr)] public string UserSettingSyncUrl;
        public IntPtr pUserInfo;
    }

    [DllImport("netapi32.dll", CharSet=CharSet.Unicode, SetLastError=true)]
    public static extern void NetFreeAadJoinInformation(
        IntPtr pJoinInfo);

    [DllImport("netapi32.dll", CharSet=CharSet.Unicode, SetLastError=true)]
    public static extern int NetGetAadJoinInformation(
        string pcszTenantId,
        out IntPtr ppJoinInfo);
}
"@

function PrintExit()
{
    $ret | ConvertTo-Json -Compress |  Out-File -Encoding Unicode -FilePath $env:SystemRoot'\TEMP\nessus_azure_ad_join_CE6GL5PX.txt'
    exit
}

$ret = New-Object PSObject -Property @{
    joinType = "";
    aadTenantId = "";
    aadTenantDisplayName = "";
    aadIdpDomain = "";
    aadDeviceId = "";
    joiningUserUpn = "";
    adDomain = ""
}

$ptrJoinInfo = [IntPtr]::Zero
$retValue = [NetAPI32]::NetGetAadJoinInformation($null, [ref]$ptrJoinInfo);
if ($retValue -ne [NetAPI32]::ErrorSuccess `
    -Or $ptrJoinInfo -eq [IntPtr]::Zero) 
{
    PrintExit
}

$joinInfo = [System.Runtime.InteropServices.Marshal]::PtrToStructure($ptrJoinInfo, [System.Type][NetAPI32+DSREG_JOIN_INFO])
[NetAPI32]::NetFreeAadJoinInformation($ptrJoinInfo);
switch ($joinInfo.joinType)
{
    default                                     { $ret.joinType = ""; PrintExit }
    ([NetAPI32+DSREG_JOIN_TYPE]::DSREG_UNKNOWN_JOIN)   { $ret.joinType = ""; PrintExit }
    ([NetAPI32+DSREG_JOIN_TYPE]::DSREG_WORKPLACE_JOIN) { $ret.joinType = "REGISTERED"; PrintExit }
    ([NetAPI32+DSREG_JOIN_TYPE]::DSREG_DEVICE_JOIN)    { $ret.joinType = "JOINED" }
}

$ret.aadDeviceId = $joinInfo.DeviceId
$ret.aadIdpDomain = $joinInfo.IdpDomain
$ret.aadTenantDisplayName = $joinInfo.TenantDisplayName
$ret.aadTenantId = $joinInfo.TenantId
$ret.joiningUserUpn = $joinInfo.JoinUserEmail

$ptrDomain = [IntPtr]::Zero
$status = [NetAPI32+NetJoinStatus]::NetSetupUnknownStatus
$retValue = [NetAPI32]::NetGetJoinInformation($null, [ref]$ptrDomain, [ref]$status);
if ($retValue -ne [NetAPI32]::ErrorSuccess `
    -Or $ptrDomain -eq [IntPtr]::Zero `
    -Or $status -ne [NetAPI32+NetJoinStatus]::NetSetupDomainName)
{
    PrintExit
}

$ret.joinType = "HYBRID"

$domainName = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($ptrDomain)
[NetAPI32]::NetApiBufferFree($ptrDomain) | Out-Null
$ret.adDomain = $domainName

PrintExit
