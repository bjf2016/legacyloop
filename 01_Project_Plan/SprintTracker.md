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
