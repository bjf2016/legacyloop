# Progress Log

## YYYY-MM-DD
✅ Session 2 – Supabase Auth + Schema + RLS

        Date: 2025-11-09
        Persona: Laura L (Superhumans.life)
        Environment: Local VS Code → Supabase → Next 16 + Turbopack

        🔧 Milestones
        Phase	Deliverable	Status
        0	Preflight (Git + Node 22 + Supabase CLI 2.54)	✅
        1	Supabase Email/Password Auth enabled + local redirects	✅
        2	Tables profiles, casts, entries + legacyloop_visibility enum	✅
        3	Row Level Security policies + insert ownership triggers	✅
        3 B	JWT auth via GoTrue (password grant) and PowerShell RLS tests	✅
        4	Frontend Auth + RLS CRUD demo (/login, /debug/casts)	✅
        5	SprintTracker update + Git commit/push	✅
        🧩 Core Functions Now Active

        Auth: Email + Password (Sign-in/out tested)

        Tables: Profiles / Casts / Entries with owner_id and author_id

        RLS: Verified private/public visibility logic with two users

        Frontend: Working login flow + client-side Supabase integration

        🔒 Verified Security Rules
        Table	Read	Write
        profiles	owner only	owner only
        casts	owner or public	owner only
        entries	author/owner/public view	author only

### 2025-11-09 — Session 2 Completed
**Highlights**
- Supabase Auth (email/password) enabled and tested  
- Tables profiles / casts / entries + `legacyloop_visibility` enum created  
- RLS policies + ownership triggers verified  
- GoTrue JWT auth and PowerShell tests successful  
- Frontend login + CRUD demo (`/login`, `/debug/casts`) functional  
- SprintTracker updated and commit pushed  

**Outcome:** All core security and CRUD flows validated → ready for Storage integration.  
**Next Step:** Session 3 – Supabase Storage + Audio Uploads to implement secure audio storage and signed URL playback.

### 2025-11-10 — Session 4 Completed
**Highlights**
- Built Casts dashboard + Entries list with inline playback
- Implemented signed URL auto-refresh (15m TTL)
- Added soft-delete flow and trash paths
- Orphan importer + path normalizer verified
- RLS tightened: entries CRUD; storage read policy (uid OR cast-owned)

**Outcome:** Ready for Session 5 — AI Summary & Rule Linking.

[[LOG-2025-11-12-S5]]
### 2025-11-12 — Session 5 Completed
**Highlights**
- Added AI summary route + mock mode and inline SummaryChip UI
- Implemented Rules linking (seed, chips, save) with Next 16 params fix
- Added server action + client hook to capture `duration_ms` on first audio load
- Kept signed URL TTL ≤ 15m; no signed URLs persisted
- Dev posture: auth temporarily off for rules endpoints; entries policy allows first duration write

**Outcome:** Ready for Session 6 — Duration & Trash.


# Progress Log — LegacyLoop Project

## 2025-11-16 — Completed Session 6 (Duration & Trash)
- Verified soft-delete path update: `uid/castId/file` → `uid/trash/castId/file`
- Verified restore path normalization and deleted_at reset
- Added `/trash` page with entry listing + restore UI
- Added navigation polish on /casts and /trash
- Added title fallback in EntryRow (Option A confirmed)
- Completed Step 4 mini: duration captured on first loadedmetadata
- RLS re-enabled and validated for:
  - entries
  - casts
  - entry_rule_links
- Corrected entry_rule_links policy to match visibility logic
- Verified RuleLinkPicker works under RLS
- rules table intentionally left with RLS disabled pending `/api/rules` refactor
- All flows retested: delete → trash → restore → link rules → summaries → duration

# Progress Log — LegacyLoop

## Session 7 — Trash, Restore, RLS Hardening + Image Prep

**Date:** 2025-11-23  
**State:** Closed

# Progress Log — LegacyLoop Project

### 2025-11-25 - Completed Session 8 – Image Upload UI + Parent Reflection Stub
- Added parent_reflection column and UI to entries
- Implemented per-entry image uploads (desktop + mobile capture)
- Added signed URL thumbnail previews
- Added new UPDATE RLS policy for secure upserts
- Updated EntryRow UI layout with image + reflection sections
- Verified full CRUD path for images and reflection
- Confirmed all storage RLS rules working as intended


---

### What we did

- **Hardened RLS on `rules`**
  - Enabled RLS and added owner-only policies for all operations on `public.rules`.
  - Verified that existing seed rules for the current user still return correctly under RLS.

- **Implemented `/api/rules` with proper auth**
  - Replaced the old anonymous Supabase client with an authenticated server-side client that uses `await cookies()` (Next.js 16 requirement).
  - New logic:
    - Looks up rules for the current `auth.uid()`.
    - If none exist, inserts three default rules for that user, then re-queries.
    - Returns a simple JSON list of rules.
  - Fixed the earlier 400/500 loops and “Unexpected end of JSON input” errors in the UI.

- **Updated RuleLinkPicker**
  - Now fetches rules from `/api/rules` and renders them as toggleable chips.
  - “Save Links” button posts to `/api/entries/[entryId]/rules` and shows success/error messages inline.
  - Empty state messaging adjusted to be clear but non-blocking (“They’ll appear here automatically — try again in a moment”).

- **Cleaned Supabase client usage**
  - Consolidated browser client creation in `src/lib/supabase/client.ts` to avoid multiple GoTrueClient instances and console warnings.
  - Established a project rule: always use the shared helper for both client and server; no ad-hoc clients.

- **Prepared storage for images**
  - Created an `entry_images` bucket in Supabase Storage.
  - Added initial authenticated policies so only logged-in users can operate on this bucket.
  - No DB columns or UI yet — this is prep for v1.4 image uploads per entry.

---

### Blockers / Follow-ups

- Confirm RLS on `entry_rule_links` and any related tables is consistent with the new `rules` policies (owner-only).
- Refine `entry_images` storage RLS once the exact key pattern (`{user_id}/{entry_id}/...`) and UI flow are implemented.
- Re-enable strict auth gating (e.g. `NEXT_PUBLIC_REQUIRE_AUTH`) and test that:
  - Anonymous users are redirected appropriately.
  - `/casts`, `/casts/[id]`, and `/trash` all enforce authentication.
- Decide whether to add a dedicated `/rules` management page (create/rename/archive rules) in a later session.

---

### Notes for Next Session (Session 8 — Image Upload UI + Parent Reflection Stub)

- Start with a **small, vertical slice**:
  - Add a single `image_path` (or `images` JSONB) field for entries.
  - Build a basic upload widget on the entry card that saves into `entry_images/{user_id}/{entry_id}/...` and stores the path.
  - Render a thumbnail or small inline preview via signed URLs.

- Add the **parent reflection stub**:
  - After an entry, show a reflection text area and save button.
  - Store reflections either in a separate `entry_reflections` table or a new column on `entries`, whichever is cleaner.
  - No AI yet — just capture and persist text.

- After implementing the slice, run a full **RLS regression pass**:
  - Confirm that audio, rules, entry_rule_links, and images all respect owner-only access.
  - Confirm API routes still work under Next 16’s async cookies model.

- Process note:
  - When something fails repeatedly (like `cookies().get`), pause and re-check docs/logs before trying new code.
  - Always prefer small, testable changes over large speculative rewrites.

