# LegacyLoop — FatherCast  
**Product Requirements Document (PRD) · Version v1.3 — Locked for Development (November 2025)**  
Founder & Product Architect: **Ben Foroo**  
Persona & Project Partner: **Laura L (Superhumans.life)**  

> **Status:** Locked ✅ — Official baseline for MVP build start.  
> **Stack:** Next.js 14 · Supabase (single project) · OpenAI (Whisper + GPT-4o-mini) · Vercel · PWA (Service Worker + IndexedDB).  
> **Environment:** Local dev (VS Code + OpenAI Codex plugin) + Cloud dev (Vercel).  
> **Principle:** *AI as a mirror, not an editor.*

---

## 0. Executive Promise  
**One tap. One voice. One message a day your son will treasure forever.**

LegacyLoop is a web app that empowers fathers to record daily reflections—“FatherCasts”—in voice, video, or text format.  
AI transcribes and reflects on each message, surfacing the **Good, Bad, Ugly, and Lesson** while preserving the raw humanity of the father’s voice.  
Entries are privately stored, shareable through secure links, and designed to create an enduring legacy of wisdom and love.

---

## 1. Vision & Purpose  
- **Vision:** A modern “legacy journal” that strengthens emotional connection between fathers and their sons.  
- **Purpose:** Make it easy for fathers to express honestly, build consistency, and turn daily experiences into timeless wisdom.

---

## 2. Core Values  

| Core Value | Delivered Through |
|-------------|-------------------|
| Ease | Two-tap record; intuitive mobile-first design |
| Authenticity | AI reflection, not rewriting |
| Legacy | Encrypted storage; lock-until date; export to archive |
| Growth | AI prompts + Rules of Life for reflection and learning |
| Reliability | Offline-first caching and background sync |

---

## 3. Primary Users  

**Father:** Creates daily FatherCasts, adds “Rules of Life,” shares or time-locks entries.  
**Son:** Views unlocked entries and shared Rules; adopts favorite rules to build his own evolving Code of Life.

---

## 4. Daily Workflow (Father)  

1. Open app → see **Daily Prompt** (optional AI nudge: “What taught you something today?”)  
2. Choose input: 🎙️ Voice (default) / 🎥 Video / ✍️ Text  
3. Select duration: `[ 0:30 ] [ 1:00 ] [ 2:00 ]` — configurable in Settings  
4. Record → Stop → AI transcribes + summarizes (Good/Bad/Ugly/Lesson)  
5. Review or edit summary → Save → choose visibility:
   - Private (default)  
   - Share now  
   - Unlock later (by date or age)
6. Optionally link to **Rules of Life**  
7. Save → streak counter updates  
8. Share link with son (optional)

**Resilience:**  
- No mic? → Fallback to text.  
- No internet? → Offline save + auto-sync when back online.  
- Upload interruption? → Retry queue (3 attempts).  

---

## 5. Daily Workflow (Son)

- Receives private or unlockable FatherCasts (voice, video, or text).  
- Plays entries and reads summaries (Good/Bad/Ugly/Lesson).  
- Can **adopt Rules of Life** from his father to his own personal list.  
- Adds his reflections or new rules inspired by shared lessons.

---

## 6. AI Reflection Support  

AI serves as a gentle mirror.  
- **Pre-record prompts:** optional question (“What made you proud today?”).  
- **Post-record reflections:** one-line lesson from the day.  
- **Monthly coaching (Phase 1):** lightweight summary trends, not judgment.  

**Privacy:**  
- AI never edits voice or tone.  
- Data never used for training.  
- Everything stored encrypted; deletable anytime.

---

## 7. Key Features by Phase  

### MVP (v1.3 Locked Scope)  
✅ **Voice, Video, and Text Entries**  
✅ **Configurable Recording Duration (30s / 1m / 2m)**  
   - Default setting in profile  
   - Visual timer ring + gentle 10s warning tone  
   - Auto-stop and save at limit  
   - Snippets count toward streaks  
✅ **AI Transcription & Summaries**  
   - Whisper for transcription  
   - GPT-4o-mini for “Good / Bad / Ugly / Lesson” summary  
✅ **Rules of Life System**  
   - Create, edit, reorder, pin, archive, and link to entries  
   - Tag and search; count linked entries  
✅ **Rules Adoption for Son**  
   - Father shares; son adopts to “My Rules”  
   - Editable and re-orderable  
✅ **Offline Caching & Sync**  
   - IndexedDB storage on device (encrypted cache)  
   - Background sync for uploads on reconnect  
✅ **Sharing & Privacy**  
   - Private, Share-now, or Unlock-later visibility  
   - Expiring signed URLs  
✅ **Exports & Deletes**  
   - Full data export (JSON + ZIP)  
   - Hard delete available from Day 1  
✅ **UI/UX**  
   - Mobile-friendly PWA (installable)  
   - Clear permission prompts for mic/camera  

---

### Phase 1  
- Son replies (voice or text)  
- Duplicate rule detection  
- Reflection threads under rules  
- “Revisit Rule” nudges (spaced repetition)  
- AI Insights Dashboard  
- Keepsake PDF generation (Rules or annual summary)  
- Basic subscription options (Free / Pro)

### Phase 2  
- “Year-of-Dad” Book  
- Legacy Vault (time-locked archive)  
- Shared rules collaboration (Father + Son)  
- iOS/Android wrappers (offline sync)  
- Integrations: Calendar / Notion / Health  

---

## 8. Acceptance Criteria (MVP “Done-Done”)  

| Category | Criteria |
|-----------|-----------|
| Core Flow | Start recording ≤2 taps; save FatherCast ≤60s after Stop; share in ≤1 tap |
| AI & Content | 95% transcription success; summary includes G/B/U + Lesson; inline edit & regenerate works |
| Reliability | Offline drafts auto-saved; retry queue (3x); RLS enforced; URLs expire (15 min) |
| UX | Load time <3s (4G); clear mic/camera permissions |
| Rules | Father CRUD + pin/reorder; Son adopt/edit; Rule export; RLS enforced |
| Duration | Default & per-entry limits honored; timer auto-stops; short snippets valid |
| Security | Auth + JWT; encryption at rest; delete/export working |
| Privacy | “You own content”; no ads/resale/training |
| Offline | IndexedDB cache; background sync; conflict resolution (latest wins) |

---

## 9. Data Model (Key Tables)

**profiles**  
(id=auth_id, role ENUM(father|son), display_name, father_id, son_id, default_duration_seconds INT DEFAULT 60, created_at, updated_at)

**entries**  
(id, user_id, kind, transcript, summary, mood, tags[], visibility, unlock_at, duration_limit_seconds INT, created_at)

**rules_of_life**  
(id, user_id, title, description, pinned, archived, order, linked_entries[], created_at)

**rules_son / rules_shared / entry_rule_links**  
Support adoption and linkage logic with strict RLS.

---

## 10. Tech Stack & Architecture  

**Frontend:** Next.js 14 + React + Tailwind  
**Backend:** Supabase (Auth, DB, Storage)  
**AI:** OpenAI Whisper + GPT-4o-mini  
**AI Proxy:** Next.js `/api/ai/*` secure server routes  
**Deployment:** Vercel (Prod) + Supabase (US-West)  
**Dev Tools:** VS Code + OpenAI Codex plugin (local + cloud)  
**Offline:** Service Worker + IndexedDB + Background Sync  

---

## 11. Security & Privacy  

- Strict RLS (user_id ownership enforced)  
- Signed URLs (15-min expiry)  
- Encryption at rest (Supabase)  
- HTTPS only; HSTS  
- Plain-language policy shown in onboarding  

---

## 12. Defaults & Config  

| Parameter | Default | Editable? |
|------------|----------|-----------|
| Duration limit | 1 minute | Yes |
| Max upload retries | 3 | No |
| Unlock delay | 1 day | Yes |
| Model | GPT-4o-mini | Yes (Admin) |
| Cache retention | 7 days | Yes (PWA setting) |

---

## 13. Testing Plan  

- ✅ Manual QA for record → AI → save → share  
- ✅ Cross-browser mic/cam tests (Safari/Chrome)  
- ✅ Network drop simulation (offline caching)  
- ✅ RLS penetration check  
- ✅ End-to-end Vercel Preview smoke test  

---

## 14. Dev Timeline  

| Week | Milestone | Outcome |
|------|------------|----------|
| 1-2 | Setup + Schema + Auth | Working Supabase + RLS |
| 3-4 | Transcribe + Summarize | G/B/U/L pipeline functional |
| 5-6 | Rules + Offline | Full CRUD + local cache |
| 7-8 | Testing + Beta | Friends & family pilot |

---

**End of PRD v1.3 — Locked for Development**
