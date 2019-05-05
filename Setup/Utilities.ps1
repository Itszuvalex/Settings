
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

