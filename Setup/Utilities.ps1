
function Scoop-Install
{
    param (
        [String] $app,
        [Switch] $sudo,
        [ScriptBlock] $setupCode = {}
    )

    Write-Host "Checking install for " -nonewline
    Write-Host "$app" -foreground Cyan -nonewline
    Write-Host " - " -nonewline
    $appPath = "$ENV:userprofile\scoop\apps\$app"
    if (-Not (Test-Path -LiteralPath $appPath))
    {
        Write-Host "Installing" -foreground yellow
        if($sudo)
        {
            sudo scoop install $app
        }
        else {
            scoop install $app
        }
        &$setupCode
    }
    else {
        Write-Host "Installed" -foreground green
    }
    $null
}

function Scoop-AddBucket
{
    param(
        [String]$bucket
    )
     $buckets = (scoop bucket list)
     if (-Not ($buckets -match $bucket)) {
        scoop bucket add $bucket
     }
     $null
}

function Query-Install
{
    param (
        [ScriptBlock] $prompt,
        [ScriptBlock] $setupCode = {}
    )

    &$prompt
    $key =  [System.Console]::ReadKey()
    if ($key.Key -eq [System.ConsoleKey]::Y)
    {
        &$setupCode
    }
    $null
}
