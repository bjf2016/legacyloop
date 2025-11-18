# Sprint Tracker — LegacyLoop (FatherCast)

## Sprint 0 — Environment & Git Setup
- [x] VS Code + Codex verified
- [x] GitHub repos created (`legacyloop`, `legacyloop-app`)
- [x] Next.js app scaffolded and running locally
- [x] Supabase project created (US-West)
- [x] `.env.local` configured (URL + anon key)
- [x] Vercel linked & deployed; `/api/health` → ok:true
- [ ] OPENAI_API_KEY added (pending)
- [ ] Domain cut-over plan (later)

### Notes
- Operate in **one-step cadence** with visual evidence on request.
- Session transcripts and screenshots retained for verification.

---

## Sprint 2 — Supabase Auth, Schema & Storage  
**Dates:** Nov 8 – Nov 15 2025  
**Goal:** Complete Supabase Auth + Schema + RLS and implement secure Storage integration.

### ✅ Session 1 — Environment & Git Setup (Closed)
- Verified local VS Code + GitHub connectivity  
- Project scaffolded and running locally  

### ✅ Session 2 — Supabase Auth + Schema + RLS (Closed 2025-11-09)
- Enabled Supabase email/password auth  
- Created tables (`profiles`, `casts`, `entries`)  
- Added RLS + owner/author triggers  
- Verified protected CRUD via PowerShell & frontend  
- Built login + debug pages for live RLS demo  

### ✅ Session 3 — Supabase Storage + Audio Uploads (Closed 2025-11-10)
- Added private **`audio`** bucket (dashboard)  
- Implemented per-user folder RLS policies `{uid}/…`  
- Extended `entries` schema (`audio_path`, `audio_url`, `user_id`)  
- Built React **`AudioUpload`** component (upload + signed URL playback)  
- Verified full flow → upload → signed URL → playback → refresh  
- **Status:** ✅ Complete (ready for integration with Cast view)

---

## Next Sprint — Sprint 3
**Goal:** Build Cast Dashboard + Entry List Playback  
**Focus Areas:**  
- List entries per cast  
- Display audio durations + inline playback  
- Enable optional deletion / recycle-bin policy  
- Refine UI + permissions for multi-user casts

## Sprint 4 — Casts Dashboard + Entries Playback (Session 4)
- [x] /casts dashboard lists my casts with counts & last entry (excludes trashed)
- [x] /casts/[id] entries page with inline audio player
- [x] Signed URL auto-refresh on error/expiry (15 min TTL)
- [x] Soft delete: moves blob to audio/<uid>/trash/<castId>/... and sets deleted_at
- [x] “Quick Import Orphans” tool (scans storage; inserts missing DB rows)
- [x] Path normalizer (now confirms paths are already normalized)
- [x] RLS policies for entries insert/select; storage select policy (uid OR cast-owned)
- [ ] Switch app queries from owner_id → user_id (planned next)


## Sprint 5 - [[S5-closed]]
- [x] Session 5 – AI Summary & Rule Linking (Closed ✅)
- `/api/ai/summary` route added with mock/live capability; JSON-only G/B/U/L format (no signed URLs persisted; TTL ≤ 15m respected)
- Summary UI wired per entry:
  - `SummaryChip` component (inline panel with textarea + Generate Summary)
  - Works in mock mode via `NEXT_PUBLIC_MOCK_AI=1`
- Rules linking flow:
  - `/api/rules` (cookie-free for dev) with auto-seed from existing `casts.user_id`
  - `/api/entries/[id]/rules` (Next 16 `params` fix) to save selected rule links
  - `RuleLinkPicker` component with chips + Save Links confirmation
- Duration capture (Step 4 mini):
  - `entries.duration_ms` column added
  - Server action `setEntryDuration` (`@/lib/actions/entriesServer`) writes once when `loadedmetadata`/`durationchange` fires
  - Client hook added in `EntryRow` to call server action
- Soft delete still functional (move storage path to `/audio/<uid>/trash/<castId>/...` and mark `entries.deleted_at`)
- Commit checkpoints pushed during session
- [ ] Session 6 – Duration & Trash (In Progress)


## Sprint #: 6
**Dates:** 2025-11-14 → 2025-11-16  
**Goal:** Session 6 — Duration Capture, Trash & Restore + RLS Hardening

## Completed
- Duration capture on first metadata load
- Soft delete + storage move → `/trash/{castId}/…`
- Restore flow + storage reversal + deleted_at reset
- Added `/trash` page + UI polish
- Added View Trash button on /casts
- Added Back to My Casts navigation on /trash
- Shortened audio_path for trash display
- RLS policies updated (entries, casts, entry_rule_links, rules)
- RuleLinkPicker working fully under RLS
- No schema changes this sprint

## Next Sprint
- Sprint 7  
- **Goal:** UI Polish + Summary Enhancements

## Notes
- Summary API still mock/live; caching added in Session 7
- Rules table intentionally public for now (technical debt)

