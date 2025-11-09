# LegacyLoop — Continuation (v1.3)

**From:** Session 1 – Environment & Git Setup
**To:** Session 2 – Supabase Auth + Schema + RLS
**Date:** 2025‑11‑09
**Owner:** Command Center – LegacyLoop
**Persona:** Laura L (Superhumans.life)

---

## 1) Session 1 Summary (Closed ✅)

**Status:** Complete — All baselines met; PRD v1.3 LOCK maintained.

| Area                                    | Status                                |
| --------------------------------------- | ------------------------------------- |
| VS Code + Codex                         | Verified                              |
| GitHub Repos                            | `legacyloop`, `legacyloop-app` pushed |
| Next.js 14 (TS + Tailwind + App Router) | Running locally                       |
| Supabase (US‑West)                      | Provisioned                           |
| `.env.local`                            | Configured                            |
| Vercel Deploy                           | Live + `/api/health` OK ✅             |
| `.env.example` + `.gitignore`           | Added                                 |
| `SprintTracker.md`                      | Seeded                                |

**Evidence Links (fill if applicable):**

* GitHub repo(s): {{link}}
* Vercel dashboard: {{link}}
* Supabase project: {{link}}

**Decisions / Notes:**

* Baseline stack confirmed (Next.js 14, Supabase US‑West, OpenAI Whisper + GPT‑4o‑mini, Vercel, PWA).
* ROE v1.0 integrated; ROE Check Block to precede session replies.

**Open Issues:**

* None recorded for Session 1.

---

## 2) Change Control

* `PRD_Changelog.md` updated to **v1.3.1 — ROE Integration Update** (Admin only; no scope change).
* No changes to acceptance criteria.

---

## 3) Session 2 Objectives (Planned ▶️)

**Goal:** Implement authentication and core data schema with secure access.

1. **Auth**: Enable email login/signup (Supabase Auth) with minimal UI flows.
2. **Schema**: Create tables: `profiles`, `casts`, `entries` (FatherCast model).
3. **RLS**: Write Row‑Level Security policies for all three tables.
4. **API Smoke Tests**: Protected CRUD route checks from Next.js → Supabase.

**Acceptance Checks:**

* [ ] New user can sign up, verify, and sign in.
* [ ] `profiles` row auto‑provisions on first sign‑in.
* [ ] User can create/read/update/delete own `casts` and `entries`; cannot access others’ rows.
* [ ] Postman/Thunder or in‑app fetch proves 403 on cross‑tenant access.

---

## 4) Preflight for Session 2 (Step 0)

* Confirm **Supabase project URL** present in `.env.local` as `NEXT_PUBLIC_SUPABASE_URL`.
* Confirm **Supabase anon key** present as `NEXT_PUBLIC_SUPABASE_ANON_KEY` (do not paste key in chat).
* Confirm **Service role key** stored **outside** client bundle (Vercel env or server‑only) as `SUPABASE_SERVICE_ROLE_KEY`.
* Confirm **Auth email templates** placeholders are acceptable (default OK for MVP).
* Confirm **Local dev** ready (Next.js dev server runs without errors).

---

## 5) Reference Schema (Draft)

> For execution in Session 2 — paste via SQL Editor or migration tool.

```sql
-- profiles
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  avatar_url text,
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now()
);

-- casts (a “show” or channel)
create table if not exists public.casts (
  id uuid primary key default gen_random_uuid(),
  owner uuid not null references auth.users(id) on delete cascade,
  title text not null,
  description text,
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now()
);

-- entries (individual audio/text reflections)
create table if not exists public.entries (
  id uuid primary key default gen_random_uuid(),
  cast_id uuid not null references public.casts(id) on delete cascade,
  owner uuid not null references auth.users(id) on delete cascade,
  content text,
  audio_url text,
  transcript text,
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now()
);

-- RLS enablement
alter table public.profiles enable row level security;
alter table public.casts enable row level security;
alter table public.entries enable row level security;

-- RLS policies
create policy "Profiles are self‑readable" on public.profiles
for select using (auth.uid() = id);

create policy "Profiles are self‑updatable" on public.profiles
for update using (auth.uid() = id);

create policy "Insert profile at signup" on public.profiles
for insert with check (auth.uid() = id);

create policy "Casts: owner can CRUD" on public.casts
for all using (owner = auth.uid()) with check (owner = auth.uid());

create policy "Entries: owner can CRUD" on public.entries
for all using (owner = auth.uid()) with check (owner = auth.uid());
```

> Note: Use **Edge Functions** or **Triggers** to auto‑seed `profiles` on first sign‑in if desired; otherwise handle in app after `onAuthStateChange`.

---

## 6) Session 2 Kickoff Message (paste into new chat)

```
# Session 2 – Supabase Auth + Schema + RLS (LegacyLoop)
Persona: Laura L (Superhumans.life)
Active PRD: v1.3 (Locked for Development)
Docs: PRD (READABLE + DEV), PRD_Changelog.md, SprintTracker.md, legacy_loop_rules_of_engagement_command_center_v_1.md
Rules: one step at a time; wait for “done ✅”; evidence on request.

Goals:
- Enable email auth
- Create `profiles`, `casts`, `entries` tables
- Implement RLS and smoke‑test protected CRUD

Please begin with Step 0: Preflight checklist.
```

---

## 7) Status Footer

**Progress:** 1/3 (Session 1 closed)
**Blockers:** —
**Next:** Open new chat and paste Session 2 Kickoff Message
**Owner:** Ben
