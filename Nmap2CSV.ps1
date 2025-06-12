$currentPath = Get-Location
$datetime = Get-Date
Get-Content .\alligator.txt | Write-Host -ForegroundColor Red
Write-Host "`nNmap2CSV - Download and convert the latest network intelligence from Nmap to CSV.`n`nDependencies: grep (GNUWin32) - https://github.com/ndr-repo/gnuwin32_Scan-Download" -ForegroundColor Red
Write-Host "`nCreated by Gabriel H., @weekndr_sec`nhttps://github.com/ndr-repo | http://weekndr.me" -ForegroundColor Red
Write-Host "`nFor enterprise-grade tools like this, visit https://stacksecure.co/product`n"-ForegroundColor Red
((((Invoke-WebRequest -Uri "https://svn.nmap.org/nmap/nmap-services" -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36" -Method Get).Content | Out-String -Stream | Select-String -Pattern '^[a-zA-Z0-9]*.*[a-zA-Z0-9][ ].*' |  gawk '{ print $1,$2,$5,$6,$7,$8,$9 ,$10,$11 }' | Sort-Object -Unique ) | Out-String -Stream  ) -replace ' | ',',' -replace ',,,,,,,,','' | Out-String | gawk -F ',' '{ print $1,$2 }'  ) -replace ' ',','  | grep -v '^#.*'  | grep -v '^(.*' | Out-File $currentPath\Nmap_Protocols.csv utf8 -Force
New-Item $currentPath\Nmap_Ports_Protocols.csv -Force 
Write-Output "Protocol,Port,Transport" | Out-File $currentPath\Nmap_Ports_Protocols.csv -Force utf8
(csvcut -z 200000000 -H -c 1,2 $currentPath\Nmap_Protocols.csv | grep -oP '^[a-zA-Z0-9].*[a-z]' | grep -v '^a.*b.*' ) -replace '/',',' | Out-File $currentPath\Nmap_Ports_Protocols.csv -Append utf8
Remove-Item $currentPath\Nmap_Protocols.csv -Force 
Import-csv $currentPath\Nmap_Ports_Protocols.csv -Encoding UTF8 | Where-Object -Property "Protocol" -NotMatch "unknown" | Sort-Object -Property "Protocol","Port","Transport" | Out-GridView -Title "Nmap2CSV - Ports & Protocols - $datetime"
Write-Host "Completed!" -ForegroundColor Red
Write-Host "Results saved to Nmap_Ports_Protocols.csv" -ForegroundColor Red
Write-Host "`nCreated by Gabriel H., @weekndr_sec`nhttps://github.com/ndr-repo | http://weekndr.me" -ForegroundColor Red
