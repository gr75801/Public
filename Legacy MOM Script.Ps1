#Param([string] $mbxdb, [int] $wait)
$mbxdb = $args[1]
$wait = $args[3]

#creates the SCOM scripting API
$api=New-Object -comObject MOM.ScriptAPI

$mbxdb2 = "$mbxdb"
$DBcount = 0
#write-host "Server: " $mbxdb2
#$api.logscriptevent("MailboxMon11.PS1",4365,4,"Starting the DB check on: $mbxdb2" )

add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010

$results = get-mailboxdatabase -server $mbxdb2 -status | ? {$_.Server -like $mbxdb2} | select name, server, mounted

if(!$results)
{
#nothing to do
#$api.logscriptevent("MailboxMon1.PS1",4365,4,"This server does not host any Active DBs." )
}
Else
{
$tmpstr = new-object System.Text.StringBuilder 

$FailedDBs = New-Object System.Collections.ArrayList
[void]$tmpstr.append("First Pass:")
[void]$tmpstr.append("`r`n")

foreach($DB in $results)
{

#write-host "DB Status:"
#write-host $DB
#write-host "----------"
[void]$tmpstr.append("DB: ")
[void]$tmpstr.append($DB.Name)
[void]$tmpstr.append(" - ")
[void]$tmpstr.append("Mounted: ")
[void]$tmpstr.append($DB.Mounted)
[void]$tmpstr.append("`r`n")
#if($DB.Name -like '*test*')
#{
#we need to ignore this DB...
#}
#ELSE
#{
$DBcount = $DBcount + 1
#}
if($DB.mounted -eq $False)
{
$FailedDBs += $DB
}
}

#$api.logscriptevent("MailboxMon1.PS1",4365,4,"Here are the first check results: `r`n$tmpstr")

If($FailedDBs.count -gt 0)
{
[void]$tmpstr.append("-----------")
[void]$tmpstr.append("`r`n")
[void]$tmpstr.append("Second Pass:")
[void]$tmpstr.append("`r`n")
Sleep $wait
$results2 = get-mailboxdatabase -server $mbxdb2 -status | ? {$_.Server -like $mbxdb2} | select name, server, mounted

$FailedDBs2 = New-Object System.Collections.ArrayList

foreach($DB2 in $results2)
{
[void]$tmpstr.append("DB: ")
[void]$tmpstr.append($DB2.Name)
[void]$tmpstr.append(" - ")
[void]$tmpstr.append("Mounted: ")
[void]$tmpstr.append($DB2.Mounted)
[void]$tmpstr.append("`r`n")
if($DB2.mounted -eq $False)
{
$FailedDBs2 += $DB2.name
}
}

if($FailedDBs2.count -gt 0)
{
#write-host "Failed DBs"
#write-host $FailedDBs2
#write-host "-------------------"
#write-host $results2
$api.logscriptevent("MailboxMon1.PS1",4368,1,"One or more Mailbox Databases are not mounted: `r`n$tmpstr")
}
else
{
#write-host "All's Good"
#write-host $results2
$api.logscriptevent("MailboxMon1.PS1",4366,2,"All Mailbox DBs are Mounted however the test failed on the first pass: `r`n$tmpstr")
}
}
else
{
#write-host "All's Good"
#write-host $results
$api.logscriptevent("MailboxMon1.PS1",4367,4,"All Mailbox DBs are Mounted: `r`n$tmpstr" )
}

if($DBcount -gt 0)
{
$MBserv = Get-MailboxServer $mbxdb2
if($MBserv.DatabaseCopyAutoActivationPolicy -eq "Blocked")
{
#write-host "DB Server is activation blocked."
$api.logscriptevent("MailboxMon1.PS1",4369,1,"The Server is hosting active DBs but is auto-activation blocked: `r`n$tmpstr" )
}
else
{
#write-host "DB server hosts Databases but is not activation blocked."
$api.logscriptevent("MailboxMon1.PS1",4370,4,"The Server is hosting active DBs and not not auto-activation blocked." )
}
}
else
{
#write-host "DB Server owns no databases"
}
}