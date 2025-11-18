# PRD Changelog — LegacyLoop (FatherCast)

## v1.3.3 — Session 5 (AI Summary & Rule Linking) — 2025-11-12
**Status:** Administrative + Feature
- Environment aligned to Next.js 16.0.1 (Turbopack)
- Added AI summary endpoint and inline summary UI (mock/live)
- Implemented rules linking UI and API
- Added `entries.duration_ms` and first-play capture (server action)
- **Dev-only:** temporarily relaxed RLS for `rules` and `entry_rule_links` to accelerate UI; to be secured in Session 6

---

## v1.3.1 — ROE Integration Update (2025-11-08)
**Status:** Administrative Update – No functional scope change  
**Summary of Updates:**
- Incorporated **Rules of Engagement (ROE) v1.0** as a mandatory baseline control document  
- Expanded baseline stack from 6 to 7 canonical files  
- Updated **Command Center header** and **Session Start Template** to reference all seven  
- Introduced “ROE Check Block” for all session replies (Baseline • Assumptions • Verified Sources)  
- Reinforced one-step cadence, no-hallucination policy, and explicit version control  
- No impact on MVP features or acceptance criteria  

---

## v1.3 (2025-11-08)
**Status:** Locked for Development — Official MVP Build Baseline  
**Summary of Updates:**
- Consolidated all prior PRD versions (v1.0 → v1.2) into unified **v1.3 baseline**
- Confirmed full offline caching support for both phone and laptop (IndexedDB + Background Sync)
- Added optional **video blogging** as a supported input method with identical AI summary pipeline
- Unified product naming: **LegacyLoop (product)** and **FatherCast (feature)**
- Confirmed locked stack:
  - Next.js 14  
  - Supabase (single project, US-West)  
  - OpenAI (Whisper + GPT-4o-mini)  
  - Vercel hosting  
  - VS Code + Codex (local + cloud dev)  
  - Node 22 LTS
- Clarified data caching: “All unsynced entries stored locally in encrypted cache; auto-sync on reconnect”
- Revised structure of **Configurable Recording Duration** section (default + override + timer)
- Minor editorial improvements: readability, consistency, redundancy cleanup
- Established this version as the **official baseline for development start (MVP)**

#### [2025-11-10] Session 3 — Supabase Storage Integration
- Implemented secure audio storage per PRD § 2.3 and § 3.1.
- Added `audio` bucket (private) with RLS enforcing `{auth.uid()}/…`.
- Extended `entries` schema (`audio_path`, `audio_url`, `user_id`).
- Client: new `AudioUpload` component; supports signed URL playback + 1-hour renewal.
- Verified E2E flow (auth → upload → signed URL → DB → refresh).

#### [2025-11-10] Session 4 - (Casts & Playback)
- Implemented Casts dashboard and Entry list playback
- Signed URL refresh strategy (<= 15 minutes TTL) implemented
- Soft delete flow to /trash/<uid>/... with DB flag
- Orphan importer utility added; path normalizer confirmed no moves needed
- RLS tightened for entries; storage read policy extended to uid-or-cast pattern
- Next: add `user_id` usage across app, deprecate `owner_id`

## 2025-11-16 — Session 6 (Duration & Trash)
### Added
- `/trash` page added with trashed entries list
- Restore flow implemented (storage path reversal + deleted_at reset)
- Trash navigation added:
  - “View Trash” on /casts
  - “Back to My Casts” on /trash
- Display title fallback added to EntryRow (“Untitled Entry”)
- Shortened audio_path display in Trash page

### Updated
- Soft-delete logic finalized:
  - Move from `user/castId/file` → `user/trash/castId/file`
  - On restore, remove `/trash` segment and reset deleted_at
- RLS overhaul:
  - entries: dev update policy removed, owner visibility confirmed
  - entry_rule_links: RLS enabled + policy aligned with entry visibility
  - casts: owner-based RLS verified
  - rules: left intentionally public (RLS disabled) pending refactor

### Fixed
- RuleLinkPicker errors under RLS
- Duration capture incorrect behavior on anonymous update (removed dev policy)
- Missing navigation from Trash back to Casts

### Deferred (v1.4+)
- RLS re-enable on `rules` table after `/api/rules` refactor
- Parent Reflection (v1.4 requirement)
- Multi-child support (v1.4 requirement)
- Summary caching + display timestamp

## 2025-11-12 — Session 5 (AI Summary & Rule Linking)
- (Existing content unchanged)

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
