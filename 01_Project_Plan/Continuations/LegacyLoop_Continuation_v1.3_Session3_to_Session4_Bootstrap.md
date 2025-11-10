# Continuation Bootstrap — Session 4  
**Project:** LegacyLoop (FatherCast)  
**Active PRD:** v1.3 (Locked)  
**Persona:** Laura L (Superhumans.life)  
**Date:** 2025-11-10  
**From:** Session 3 — Supabase Storage + Audio Uploads  
**To:** Session 4 — Casts Dashboard + Entry List Playback  

---

## ✅ Completed in Session 3
- Created private `audio` bucket (Supabase Storage)
- Enforced per-user folder policies `{uid}/…`
- Added `audio_path`, `audio_url`, `user_id` to `entries`
- Built and verified `AudioUpload` React component  
- Confirmed upload → signed URL → playback → refresh  
- Updated `SprintTracker.md` and `PRD_Changelog.md`

---

## 🎯 Session 4 Objectives
1. Build **Casts Dashboard** page (`/casts`) listing user’s casts  
2. Build **Entries List** page (`/casts/[id]`) listing entries for a selected cast  
3. Reuse playback portion of `AudioUpload` for inline player  
4. Add optional “Delete” flow → move object to `/trash/{uid}/…`  
5. Verify signed URL refresh in list context  
6. Update `SprintTracker.md` + `PRD_Changelog.md` after completion  

---

## ⚙️ Technical Context
- Stack: Next.js 16 (Turbopack) + Supabase Auth/Storage  
- Local Dev: `C:\dev\LegacyLoop_Project\legacyloop-app`  
- Supabase project ref: `ahjosjqabkjgxvcwpufl`  
- Auth: Email/Password (GoTrue)  
- Tables: `profiles`, `casts`, `entries`  
- Bucket: `audio` (private, RLS enforced)  

---

## 🚦 Session 4 Rules
- Proceed one step at a time; wait for `done ✅` after each.  
- Always verify schema and RLS alignment before coding.  
- Evidence on request (screenshots/logs).  
- Deliver Step 0 preflight first.  

---

## 🪜 Next Step
**Start Command:**  
> Start Session 4 – Step 0: Preflight checklist
