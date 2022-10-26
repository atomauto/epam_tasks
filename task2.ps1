#!/usr/bin/pwsh
#Param is mandatory, unnamed params and extra params are forbidden
param (
    [Parameter(Position=0, Mandatory)]
    [string] $file
)
$accounts = Import-Csv -Path $file
#array to count duplicate names
$names = @{}
$accounts | ForEach-Object {
    #Using TextInfo to capitalize every word in column 
    $_.name = (Get-Culture).TextInfo.ToTitleCase($_.name)
    #Getting lowercase name and surname for email generation
    $name,$surname = ($_.name.tolower().Split(" "))
    $_.email = $name+$surname[0]+"@abc.com"
    $names[$_.name]++
}
$accounts | ForEach-Object {
    #Regenerate and change email for duplicates with location_id
    if ($names[$_.name] -gt 1) {
        $name,$surname = ($_.name.tolower().Split(" "))
        $_.email = $name+$surname[0]+$_.location_id+"@abc.com"
    }
}
#PWSH doesn't return directory with slash, so we have potentional problems with portability on windows and shitty windows reverse slash
if ([System.IO.Path]::GetDirectoryName($file) -eq "") {
    $output_file = "accounts_new.csv"
}
else {
    $output_file = [System.IO.Path]::GetDirectoryName($file) + "/accounts_new.csv"
}
$accounts | Export-Csv -Path $output_file