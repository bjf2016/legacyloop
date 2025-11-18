# LegacyLoop — Continuation (v1.3)
**From:** Session 5 — AI Summary & Rule Linking  
**To:**   Session 6 — Duration & Trash  
**Date:** 2025-11-12  
**Owner:** Command Center – LegacyLoop  
**Persona:** Laura L (Superhumans.life)

## ✅ Completed
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

## ⚙️ Environment / Schema Notes
- **Next.js**: 16.0.1 (Turbopack)
- **Env vars**:  
  - `NEXT_PUBLIC_REQUIRE_AUTH=0` (auth temporarily off for rules endpoints)  
  - `NEXT_PUBLIC_MOCK_AI=1` (mock summaries on)
- **New files/components**:
  - `@/components/SummaryChip.tsx`
  - `@/components/RuleLinkPicker.tsx`
  - `@/lib/actions/entriesServer.ts` (server action: `setEntryDuration`)
- **Updated files**:
  - `@/components/entries/EntryRow.tsx` (summary panel toggle, rule picker mount, duration capture hook)
  - `@/lib/actions/entries.ts` (kept client-only `softDeleteEntry`; removed server code)
- **Schema**:
  - Added `public.entries.duration_ms integer` (ms)
  - RLS temporarily **disabled** on `public.rules` and `public.entry_rule_links` for local dev
  - Optional dev policy added for writing `duration_ms` once (see SQL bundle)

## 🗄️ SQL Bundle (exact, copy/paste)

### Migrations & DDL
```sql
-- Add duration_ms to entries (if missing)
alter table public.entries
  add column if not exists duration_ms integer;

comment on column public.entries.duration_ms
  is 'Audio duration in milliseconds; set once after first successful load.';
