param(
  [string]$RepoPath = "C:/DEV/LegacyLoop_Project/legacyloop",
  [string]$OutDir   = "$env:USERPROFILE/Desktop"
)
$stamp = Get-Date -Format "yyyyMMdd_HHmm"
$zip   = Join-Path $OutDir "LegacyLoop_Sync_$stamp.zip"

Set-Location $RepoPath
git pull
$paths = @('00_PRD','01_Project_Plan','02_Documentation')
if (Test-Path $zip) { Remove-Item $zip -Force }
Compress-Archive -Path $paths -DestinationPath $zip -Force
Write-Host "✅ Created: $zip — upload this in the new session chat."
