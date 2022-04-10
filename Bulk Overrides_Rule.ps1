Import-module operationsmanager
 
 $mp = Get-SCOMManagementPack -DisplayName “Suncor HP OneView Customizations MP”
 
 $list = import-csv C:\Users\amgravi\Desktop\SCOM_Scripts\Bulk_Overrider\Overrides_Rule.csv
 
 foreach ($item in $list)
 {
 
     write-host “getting Class $item.class….” -ForegroundColor Cyan
     write-host
 
     $class =  Get-SCOMClass -DisplayName $item.class
 
     write-host “getting rule $item.rule ….” -ForegroundColor Magenta
     write-host
 
     $rule = get-scomrule -displayname $item.rule
 
     write-host “Disabling rule $rule.displayname” -ForegroundColor green
     write-host
 
     Disable-SCOMRule -Class $class -ManagementPack $MP -rule $rule 
 
 }