param (
    [Parameter(Mandatory=$false)][string]$repository,
    [Parameter(Mandatory=$true)][string]$tag
)

if( -not $repository )
{
    $repository="https://github.com/mellinoe/imgui.net-nativebuild"
}

Write-Host Downloading native binaries from GitHub Releases...

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$client = New-Object System.Net.WebClient

function DownloadFile {
    param (
        [string]$remoteFile,
        [string]$localDir,
        [string]$localFile
    )

    New-Item -ItemType Directory -Force -Path $PSScriptRoot\$localDir | Out-Null

    $client.DownloadFile(
        "$repository/releases/download/$tag/$remoteFile",
        "$PSScriptRoot/$localDir/$localFile")
    if( -not $? )
    {
        $msg = $Error[0].Exception.Message
        Write-Error "Couldn't download $remoteFile."
        exit
    }

    Write-Host "- $remoteFile"
}

function DownloadFileSet {
    param (
        [string]$setName
    )

    if (Test-Path $PSScriptRoot\deps\$setName\)
    {
        Remove-Item $PSScriptRoot\deps\$setName\ -Force -Recurse | Out-Null
    }

    DownloadFile "$setName.win-x86.dll" "deps/$setName/win-x86" "$setName.dll"
    DownloadFile "$setName.win-x64.dll" "deps/$setName/win-x64" "$setName.dll"
    DownloadFile "$setName.so" "deps/$setName/linux-x64" "$setName.so"
    DownloadFile "$setName.dylib" "deps/$setName/osx" "$setName.dylib"
    DownloadFile "$setName-definitions.json" "src/CodeGenerator/definitions/$setName" "definitions.json"
    DownloadFile "$setName-structs_and_enums.json" "src/CodeGenerator/definitions/$setName" "structs_and_enums.json"
}

DownloadFileSet cimgui
DownloadFileSet cimguizmo
