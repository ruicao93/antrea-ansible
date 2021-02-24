Param(
    [parameter(Mandatory = $false)] [string] $OVSInstallDir = "C:\openvswitch",
    [parameter(Mandatory = $false)] [switch] $RemoveDir = $false,
    [parameter(Mandatory = $false)] [switch] $DeleteBridges = $false
)

$ErrorActionPreference = "Continue"
$OVSBinDir = "$OVSInstallDir\usr\bin"
$OVSDriverDir = "$OVSInstallDir\driver\"
$OVSDriverProvider = "The Linux Foundation (R)"

function Delete-Drivers() {
    $driversInfo = pnputil.exe -e
    $driversInfo = $driversInfo.Split([Environment]::NewLine)
    for ($index = 0; $index -lt $driversInfo.Length; $index++) {
        if ($driversInfo[$index].Contains($OVSDriverProvider)) {
            $driverNameLine = $driversInfo[$index - 1] -split '\s+'
            $driverName = $driverNameLine[$driverNameLine.Length - 1]
            Write-Host "deleting driver $driverName"
            pnputil.exe /delete-driver $driverName
        }
    }
}

if ($DeleteBridges) {
    $brList = ovs-vsctl.exe list-br
    foreach ($br in $brList) {
        Write-Host "Delete OVS Bridge: %s $br"
        $cmd = "$OVSBinDir\ovs-vsctl.exe --no-wait del-br $br"
        Invoke-Expression $cmd
    }
}

# Stop and delete ovs-vswitchd service
stop-service ovs-vswitchd
sc.exe delete ovs-vswitchd
if (Get-Service ovs-vswitchd -ErrorAction SilentlyContinue) {
    Write-Host "Failed to delete ovs-vswitchd service, exit."
    exit 1
}
# Stop and delete ovsdb-service service
stop-service ovsdb-server
sc.exe delete ovsdb-server
if (Get-Service ovsdb-server -ErrorAction SilentlyContinue) {
    Write-Host "Failed to delete ovs-vswitchd service, exit."
    exit 1
}
# Uninstall OVS kernel driver
cmd /c "cd $OVSDriverDir && uninstall.cmd"
if (!$?) {
    Write-Host "Failed to uninstall OVS kernel driver."
    exit 1
}

# Remove OVS installation dir
if ($RemoveDir) {
    Remove-Item -Recurse $OVSInstallDir
    if (!$?) {
        Write-Host "Failed to remove OVS dir: $OVSInstallDir."
        exit 1
    }
}

Delete-Drivers

Write-Host "Uninstall OVS success."