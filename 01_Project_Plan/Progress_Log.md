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


