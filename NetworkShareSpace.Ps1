$share="\Myshare.com\share1"
$nwobj=new-object -comobject WScript.Network
$status=$nwobj.mapnetworkdrive("O:",$share)
$drive=get-psdrive O
$free=($drive.free)
$used=($drive.used)
$total=($free+$used)
$freeinPercentage=($free/$total*100)
$freewithoutdecimal=([math]::Round($freeinPercentage))
Write-Output "Share $share has free space of $freewithoutdecimal %"
$status=$nwobj.removenetworkdrive("O:")