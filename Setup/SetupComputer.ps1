. "$PSScriptRoot/Utilities.ps1"

Set-ExecutionPolicy RemoteSigned -scope CurrentUser
 
if (-Not (Test-Path -Path "~\scoop")) {
    iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
}

&"$PSScriptRoot\Neovim\Setup.ps1"

Scoop-Install "fzf" {
    cmd.exe /c ("mklink $ENV:userprofile\.fzf\bin\fzf.exe $ENV:userprofile\scoop\apps\fzf\current\fzf.exe")
}
Scoop-Install "ag"
Scoop-Install "python" {
    cmd.exe /c ("$ENV:userprofile\scoop\apps\python\current\py3.exe")
    cmd.exe /c "pip.exe install --user neovim"
}
Scoop-Install "cmder"
Scoop-Install "ruby"
Scoop-Install "nodejs"

$plugPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath("~\AppData\Local\nvim\autoload\")
if (-Not (Test-Path $plugPath)) {
    $plugFile = $plugPath + "\plug.vim"
    mkdir $plugPath
    Set-ExecutionPolicy RemoteSigned -scope CurrentUser
    $uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    (New-Object Net.WebClient).DownloadFile($uri,  $plugFile)
}

#VSCode Settings
Set-Location "~\AppData\Roaming\Code\User"
$codesettings = "settings.json"
Remove-Item $codesettings
$dest = ((Split-Path $PSScriptRoot) + "\Settings\VSCode\" + $codesettings)
$str = "mklink " + $codesettings + " " + $dest
cmd.exe /c $str
Set-Location $PSScriptRoot

#VsVim
Set-Location $Env:USERPROFILE
$vsvimfile = "_vsvimrc"
if (-Not (Test-Path $vsvimfile)) {
    $vsvimrc = ((Split-Path $PSScriptRoot) + "\Settings\Vim\" + $vsvimfile)
    if (Test-Path $vsvimfile)  { Remove-Item $vsvimfile }
    cmd.exe /c ("mklink " + $vsvimfile + " " + $vsvimrc)
}


$vimfilesFolder = "Vimfiles"
if (-Not (Test-Path $vimFilesFolder))
{ 
    cmd.exe /c ("mklink /d " + $vimfilesFolder  + " " +($settingPath + $vimfilesFolder) )
}

Set-Location $PSScriptRoot
