. "$PSScriptRoot/Utilities.ps1"

Set-ExecutionPolicy RemoteSigned -scope CurrentUser
 
if (-Not (Test-Path -Path "~\scoop")) {
    iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
}

&"$PSScriptRoot\Neovim\Setup.ps1"

Scoop-Install "fzf" {
    cmd.exe /c ("mklink ""$ENV:userprofile\.fzf\bin\fzf.exe"" ""$ENV:userprofile\scoop\apps\fzf\current\fzf.exe""")
}
Scoop-Install "ag"
Scoop-Install "python" {
    cmd.exe /c ("""$ENV:userprofile\scoop\apps\python\current\py3.exe""")
    cmd.exe /c "pip.exe install --user neovim"
}
Scoop-Install "cmder"
Scoop-Install "ruby"
Scoop-Install "nodejs"

$plugPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath("$ENV:userprofile\AppData\Local\nvim\autoload\")
if (-Not (Test-Path "$plugPath")) {
    $plugFile = """$plugPath\plug.vim"""
    mkdir "$plugPath"
    Set-ExecutionPolicy RemoteSigned -scope CurrentUser
    $uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    (New-Object Net.WebClient).DownloadFile($uri,  $plugFile)
}

#VSCode Settings
$codeUserSettings = "$ENV:userprofile\AppData\Roaming\Code\User"
if (-Not (Test-Path "$codeUserSettings")) {
    mkdir "$codeUserSettings"
}
Set-Location "$ENV:userprofile\AppData\Roaming\Code\User"
$codesettings = "settings.json"
if (Test-Path "$codesettings") {
    Remove-Item "$codesettings"
}
$destPath = ((Split-Path $PSScriptRoot) + "\Settings\VSCode\")
if (-Not (Test-Path "$destPath")) {
    mkdir "$destPath"
}
$dest = "$destPath$codesettings"
$str = "mklink ""$codesettings"" ""$dest"""
cmd.exe /c $str
Set-Location $PSScriptRoot

#VsVim
Set-Location "$Env:USERPROFILE"
$vsvimfile = "_vsvimrc"
if (-Not (Test-Path $vsvimfile)) {
    $vsvimrc = ((Split-Path $PSScriptRoot) + "\Settings\Vim\" + $vsvimfile)
    if (Test-Path $vsvimfile)  { Remove-Item $vsvimfile }
    cmd.exe /c ("mklink ""$vsvimfile"" ""$vsvimrc""")
}

#Java
Query-Install {
    Write-Host "Prompt: " -foreground Gray -nonewline
    Write-Host "Install " -nonewline
    Write-Host "Java" -foreground Cyan -nonewline
    Write-Host " (y)? " -nonewline
    Write-Host ""
 } {
    Scoop-AddBucket "java"
    Scoop-Install "ojdkbuild8"
    Scoop-Install "ojdkbuild9"
}

#Fonts
Query-Install {
    Write-Host "Prompt: " -foreground Gray -nonewline
    Write-Host "Install " -nonewline
    Write-Host "Fonts" -foreground Cyan -nonewline
    Write-Host " (y)? " -nonewline
    Write-Host ""
 } {
    Scoop-AddBucket "nerd-fonts"
    Scoop-Install "SourceCodePro-NF" -Sudo
    $fontPath = Convert-Path "$ENV:userprofile\scoop\apps\SourceCodePro-NF\"
    Write-Host "Font Versions: " -nonewline
    $versions = Get-ChildItem $fontPath -Directory
    $versions | ForEach-Object {
        Write-Host ($_.BaseName + " ") -foreground Yellow -nonewline
    }
    $version = Read-Host -Prompt "Which version to install:"
    $sa =  new-object -comobject shell.application
    $Fonts =  $sa.NameSpace(0x14)

    $versions | where {$_.BaseName -eq $version } | ForEach-Object {
        Write-Host "Installing Version: " -nonewline
        Write-Host "$version" -foreground Cyan -nonewline
        $ttfs = Get-ChildItem $_.FullName -File
        foreach($ttf in $ttfs) {
            $Fonts.CopyHere($ttf.FullName)
        }
    }
}

#Extras
Query-Install {
    Write-Host "Prompt: " -foreground Gray -nonewline
    Write-Host "Install " -nonewline
    Write-Host "Extras" -foreground Cyan -nonewline
    Write-Host " (y)? " -nonewline
    Write-Host ""
 } {
    Scoop-AddBucket "extras"
    Scoop-Install "posh-git"
    Scoop-Install "oh-my-posh"
}

#Super Extras
Query-Install {
    Write-Host "Prompt: " -foreground Gray -nonewline
    Write-Host "Install " -nonewline
    Write-Host "Unnecessary Extras" -foreground Cyan -nonewline
    Write-Host " (y)? " -nonewline
    Write-Host ""
 } {
    Scoop-Install "7zip"
    Scoop-Install "go"
    Scoop-Install "ruby"
    Scoop-Install "rust"
    Scoop-Install "gradle"
    Scoop-Install "scala"
    Scoop-Install "touch"
}

Set-Location $PSScriptRoot
