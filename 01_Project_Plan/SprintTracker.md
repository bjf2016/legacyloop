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

## Notes
- Summary API still mock/live; caching added in Session 7
- Rules table intentionally public for now (technical debt)

## Sprint #: 7 
**Dates:** 2025-11–22  → 2025-11-23
**Goal:** Trash, Restore, RLS Hardening + Image Prep (Closed)**
  - Rules table RLS hardened (owner-only).
  - `/api/rules` implemented using authenticated Supabase client with Next 16 `cookies()`.
  - RuleLinkPicker now uses live rules from the API.
  - `entry_images` bucket created for future per-entry images.
  - Supabase client usage cleaned up to avoid multiple GoTrueClient warnings.

## Sprint #: 8
**Dates:** 2025-11–24  → 2025-11-26
- [x] **Session 8 – Image Upload UI + Parent Reflection Stub**
  - Add per-entry image upload (DB + storage + UI).
  - Add parent reflection/journaling stub after entries.
  - Re-enable strict auth gating and run RLS regression.

# Sprint Tracker — LegacyLoop (FatherCast)

## Active Sprint #: 9
- 
- Dates: 2025-11-25 to 2025-12-05
- Goal:
  - Complete `/today` page + strict auth gating.
  - Integrate mic-based recording into Entry flow.
  - Tighten RLS so users only see their own trash entries.
  - Prepare groundwork for mic UX polish (timer, preview, confirmation).

## Tasks

### Session 8 (Done)
- [x] Implement image upload per entry.
- [x] Add `parent_reflection` field + UI.
- [x] Wire image storage + signed URL thumbnail previews.
- [x] Confirm storage RLS for entry images.

### Session 9 (Done)
- [x] Implement `/today` page and redirect flow after login.
- [x] Ensure `/` → `/today` for authenticated users and `/login` otherwise.
- [x] Add header with logged-in user name + sign out.
- [x] Wire “Create today’s entry” to server API + `entry_date`.
- [x] Integrate mic recording into `AudioUpload` and save to entries.
- [x] Tighten entries + trash RLS so users see only their own trash.

### Session 10 (Planned)
- [ ] Add live recording timer to mic recording.
- [ ] Add simple waveform / recording indicator.
- [ ] Add “Play recording preview” before final upload.
- [ ] Add clear confirmation (“Audio attached to this entry and saved to your cast”).
- [ ] Fix remaining delete / trash errors in “Test Cast”.
- [ ] Final pass on Today → Entry → Cast navigation and copy.


---

## Notes

- **Process rules (carry forward to every session):**
  - Work in **tiny, sequential steps**; wait for a “done ✅” from the user before proceeding.
  - Treat the repo and Supabase console as the **source of truth**; do not invent tables, routes, or clients.
  - Prefer **small, testable changes** and watch the browser console + network tab for immediate feedback.
  - When working with Supabase + Next 16:
    - Use shared Supabase helpers only.
    - Remember `cookies()` is async in route handlers.



