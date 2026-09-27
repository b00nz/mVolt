#Requires -Version 7
[CmdletBinding()]
param(
    [string] $Tag,
    [string] $Path = "$PSScriptRoot/../../bucket/mvolt.json"
)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$Path = (Resolve-Path $Path).Path
$text = Get-Content $Path -Raw
$manifest = $text | ConvertFrom-Json
$userAgent = 'mvolt-scoop-manifest'

if (-not $Tag) {
    $repo = ([uri]$manifest.homepage).AbsolutePath.Trim('/')
    $headers = @{ 'User-Agent' = $userAgent }
    if ($env:GITHUB_TOKEN) { $headers['Authorization'] = "Bearer $env:GITHUB_TOKEN" }
    $Tag = (Invoke-RestMethod "https://api.github.com/repos/$repo/releases/latest" -Headers $headers).tag_name
}

$version = $Tag -replace '^v', ''
if ($version -notmatch '^\d+(\.\d+)+$') { throw "Unexpected release tag '$Tag'" }

$targets = @()
if ($manifest.autoupdate.url) {
    $targets += [pscustomobject]@{ Current = $manifest; Template = $manifest.autoupdate }
}
foreach ($arch in $manifest.autoupdate.architecture.PSObject.Properties) {
    $targets += [pscustomobject]@{ Current = $manifest.architecture.($arch.Name); Template = $arch.Value }
}
if (-not $targets) { throw 'Manifest has no autoupdate URL' }

$download = New-TemporaryFile
try {
    foreach ($target in $targets) {
        $url = $target.Template.url.Replace('$version', $version)
        Invoke-WebRequest ($url -split '#/')[0] -OutFile $download -UserAgent $userAgent
        $hash = (Get-FileHash $download -Algorithm SHA256).Hash.ToLower()
        $text = $text.Replace("`"url`": `"$($target.Current.url)`"", "`"url`": `"$url`"")
        $text = $text.Replace("`"hash`": `"$($target.Current.hash)`"", "`"hash`": `"$hash`"")
        $target | Add-Member Expected ([pscustomobject]@{ url = $url; hash = $hash })
    }
} finally {
    Remove-Item $download -ErrorAction SilentlyContinue
}
$text = $text.Replace("`"version`": `"$($manifest.version)`"", "`"version`": `"$version`"")

$updated = $text | ConvertFrom-Json
if ($updated.version -ne $version) { throw 'Version was not updated' }
$expected = @($targets.Expected.hash | Sort-Object)
$actual = @(@($updated.hash) + @($updated.architecture.PSObject.Properties.Value.hash) | Where-Object { $_ } | Sort-Object)
if ("$expected" -ne "$actual") { throw 'Hashes were not updated' }

Set-Content $Path $text -NoNewline
Write-Host "mvolt: $($manifest.version) -> $version"
