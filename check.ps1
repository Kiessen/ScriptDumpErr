$Date = Get-Date -Format "MM/dd/yyyy"

$logArray = 
@(
("service",'Get-CimInstance Win32_Service | where {$_.Caption -notmatch "windows" -and $_.PathName -notmatch "Windows" -and $_.Name -notlike "ultraview" -and "*wemeet*"} | Sort State | Format-Table -Property Name, StartMode, State -Auto'),
("startup",'Get-CimInstance Win32_StartupCommand | Format-Table -Property Name, Command -Auto'),
("Application Log",'Get-EventLog -Logname "Application" -EntryType Error,Warning | Where-Object TimeGenerated -Match "$Date"|Format-Table -Property TimeWritten, EntryType, Source, Message -Wrap'),
("System Log",'Get-EventLog -Logname "System" -EntryType Error,Warning | Where-Object TimeGenerated -Match "$Date"|Format-Table -Property TimeWritten, EntryType, Source, Message -Wrap'),
("Driver Log",'Get-PnpDevice -PresentOnly | Where-Object Status -notlike "OK" |Sort Class')
)

for ($x=0;$x -lt $logArray.length; $x++){
$cmd = Invoke-Expression $logArray[$x][1]
$Type = $logArray[$x][0]
Write-Output "==================$Type=================="
if($cmd -eq $null){
Write-Output "Aman"
}
else{
$cmd
}
}