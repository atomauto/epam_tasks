
#! /usr/bin/pwsh
#All 3 params are mandatory, unnamed params and extra params are forbidden
param (
#    [ValidateScript({ $_ -match "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$" -and [bool]($_ -as [ipaddress]) })]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName=$true)]
    [string]
    $ip_address_1,
    [Parameter(Mandatory,ValueFromPipelineByPropertyName=$true)]
    [string]
    $ip_address_2,
    [Parameter(Mandatory,ValueFromPipelineByPropertyName=$true)]
    [string]
    $network_mask
)
Write-Output $ip_address_1
#We have to use regexp for workaround with builtin [ipaddress] validation because it can convert "132" to 0.0.0.132 IP address
function is_valid_IPv4 ($ip) {
    return ($ip -match "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$" -and [bool]($ip -as [ipaddress]))
}
if (is_valid_IPv4 -ip $ip_address_1) {
    Write-Host "IP address 1 is correct. You are so smart at typing correct IPs )." -ForegroundColor Green
}
else {
    Write-Host "IP address 1 is not valid IP address! The script will be aborted." -ForegroundColor Red
}
if (is_valid_IPv4 -ip $ip_address_2) {
    Write-Host "IP address 2 is correct. You are so smart at typing correct IPs )." -ForegroundColor Green
}
else {
    Write-Host "IP address 2 is not valid IP address! The script will be aborted." -ForegroundColor Red
}
Write-Host "IP address 1 is $ip_address_1 and second is $ip_address_2. Network mask is $network_mask" -ForegroundColor Yellow
  