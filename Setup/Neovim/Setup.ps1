. "$PSScriptRoot/../Utilities.ps1"

Scoop-Install "neovim" { pip install --user neovim }

#Neovim
Push-Location "$ENV:userprofile\AppData\Local"
if (-Not (Test-Path "nvim")) { mkdir nvim }
Set-Location "nvim"
$settingPath = Join-Path ($PSScriptRoot | Split-Path | Split-Path) "\Settings\Vim\"
$hardCodedFiles = @(".vimrc")
$hardCodedFiles | Foreach-Object {
	echo $hcFile
    $hcFile = $settingPath + $_
    if (Test-Path $_)  { Remove-Item $_ }
    cmd.exe /c ("mklink """ + $_ + """ """ + $hcFile + """")
}
Get-ChildItem $settingPath  -File -Filter "*.vim" | Foreach-Object {
    if (Test-Path $_.Name)  { Remove-Item $_.Name }
    cmd.exe /c ("mklink """ + $_.Name + """ """ + ($_.FullName) + """")
}

$vimfilesFolder = "Vimfiles"
if (-Not (Test-Path $vimFilesFolder))
{ 
    cmd.exe /c ("mklink /d """ + $vimfilesFolder  + """ """ +($settingPath + $vimfilesFolder) + """" )
}

Pop-Location
