# cacher.ps1
# Naim Sen
# Mar 2019

[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

[string]$wkgDir = Split-Path $script:MyInvocation.MyCommand.Path
[string]$envFile = $wkgDir + '\env.json'
$envJson = Get-Content $envFile | ConvertFrom-Json

[string]$tempDir = "$Env:TEMP\SpotlightCache"
[string]$spotlightAssets = "$Env:LOCALAPPDATA\Packages\$(Get-ChildItem $Env:LOCALAPPDATA\Packages -Filter "Microsoft.Windows.ContentDeliveryManager*" -Directory)\LocalState\Assets"
[string]$wallpapers = $envJson.saveDir

if (!(Test-Path -Path $tempDir)) {
    New-Item -Path $tempDir -ItemType 'Directory'
}
Copy-Item -Recurse -Force -Path $spotlightAssets -Destination $tempDir
Get-ChildItem "$tempDir\*\*" | Rename-Item -NewName { [io.path]::ChangeExtension($_.name, "jpg") }
Get-ChildItem "$tempDir\*\*.jpg" | ForEach-Object {
    $Image = [System.Drawing.Image]::FromFile($_)
    if ($Image.Width -eq $envJson.sizeFilter.width -and $Image.Height -eq $envJson.sizeFilter.height) {
        New-Item -ItemType File -Path "$wallpapers/$($_.Name)" -Force
        Copy-Item -Force -Path $_.FullName -Destination $wallpapers
    }
    $Image.Dispose()
    Remove-Item $_.FullName
}
Remove-Item -Path "$tempDir" -Recurse