# PRD Changelog — LegacyLoop (FatherCast)

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
