# LegacyLoop_PRD_v1.3_DEV — Developer Edition  
**Version v1.3 — Locked for Development (November 2025)**  

## 0. Environment
Node 22 LTS  
Next.js 14 (App Router, TS)  
Supabase (US-West, single project)  
OpenAI Whisper + GPT-4o-mini  
Vercel deploy; local via VS Code + Codex plugin  
PWA (SW + IndexedDB + BG Sync)

`.env.local`
```
NEXT_PUBLIC_SUPABASE_URL=https://YOUR.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=...
OPENAI_API_KEY=sk-...
BRAND_NAME=LegacyLoop
FEATURE_NAME=FatherCast
```

---

## 1. Schema Migrations
`0001_init.sql` → core tables (profiles, entries, media_files, ai_suggestions, prompts, streaks, insights, events)  
`0002_rules_of_life.sql` → rules_of_life, entry_rule_links  
`0003_rules_shared.sql` → rules_shared  
`0004_rules_son.sql` → rules_son  
`0005_duration_controls.sql` →  
```sql
alter table public.profiles add column if not exists default_duration_seconds int default 60;
alter table public.entries  add column if not exists duration_limit_seconds int;
```

Apply:
```bash
supabase db push
```

---

## 2. Key Routes
| Route | Purpose |
|--------|----------|
| `/today` | Main record page; duration pill [0:30/1:00/2:00]; record/write → summary → save → link rules → share |
| `/entry/[id]` | Playback + summary + linked rules |
| `/rules` | Father’s rules CRUD (list/drag/edit/pin/archive/share) |
| `/my-rules` | Son’s adopted rules |
| `/share/[token]` | Public son view (unlocked entries only) |

---

## 3. Components
- `RecordControls`: duration selector, timer ring, countdown tone  
- `MediaRecorderPanel`: audio/video capture, mic/camera permission help  
- `SummaryEditor`: inline edit of G/B/U/Lesson  
- `RuleList`, `RuleEditor`, `RuleLinkPicker`: full CRUD  
- `EntryCard`: playback, summary, linked rules  
- `SharePanel`: visibility, unlock date, revoke  

---

## 4. APIs
| Endpoint | Description |
|-----------|--------------|
| `/api/ai/transcribe` | Whisper proxy (audio→text) |
| `/api/ai/summary` | GPT summary (G/B/U + Lesson) |
| `/api/rules/export` | JSON export |

- Use `zod` for validation  
- Require auth middleware  
- Log to Supabase `events` (usage, latency, error)  
- Retry with exponential backoff  

---

## 5. Offline Support
- Service Worker: caches assets + IndexedDB data store  
- IndexedDB stores drafts, transcripts, media chunks, rules cache  
- Background Sync: re-uploads queued entries when online  
- Conflict resolution: latest-timestamp-wins  
- Local encryption for cached data  
- Works both on desktop and mobile browsers  

---

## 6. Acceptance Checklist (MVP)
- [ ] Duration default + override; timer auto-stop; snippets count for streaks  
- [ ] 95% transcription success (Whisper)  
- [ ] Summary block generation (G/B/U + Lesson)  
- [ ] Offline draft + retry verified  
- [ ] RLS policies enforced on all tables  
- [ ] Rules CRUD + Son adopt/edit functional  
- [ ] Export/Delete endpoints operational  
- [ ] TTI <3s (4G test)  
- [ ] All env vars configured in Vercel  

---

## 7. Security & Compliance
- JWT-based Auth; Supabase RLS  
- Signed URLs (15-min expiry)  
- HTTPS only  
- PII isolation; encrypted storage  
- Plain-language privacy: “You own your data.”  

---

## 8. Git & Deployment
Local Git init:
```bash
git init
git add .
git commit -m "chore: seed LegacyLoop project (v1.3 locked)"
git branch -M main
git remote add origin https://github.com/<user>/legacyloop.git
git push -u origin main
```
Vercel:
- Import repo `legacyloop-app`
- Add env vars (Supabase keys, OpenAI)
- Deploy

Supabase:
```bash
supabase link
supabase db push
```

---

## 9. Notes for Future Phases
- Phase 1: Reflection threads, insights, duplicates detection  
- Phase 2: Legacy Vault, book exports, mobile wrappers  

---

**End of DEV v1.3**
