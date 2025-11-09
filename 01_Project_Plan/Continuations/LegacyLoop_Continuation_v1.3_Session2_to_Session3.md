# LegacyLoop — Continuation (v1.3)

**From:** Session 2 – Supabase Auth + Schema + RLS
**To:** Session 3 – Supabase Storage + Audio Uploads
**Date:** 2025‑11‑09
**Owner:** Command Center – LegacyLoop
**Persona:** Laura L (Superhumans.life)

---

## 1) Session 2 Summary (Closed ✅)

**Status:** Complete — Auth, schema, and RLS in place. Frontend CRUD demo verified.

**Delivered**

* Auth (email/password) enabled, tested
* Tables: `profiles`, `casts`, `entries` (+ `legacyloop_visibility` enum)
* RLS policies + insert ownership triggers
* GoTrue JWT tests via PowerShell
* Frontend `/login`, `/debug/casts` demo with protected CRUD
* SprintTracker updated; commits pushed

**Security Matrix (snapshot)**

| Table      | Read                     | Write       |
| ---------- | ------------------------ | ----------- |
| `profiles` | owner only               | owner only  |
| `casts`    | owner or public          | owner only  |
| `entries`  | author/owner/public view | author only |

**Open Issues:** None carried.

---

## 2) Change Control

* No PRD scope change (v1.3 remains Locked). Storage is part of MVP voice flow.
* No changelog bump required.

---

## 3) Session 3 Objectives (Planned ▶️)

**Goal:** Enable secure audio uploads using Supabase Storage with per‑user folders; wire to entries.

1. **Create Storage bucket** `audio` (private).
2. **Folder convention:** `audio/{auth.uid()}/{castId}/{uuid}.webm`.
3. **RLS Policies on `storage.objects`** to limit CRUD to the owner’s folder.
4. **Client Upload Path:** use Supabase JS from authenticated client; no service role needed.
5. **API Endpoint (optional):** `/api/upload` wrapper for future server‑side transforms.
6. **DB:** extend `entries.audio_url` to store the storage path.
7. **UI:** simple React uploader (DropZone or `input[type=file]`) that writes the file, then inserts `entries` row.

**Acceptance Checks**

* [ ] Authenticated user can upload a small audio file; object appears under their `{uid}/...` path.
* [ ] Owner can list/get/delete their own audio; other users cannot access it directly.
* [ ] Creating an `entries` row saves `audio_url` referencing the storage path.
* [ ] Playback works by creating a **signed URL** on demand (expiry ≤15 min).

---

## 4) Preflight for Session 3 (Step 0)

* Confirm **Supabase URL/Anon** present in `.env.local` (already set in Session 2).
* Add `SUPABASE_STORAGE_BUCKET=audio` to `.env.local` (and Vercel envs after local test).
* Confirm active user session works (sign in before upload tests).

---

## 5) Bucket + Policy SQL (execute in Supabase SQL Editor)

```sql
-- 5.1 Create private bucket
select storage.create_bucket('audio', jsonb_build_object(
  'public', false,
  'fileSizeLimit', 52428800 -- 50MB ceiling for MVP
));

-- 5.2 Helper: first path segment equals auth.uid()
-- We enforce `{uid}/...` pathing for all objects in 'audio'.

-- 5.3 Policies on storage.objects
-- Allow owners to SELECT their own files
create policy "audio_owner_can_read" on storage.objects
for select to authenticated
using (
  bucket_id = 'audio'
  and split_part(name, '/', 1) = auth.uid()::text
);

-- Allow owners to INSERT into their own folder
create policy "audio_owner_can_insert" on storage.objects
for insert to authenticated
with check (
  bucket_id = 'audio'
  and split_part(name, '/', 1) = auth.uid()::text
);

-- Allow owners to UPDATE (e.g., metadata) in their own folder
create policy "audio_owner_can_update" on storage.objects
for update to authenticated
using (
  bucket_id = 'audio'
  and split_part(name, '/', 1) = auth.uid()::text
)
with check (
  bucket_id = 'audio'
  and split_part(name, '/', 1) = auth.uid()::text
);

-- Allow owners to DELETE their own files
create policy "audio_owner_can_delete" on storage.objects
for delete to authenticated
using (
  bucket_id = 'audio'
  and split_part(name, '/', 1) = auth.uid()::text
);
```

> Notes: `storage.objects` is always RLS‑protected. Using `split_part(name,'/',1)` keeps policies simple and performant for `{uid}/...` patterns.

---

## 6) Minimal Client Upload (reference snippet)

> Use inside an authenticated client component after user signs in. Path ensures policies pass.

```ts
// pseudo-code (to be adapted during the session)
import { createClient } from '@supabase/supabase-js'

const supabase = createClient(process.env.NEXT_PUBLIC_SUPABASE_URL!, process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!)

async function uploadAudio(file: File, castId: string) {
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) throw new Error('Not signed in')

  const path = `${user.id}/${castId}/${crypto.randomUUID()}.webm`
  const { error } = await supabase.storage.from('audio').upload(path, file, { cacheControl: '3600', upsert: false })
  if (error) throw error
  return path
}
```

---

## 7) Signed URL for Playback (server‑side)

```ts
// Next.js Route Handler (server) — /api/audio/sign
// returns a short‑lived signed URL to the client for playback
```

*(Implementation to be finalized in session; policy‑safe since user owns the path.)*

---

## 8) DB Patch (if `entries.audio_url` not present)

```sql
alter table public.entries add column if not exists audio_url text;
```

---

## 9) Session 3 Kickoff Message (paste into new chat)

```
# Session 3 – Supabase Storage + Audio Uploads (LegacyLoop)
Persona: Laura L (Superhumans.life)
Active PRD: v1.3 (Locked for Development)
Docs: PRD (READABLE + DEV), PRD_Changelog.md, SprintTracker.md, legacy_loop_rules_of_engagement_command_center_v_1.md
Rules: one step at a time; wait for “done ✅”; evidence on request.

Goals:
- Create private `audio` bucket
- Enforce per‑user folder policies `{uid}/...`
- Implement client upload + signed URL playback
- Save `audio_url` to `entries`

Please begin with Step 0: Preflight checklist.
```

---

## 10) Status Footer

**Progress:** 2/3 (Session 2 closed)
**Blockers:** —
**Next:** Open new chat and paste Session 3 Kickoff Message
**Owner:** Ben
