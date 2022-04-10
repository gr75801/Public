Import-module operationsmanager

$mp = Get-SCOMManagementPack -DisplayName “exchange server 2010 – Overrides”

$list = import-csv C:\software\disable-exchange-rules.csv

foreach ($item in $list)
{ 

   
write-host “getting Class $item.class….” -ForegroundColor Cyan   
write-host

   
$class =  Get-SCOMClass -DisplayName $item.class

write-host “getting monitor $item.monitor ….” -ForegroundColor Magenta
write-host

$monitor = get-scommonitor -displayname $item.monitor

 
write-host “Disabling monitor $monitor.displayname” -ForegroundColor green 
write-host

    
Disable-Monitor -Class $class -ManagementPack $MP -monitor $monitor