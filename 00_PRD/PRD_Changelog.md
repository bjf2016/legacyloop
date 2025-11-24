
# PRD Changelog (Cleaned & Ordered)

## v1.4.2 — Entry Image Attachment (Future Release)
**Status:** Feature (MVP+ / v1.4)
- Parents may attach 1 image per entry (upload or camera capture).
- Private Supabase bucket `images/<uid>/<castId>/<entryId>.jpg`.
- Added `entries.image_path` schema requirement.
- Signed URL TTL ≤ 15 minutes; no signed URLs persisted.
- Thumbnails appear in entry list; full image available via modal.
- Future expansion: up to 3 images per entry, AI captions, moment cards, fallback auto-generated images.

---

## v1.4 — Planned Features (Future Release)
**Status:** Feature Expansion (Not part of MVP)
- Entry Image Attachment (upload or capture 1 image per entry; Supabase private bucket; TTL ≤ 15m)
- Parent/Child Role Model (Father→Son/Daughter, Mother→Son/Daughter)
- Multi-child support (select child per entry)
- Parent Reflection Journal (AI-guided insights, growth prompts, micro-actions)

---

## v1.3.3 — Session 5 (AI Summary & Rule Linking) — 2025-11-12
**Status:** Administrative + Feature
- Added AI summary endpoint and inline SummaryChip UI (mock/live)
- Implemented rule linking UI and API endpoints
- Added `entries.duration_ms` and first-play capture (server action)
- Environment aligned to Next.js 16.0.1 (Turbopack)
- **Dev-only:** temporarily relaxed RLS for `rules` and `entry_rule_links` to accelerate UI; to be secured in Session 6

---

## 2025-11-16 — Session 6 (Duration & Trash)
**Status:** Feature
- Duration capture fully integrated into UI list and player
- Trash view logic prepared; restore flow planned for Session 7
- Navigation and summary panel fixes
- RLS re-harden plan defined for next session
- Deferments validated (restore, hard delete, public entries, full children model)

## 2025-11-23 — Session 7 (Trash, Restore, RLS Hardening + Image Prep)
**Status:** Feature + Hardening
- Completed `/trash` view end-to-end: soft-deleted entries list correctly with restore controls, and restored entries reappear in their original casts.
- Re-enabled and tightened RLS for `rules` and `entry_rule_links`, removing dev-only relaxations and ensuring only the cast owner can link/unlink rules to their entries.
- Fixed rule loading and linking UX: `RuleLinkPicker` now loads rules reliably from Supabase and saves links without JSON/401/500 errors.
- Refactored the Supabase browser client into a shared singleton to remove “Multiple GoTrueClient instances” warnings and stabilize auth state.
- Prepared v1.4 image support by adding `entries.image_path` / `entries.image_caption` and creating a private `entry_images` storage bucket with per-user folder policies.


---

## v1.3.1 — Rules of Engagement Update (2025-11-10)
**Status:** Administrative
- Updated project ROE to include command center handoff kit
- Added alias rule (@ maps to ./src)
- Added signed URL TTL rule (≤ 15m; never store signed URLs)
- Updated continuation + sprint workflow

---

## v1.3 — Baseline (2025-11-08)
**Status:** Locked for Development
- Environment & Git Setup
- Supabase Auth + Schema + RLS
- Supabase Storage + Audio Uploads
- Casts Dashboard + Entry List Playback

---

## v1.2 (2025-11-08)
- Added **Configurable Recording Duration** (30 s / 1 m / 2 m) with default + per-entry override  
- Timer UI, auto-stop, and streak logic added  
- Rules of Life polished; inline “Quick Add” and rule-use counters introduced  
- Persona Laura L + offline mode reconfirmed

---

## v1.1 (2025-10-XX)
- Introduced **Rules of Life** (Father ↔ Son adoption)  
- Added AI Reflection Support section  
- Introduced Offline-first PWA caching and retry system  
- Expanded Acceptance Criteria table  
- Added Phase 1 & Phase 2 roadmaps  
- Strengthened Privacy & Data Ownership commitments

---

## v1.0 (2025-09-XX)
- Initial PRD creation and MVP concept  
- Core vision: daily father-to-son audio reflections  
- Established Supabase + Next.js + OpenAI foundational stack