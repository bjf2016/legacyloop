<#
  LegacyLoop — end_session.ps1
  Purpose: Close Session N, prep Session N+1, update trackers, and push to GitHub.

  Usage example:
  pwsh -File .\01_Project_Plan\scripts\end_session.ps1 `
    -N 4 `
    -Next 5 `
    -Title "Casts Dashboard + Entry List Playback" `
    -NextTitle "AI Summary & Rule Linking" `
    -Goals @(
      "AI summary chips on /casts and /casts/[id] (server-side cache)",
      "Rule linking UI (associate entries with Rules of Life)",
      "Capture duration_ms at first successful play; persist in entries",
      "Trash view with restore; small UI polish"
    )
#>

param(
  [Parameter(Mandatory=$true)][int]$N,
  [Parameter(Mandatory=$true)][int]$Next,
  [Parameter(Mandatory=$true)][string]$Title,
  [Parameter(Mandatory=$true)][string]$NextTitle,
  [Parameter(Mandatory=$true)][string[]]$Goals,
  [string]$Environment = "Next14",
  [string]$RepoPath = "C:/DEV/LegacyLoop_Project/legacyloop",
  [string]$SupabaseRef = "ahjosjqabkjgxvcwpufl",
  [switch]$DryRun
)

function Assert-GitRepo($path) {
  if (!(Test-Path $path)) { throw "RepoPath not found: $path" }
  Set-Location $path
  $null = git rev-parse --is-inside-work-tree 2>$null
  if ($LASTEXITCODE -ne 0) { throw "Not a git repo: $path" }
}

function Add-IfMissing([string]$File, [string]$Block, [string]$Marker) {
  if (!(Test-Path $File)) { New-Item -ItemType File -Path $File -Force | Out-Null }
  $content = Get-Content $File -Raw
  if ($content -notmatch [regex]::Escape($Marker)) {
    Add-Content -Path $File -Value "`n$Block`n"
  }
}

$Date = (Get-Date).ToString('yyyy-MM-dd')
$ISO  = (Get-Date).ToString('s') + 'Z'

# Paths
$StatePath = Join-Path $RepoPath '01_Project_Plan/command_center_state.json'
$ContDir   = Join-Path $RepoPath '01_Project_Plan/Continuations'
$ContFile  = Join-Path $ContDir  ("LegacyLoop_Continuation_v1.3_Session{0}_to_Session{1}.md" -f $N,$Next)
$Sprint    = Join-Path $RepoPath '01_Project_Plan/SprintTracker.md'
$Log       = Join-Path $RepoPath '01_Project_Plan/Progress_Log.md'
$PlanCSV   = Join-Path $RepoPath '01_Project_Plan/LegacyLoop_ProjectPlan_v1.csv'

# Ensure directories
New-Item -ItemType Directory -Force -Path $ContDir | Out-Null

# 1) Update state JSON
$state = @{
  project = 'LegacyLoop'
  active_prd = 'v1.3'
  last_completed_session = $N
  next_session = $Next
  current_goal = $NextTitle
  environment = $Environment
  repo_path = $RepoPath
  supabase_ref = $SupabaseRef
  status = 'handoff_to_command_center'
  updated_at = $ISO
}
$stateJson = ($state | ConvertTo-Json -Depth 6)
$stateJson | Set-Content -Path $StatePath -Encoding UTF8

# 2) Continuation markdown (fresh skeleton; safe to overwrite)
$goalsMd = ($Goals | ForEach-Object { "1. $_" }) -join "`n"
$cont = @"
# LegacyLoop — Continuation (v1.3)
**From:** Session $N — $Title
**To:** Session $Next — $NextTitle
**Date:** $Date
**Owner:** Command Center – LegacyLoop
**Persona:** Laura L (Superhumans.life)

## ✅ Completed
- (fill: short bullet list of verified deliverables)

## ⚙️ Environment / Schema Notes
- (fill: migrations/env/policy deltas)

## 🎯 Next Session Objectives
$goalsMd

## 🪜 Next Step
Start Command:
> Start Session $Next – Step 0: Preflight checklist
"@
$cont | Set-Content -Path $ContFile -Encoding UTF8

# 3) SprintTracker append (idempotent via marker)
$sprintMarker = "[[S$N-closed]]"
$sprintBlock = @"
$sprintMarker
- [x] Session $N – $Title (Closed ✅)
- [ ] Session $Next – $NextTitle (In Progress)
"@
Add-IfMissing -File $Sprint -Block $sprintBlock -Marker $sprintMarker

# 4) Progress_Log append (idempotent via marker)
$logMarker = "[[LOG-$Date-S$N]]"
$logBlock = @"
$logMarker
### $Date — Session $N Completed
**Highlights**
- (fill)

**Outcome:** Ready for Session $Next — $NextTitle.
"@
Add-IfMissing -File $Log -Block $logBlock -Marker $logMarker

# 5) Optional: update CSV (append if exists)
if (Test-Path $PlanCSV) {
  $csvLine = "MVP,Session,$Title,Ben,✅ Complete,$Date,"
  Add-IfMissing -File $PlanCSV -Block $csvLine -Marker "$Date,$Title"
}

# 6) Git commit/push
Assert-GitRepo $RepoPath
git add "01_Project_Plan/command_center_state.json" `
        "01_Project_Plan/Continuations" `
        "01_Project_Plan/SprintTracker.md" `
        "01_Project_Plan/Progress_Log.md" `
        "01_Project_Plan/LegacyLoop_ProjectPlan_v1.csv" 2>$null

if ($DryRun) {
  Write-Host "🔎 DryRun: staged changes but skipping commit/push."
} else {
  git commit -m "session: close Session $N and prep Session $Next continuation" 2>$null
  git push
  Write-Host "✅ Handoff complete for Session $N → $Next"
  Write-Host "📄 Continuation: $ContFile"
  Write-Host "🧭 State JSON : $StatePath"
}
