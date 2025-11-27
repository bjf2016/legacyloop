# LegacyLoop — Continuation (v1.3)
**From:** Session 7 — Trash, Restore, RLS Hardening + Image Prep  
**To:**   Session 8 — Image Upload UI + Parent Reflection Stub  
**Date:** 2025-11-23  
**Owner:** Command Center – LegacyLoop  
**Persona:** Laura L (Superhumans.life)

---

## ✅ Completed in Session 7

- **Rules table RLS hardened**
  - Enabled RLS on `public.rules`.
  - Added owner-only policies:
    - `rules_select_own` → `SELECT` where `user_id = auth.uid()`.
    - `rules_cud_own`   → `ALL` (insert/update/delete) where `user_id = auth.uid()` with matching `WITH CHECK`.
  - Confirmed that existing seed rows for the current user still resolve cleanly via Supabase.

- **`/api/rules` route implemented & fixed**
  - Replaced the old anonymous Supabase client with an **authenticated server client** that uses `cookies()` from `next/headers` (Next 16 pattern).
  - New behavior:
    - Reads the current `auth.uid()` from the session.
    - If the user has **no rules yet**, inserts a default triad:
      - *Listen First* — Ask before advising.
      - *One Story per Entry* — Keep entries focused.
      - *Assume Positive Intent* — Lead with empathy.
    - Returns `[{ id, title, description }]` for that user only.
  - Fixed repeated 400/500 errors by:
    - Awaiting `cookies()` (Next 16 async API).
    - Ensuring we never call `cookieStore.get` on a Promise.
    - Avoiding JSON parsing on error bodies in the client.

- **RuleLinkPicker wired to live rules**
  - `RuleLinkPicker` now:
    - `GET /api/rules` on mount and renders rules as **toggleable chips**.
    - Shows a friendly empty state if the array is empty.
    - Posts selections to `/api/entries/[entryId]/rules` as `POST { ruleIds: [] }`.
  - On save, the UI shows `"Saved ✓ (N linked)"` and reports errors inline instead of crashing.

- **Supabase client usage cleaned up**
  - Consolidated the browser Supabase client into `src/lib/supabase/client.ts` to avoid repeated initialisation.
  - This removed the flood of “Multiple GoTrueClient instances detected in the same browser context” warnings.
  - New meta-rule: **never spin up ad-hoc Supabase clients in components**; always go through the shared helper.

- **Image support prep**
  - Created a dedicated storage bucket: `entry_images`.
  - Confirmed bucket exists under **Storage → Files → Buckets**.
  - Initial policies configured so only authenticated users can operate on this bucket (owner-scoped semantics to be refined in v1.4 when the UI ships).
  - This is **prep only**: no DB columns or UI yet; no signed-URL plumbing.

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

## 🎯 Next Session Objectives (Session 8 — Image Upload UI + Parent Reflection Stub)

Focus: start v1.4 features while keeping v1.3 stable.

1. **Image attachments — first slice**
   - Add a column to `entries` (e.g. `image_path text` or `images jsonb`) so an entry can reference one image.
   - Build a minimal image-upload component on the entry card:
     - Pick/take a photo (for now, standard file input is fine).
     - Upload to `entry_images/{user_id}/{entry_id}/...`.
     - Store the returned path in the DB.
   - Use the existing signed-URL helper pattern to render a thumbnail or small preview.

2. **Verify and refine storage RLS**
   - Finalize `storage.objects` policies for `entry_images` to ensure:
     - Only authenticated users can upload/select.
     - Users may only touch keys under their own prefix.
   - Re-test from the browser with a real upload.

3. **Parent reflection stub**
   - Design and add the **reflection/journaling component** for the parent after an entry:
     - Simple text area and save button,
     - Separate table or column (e.g. `entry_reflections`), depending on what feels cleanest.
   - No AI for reflections yet — just capture and store.

4. **Auth gating clean-up**
   - Re-enable strict auth (e.g. `NEXT_PUBLIC_REQUIRE_AUTH=1` if still off) and ensure:
     - Anonymous visitors are routed to the login/landing.
     - `/casts`, `/casts/[id]`, `/trash` all require auth.
   - Run a quick smoke test of login → cast list → entry → trash/restore → rules linking.

---

## ▶️ Startup Script for Session 8

When you open the **Session 8** chat in the Command Center, start with something like:

> You are the Command Center for the LegacyLoop project (v1.3 → v1.4), persona Laura L (Superhumans.life).  
> Last completed session: **7 — Trash, Restore, RLS Hardening + Image Prep**.  
> Next session: **8 — Image Upload UI + Parent Reflection Stub**.  
> Environment: Next.js 16 + Supabase (`ahjosjqabkjgxvcwpufl`), repo `C:/DEV/LegacyLoop_Project/legacyloop-app`.  
> RLS is enabled on all core tables; `rules` is now owner-only; `entry_images` bucket exists but the UI is not wired yet.  
> Our priorities now: (1) add per-entry image upload (UI + DB + RLS) using the `entry_images` bucket, (2) add the parent reflection/journaling stub after an entry, and (3) tighten auth gating across all pages.  
> Please work in **tiny, sequential steps**, wait for my “done ✅” before continuing, and never invent new tables/clients when existing ones are available — always inspect the repo and current schema first.
