$cwd = Split-Path $script:MyInvocation.MyCommand.Path

if (-Not (Test-Path "~\scoop")) {
    Set-ExecutionPolicy RemoteSigned -scope CurrentUser
    iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
}
    
if (-Not (Test-Path "~\scoop\apps\neovim")) {
    scoop install neovim
    pip install --user neovim
}

if (-Not (Test-Path "~\scoop\apps\fzf")) {
    scoop install fzf
    cmd.exe /c ("mklink " + "$ENV:userprofile\.fzf\bin\fzf.exe" + " " + "$ENV:userprofile\scoop\apps\fzf\current\fzf.exe")
}

if (-Not (Test-Path "~\scoop\apps\ag")) {
    scoop install ag
}

if (-Not (Test-Path "~\scoop\apps\python")) {
    scoop install python
    cmd.exe /c "~\scoop\apps\python\current\py3.exe"
    cmd.exe /c "C:\Program Files (x86)\Microsoft Visual Studio\Shared\Python37_64\Scripts\pip.exe install --user neovim"
}

if (-Not (Test-Path "~\scoop\apps\python")) {
    scoop install python
    cmd.exe /c "~\scoop\apps\python\current\py3.exe"
}

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
$dest = ((Split-Path $cwd) + "\Settings\VSCode\" + $codesettings)
$str = "mklink " + $codesettings + " " + $dest
cmd.exe /c $str
Set-Location $cwd

#VsVim
Set-Location $Env:USERPROFILE
$vsvimfile = "_vsvimrc"
if (-Not (Test-Path $vsvimfile)) {
    $vsvimrc = ((Split-Path $cwd) + "\Settings\Vim\" + $vsvimfile)
    if (Test-Path $vsvimfile)  { Remove-Item $vsvimfile }
    cmd.exe /c ("mklink " + $vsvimfile + " " + $vsvimrc)
}

#Vim
Set-Location "~\AppData\Local"
if (-Not (Test-Path "nvim")) { mkdir nvim }
Set-Location "nvim"
$settingPath = (((Split-Path $cwd) + "\Settings\Vim\"))
$vimrc = ".vimrc"
if (Test-Path $vimrc)  { Remove-Item $vimrc }
cmd.exe /c ("mklink " + $vimrc + " " + ($settingPath + $vimrc))
Get-ChildItem $settingPath  -File -Filter "*.vim" | Foreach-Object {
    if (Test-Path $_.Name)  { Remove-Item $_.Name }
    cmd.exe /c ("mklink " + $_.Name + " " + ($_.FullName))
}
$vimfilesFolder = "Vimfiles"
cmd.exe /c ("mklink /d " + $vimfilesFolder  + " " +($settingPath + $vimfilesFolder) )
Set-Location $cwd
