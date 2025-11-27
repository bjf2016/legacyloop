# LegacyLoop — Continuation (v1.3)
**From:** Session 8 — Image Upload UI + Parent Reflection Stub  
**To:**   Session 9 — Today Page (Entry Creation) + Strict Auth Gating Cleanup  
**Date:** 2025-11-25  
**Owner:** Command Center – LegacyLoop  
**Persona:** Laura L (Superhumans.life)

---

## ✅ Completed in Session 8
- Added `image_path` + `image_caption` columns confirmed in schema  
- Implemented per-entry **image upload UI** (desktop + mobile camera)  
- Created secure upload path: `entry_images/{userId}/{entryId}/main.ext`  
- Implemented **Supabase upload** with upsert  
- Implemented **signed URL thumbnail preview** (TTL ≤ 15 minutes)  
- Added **RLS policies** on `storage.objects`:
  - SELECT — read own images  
  - INSERT — upload own images  
  - UPDATE — replace own images  
- Updated EntryRow to include `EntryImageSection`  
- Added `parent_reflection` column  
- Added **Parent Reflection UI** + save flow  
- Verified DB persistence + reload  
- Confirmed no regressions in audio, rule linking, or trash flow  
- Strict adherence to shared Supabase helpers & alias rules  

---

## ⚙️ Environment / Schema Notes (Updated)

- **Stack**
  - Next.js 16 (App Router, React Server Components, Turbopack dev).
  - Supabase project: `ahjosjqabkjgxvcwpufl` (US-West).
  - Local repo: `C:/DEV/LegacyLoop_Project/legacyloop-app`.

- **Storage**
  - `audio` bucket already wired for entry audio (per previous sessions).
  - New `entry_images` bucket created for per-entry images.
    - All image keys will ultimately live under a prefix derived from the user id and entry id, e.g.  
      `entry_images/{user_id}/{entry_id}/image-*.jpg`.
    - Final RLS and folder conventions will be locked in during Session 8+.

- **Rules / Rule Links**
  - `public.rules`
    - Columns: `id (uuid)`, `user_id (uuid)`, `title (text)`, `description (text)`, `created_at (timestamptz)`.
    - RLS: *owner-only* for all operations.
  - `public.entry_rule_links` (from earlier sessions)
    - Used by `/api/entries/[entryId]/rules` to link entries ↔ rules.
    - Still expected to be owner-only; verify RLS next session when adding richer UI.

---

## 🔐 Auth & RLS Lessons (Do NOT repeat mistakes)

- **Next.js 16 `cookies()` is async**
  - In route handlers we must use:
    ```ts
    import { cookies } from "next/headers";

    export async function GET() {
      const cookieStore = await cookies();
      // pass cookieStore into the Supabase server client
    }
    ```
  - Do **not** call `cookies().get(...)` synchronously; that leads to the `"cookies() returns a Promise"` runtime error we hit repeatedly.

- **Always use the shared Supabase helpers**
  - Browser: `src/lib/supabase/client.ts` is the **only** place that calls `createClient` from `@supabase/supabase-js`.
  - Server/API: use the dedicated server helper (the same pattern we used for `/api/rules`) so auth context comes from request cookies.
  - This avoids:
    - Multiple GoTrueClient warnings.
    - Anonymous calls that silently bypass RLS and then fail with 401/403.

- **RLS changes must be tested end-to-end**
  - Any time we tighten a policy (`rules`, `entries`, `entry_rule_links`, `storage.objects`), immediately:
    - Hit the affected API route in dev tools.
    - Confirm the response is 200 with the expected JSON shape.
    - Confirm the UI handles “no data” cases without crashing.

- **Meta-process rule**
  - When something feels off (like repeating the same error pattern):
    - Stop changing code blindly.
    - Re-read logs and error messages.
    - Re-confirm the current schema and policies in Supabase before altering anything.
  - We specifically want to **avoid re-introducing**:
    - Old cookie patterns.
    - Duplicate Supabase client instances.
    - Wide-open “dev policies” left in place after hardening.

---

## ⚙️ Environment / Schema Notes
- Next.js 16 cookie adapter: continue using `NEXT_PUBLIC_REQUIRE_AUTH=1` to enforce login  
- Signed URLs must **never** be persisted to DB; always generated fresh  
- Bucket enforcement:
  - All objects must begin with `/userId/...` to satisfy RLS  
- New schema added:
  - `entries.parent_reflection` (text)  
- Storage RLS now includes UPDATE (required for upsert workflow)  
- All client components use shared Supabase client via `@/lib/supabase/client`  

---

## ❗ Known Issues / Carryovers
- `/today` page not yet implemented (currently 404)  
- Summary-generation auth error message still appears due to legacy mock-state check  
- ChatGPT UI red-bar glitches (not app-related) — known but cannot be fixed within the project  
- No multi-image support yet (planned for post-MVP v1.4)  
- No drag-and-drop or cropping system yet  

---

## 🎯 Next Session Objectives (Session 9)
1. **Implement `/today` entry creation flow**  
   - Create new entry for today  
   - Auto-detect cast  
   - Redirect to entry detail page  
2. **Add strict auth gating across all routes**  
   - Enforce login redirect on all pages  
   - Re-enable `NEXT_PUBLIC_REQUIRE_AUTH` consistently  
3. **Clean up summary-generation auth guard**  
   - Remove the legacy “mock/requireAuth disabled” error  
4. **Add loading states to image + reflection flows**  
5. **Prepare for Session 10: Share Flow + UX polish**  

---

## ▶️ Startup Instructions for Next Session

Copy/paste this into the first message of the new Session 9 chat:

You are the LegacyLoop development assistant, persona Laura L (Superhumans.life).
Last completed session: **8 — Image Upload UI + Parent Reflection Stub**.
Next session: **9 Session 9 – Today Page + Auth Gating Cleanup**.
Environment: Next.js 16 + Supabase (`ahjosjqabkjgxvcwpufl`), repo `C:/DEV/LegacyLoop_Project/legacyloop-app`.  
Active Rules:
Active PRD: v1.3 (Locked)
Use shared Supabase helpers ONLY
Alias rule: “@” maps to “./src”
Signed URL TTL ≤ 15 min; NEVER store signed URLs in DB
Never invent new tables or routes — check existing repo + Supabase first
One-step-at-a-time; wait for “done ✅”
Security > convenience
Please work in **tiny, sequential steps**, wait for my “done ✅” before continuing, and never invent new tables/clients when existing ones are available — always inspect the repo and current schema first.
Start with: Step 0 — Preflight Checklist (Environment, Repo, Supabase).
