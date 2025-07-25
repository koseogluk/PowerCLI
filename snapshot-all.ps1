# vCenter'a bağlan
connect-viserver -server "vCenter Hostname" -credential (get-credential)

# Snapshot alma işlemi
$hostnameFile = "C:\snap-list.txt"

$snapshotName = "Linux Security Patch 2024"
$snapshotDescription = "Emrah Uludag"
$hostnames = Get-Content -Path $hostnameFile

foreach ($hostname in $hostnames) {
    $vm = Get-VM -Name $hostname -ErrorAction SilentlyContinue
    if ($vm -ne $null) {
        Write-Output "Taking snapshot for VM: $hostname"
        New-Snapshot -VM $vm -Name $snapshotName -Description $snapshotDescription -Memory:$false -Quiesce:$true
        Write-Output "Snapshot taken for VM: $hostname"
    } else {
        Write-Output "VM not found: $hostname"
    }
}

# Snapshot silme işlemi
$hostnameFile = "C:\snap-listtxt"
$hostnames = Get-Content -Path $hostnameFile


foreach ($hostname in $hostnames) {
    
    $vm = Get-VM -Name $hostname -ErrorAction SilentlyContinue
    if ($vm -ne $null) {
        Write-Output "Deleting snapshots for VM: $hostname"
        $snapshots = Get-Snapshot -VM $vm
        foreach ($snapshot in $snapshots) {
            Remove-Snapshot -Snapshot $snapshot -Confirm:$false
            Write-Output "Snapshot deleted for VM: $hostname - Snapshot: $($snapshot.Name)"
        }
    } else {
        Write-Output "VM not found: $hostname"
    }
}

# vCenter bağlantısını kapat
Disconnect-VIServer -Confirm:$false
