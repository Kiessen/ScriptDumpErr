$Date = Get-Date -Format "MM/dd/yyyy"
$logArray = 
@(
("service",'Get-CimInstance Win32_Service | where {$_.Caption -notmatch "windows" -and $_.PathName -notmatch "Windows" -and $_.Name -notlike "ultraview" -and "*wemeet*"} | Sort State | Format-Table -Property Name, StartMode, State -Auto'),
("startup",'Get-CimInstance Win32_StartupCommand | Format-Table -Property Name, Caption, Command -Auto'),
("Application Log",'Get-EventLog -Logname "Application" -EntryType Error,Warning | Where-Object TimeGenerated -Match "$Date"|Format-Table -Property TimeWritten, EntryType, Source, Message -Wrap'),
("System Log",'Get-EventLog -Logname "System" -EntryType Error,Warning | Where-Object TimeGenerated -Match "$Date"|Format-Table -Property TimeWritten, EntryType, Source, Message -Wrap'),
("Ram Available",'(((Get-CIMInstance Win32_OperatingSystem -ComputerName $computer).FreePhysicalMemory) * 1024)'),
("Total Ram ",'((((Get-CimInstance Win32_PhysicalMemory -ComputerName $computer).Capacity) | Measure-Object -Sum).Sum)'),
("Memory",' wmic MemoryChip get BankLabel,Capacity,ConfiguredClockSpeed,Manufacturer,Speed,PartNumber')
("Driver Log",'Get-PnpDevice -PresentOnly | Where-Object Status -notlike "OK" |Sort Class'),
("IP",'ipconfig | FINDSTR /R "[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*"'),
("Connection",'Test-Connection -ComputerName "www.google.com",1.1.1.1| Format-Table -Property Address, IPV4Address, ResponseTime'),
("Check Wifi",' netsh wlan show interfaces | FINDSTR "Name |= Description |= Signal |= SSID |= State |= Connection mode|=Receive rate|=Transmit rate"'),
("Check Wifi advanced option",'Get-NetAdapterAdvancedProperty Wi-Fi |Format-Table -Property DisplayName, DisplayValue, ValidDisplayValues -Auto | FINDSTR /r /b "DisplayName |= --------- |= Transmit Power |= Roaming Aggressiveness |= Throughput Booster"'),
("Check Storage",'wmic diskdrive get model,status'),
("Test Storage for Error",'Repair-Volume -DriveLetter C -Scan'),
("Dump Battery Report File in Battery.html",'powercfg /batteryreport /output ./battery.xml')
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