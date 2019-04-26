$cwd = Split-Path $script:MyInvocation.MyCommand.Path

Set-ExecutionPolicy RemoteSigned -scope CurrentUser
 
if (-Not (Test-Path -Path "~\scoop")) {
    iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
}

function Scoop-Install
{
    param (
        [String] $app,
        [ScriptBlock] $setupCode = {}
    )

    Write-Host "Checking install for " -nonewline
    Write-Host "$app" -foreground Cyan -nonewline
    Write-Host " - " -nonewline
    $appPath = "$ENV:userprofile\scoop\apps\$app"
    if (-Not (Test-Path -LiteralPath $appPath))
    {
        Write-Host "Installing" -foreground yellow
        scoop install $app
        &$setupCode
    }
    else {
        Write-Host "Installed" -foreground green
    }
    $null
}

Scoop-Install "neovim" { pip install --user neovim }
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
if (-Not (Test-Path $vimFilesFolder))
{ 
    cmd.exe /c ("mklink /d " + $vimfilesFolder  + " " +($settingPath + $vimfilesFolder) )
}

Set-Location $cwd
