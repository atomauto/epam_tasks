#!/usr/bin/pwsh
#All 3 params are mandatory, unnamed params and extra params are forbidden
param (
    #TODO: ValidateScript throws nasty error that user won't understand
    #We have to use regexp for workaround with builtin [ipaddress] validation because it can convert "132" to 0.0.0.132 IP address
    [ValidateScript({ $_ -match "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$" -and [bool]($_ -as [ipaddress]) })]
    [Parameter(Mandatory, ValueFromPipelineByPropertyName = $true)]
    [string] $ip_address_1,
    [ValidateScript({ $_ -match "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$" -and [bool]($_ -as [ipaddress]) })]
    [Parameter(Mandatory, ValueFromPipelineByPropertyName = $true)]
    [string] $ip_address_2,
    #For demonstration purposes, network mask validation is moved to function
    [Parameter(Mandatory, ValueFromPipelineByPropertyName = $true)]
    [string] $network_mask
)
function is_valid_mask_IPv4 ($network_mask) {
    $valid_bytes = '0|128|192|224|240|248|252|254|255'
    $mask_pattern = ('^((({0})\.0\.0\.0)|' -f $valid_bytes) + ('(255\.({0})\.0\.0)|' -f $valid_bytes) + 
    ('(255\.255\.({0})\.0)|' -f $valid_bytes) + ('(255\.255\.255\.({0})))$' -f $valid_bytes)
    #We consider network mask 0.0.0.0 and 255.255.255.255 are valid
    return $network_mask -match $mask_pattern
}

if (!(is_valid_mask_IPv4 -network_mask $network_mask)) { 
    throw "Network mask is incorrect. The script will be aborted."
}

# Write-Host "IP address 1 is incorrect. The script will be aborted." -ForegroundColor Red

Write-Host "IP address 1 is $ip_address_1 and second is $ip_address_2. Network mask is $network_mask" -ForegroundColor Yellow
  