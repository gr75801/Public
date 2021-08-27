#Display Primary and Failover Management Servers for all Gateway Servers 
Import-module -name Operationsmanager
$GWs = Get-SCOMManagementServer | where {$_.IsGateway -eq $true} 
$GWs | sort | foreach { 
Write-Host ""; 
"Gateway MS :: " + $_.Name; 
"–Primary MS :: " + ($_.GetPrimaryManagementServer()).ComputerName; 
$failoverServers = $_.getFailoverManagementServers(); 
foreach ($managementServer in $failoverServers) { 
"–Failover MS :: " + ($managementServer.ComputerName); 
} 
} 
Write-Host ""; 