# LegacyLoop — Session Startup Checklist (v1)

## What to open
- New chat titled: `Session {N} – {Topic} (LegacyLoop)`

## What to provide to the chat (choose one)
- ✅ Preferred: Upload `LegacyLoop_Sync.zip` (from `sync_for_chat.ps1`)
- or
- Minimal: Upload `01_Project_Plan/command_center_state.json` **and** paste the Kickoff Message from the latest Continuation doc.

## Kickoff message (paste first)
- From: `01_Project_Plan/Continuations/LegacyLoop_Continuation_v1.3_Session{N-1}_to_Session{N}.md`
- Keep: Persona, Active PRD, Rules, Goals
- End with: “Please begin with Step 0: Preflight checklist.”

## Preflight artifacts (should already exist)
- `00_PRD/PRD_Changelog.md` (latest v1.3.x)
- `01_Project_Plan/SprintTracker.md` (shows last closed, current in progress)
- `01_Project_Plan/Progress_Log.md` (latest entry at top)
- `01_Project_Plan/command_center_state.json` (last_completed_session == N-1; next_session == N)

## Sanity checks (quick)
- GitHub clean (no uncommitted changes)
- Supabase ref confirmed
- Next.js runs locally if needed
