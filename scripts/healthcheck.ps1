Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average
Get-CimInstance Win32_OperatingSystem
Get-Service Winmgmt, wuauserv, Dnscache, Spooler
Test-Connection 8.8.8.8 -Count 2
Resolve-DnsName www.microsoft.com