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
