
# AGENTS.md
# Codex / AI Mandatory Rules for holysong_weekly_v2

This file defines mandatory rules for all AI agents (including Codex).
AI must read and follow this file before performing any action.

Violation of these rules invalidates the output.

---

## 1. Project Context

- Project: holysong_weekly_v2
- Stack: Flutter (Dart), Firebase (Firestore, Storage)
- Architecture: Clean Architecture (test → service → repository → firebase)

AI is an implementation assistant, NOT a designer.

---

## 2. Allowed Modification Scope

AI may modify ONLY the files explicitly requested by the user.

Default rules:
- Read-only by default for the entire repository
- Write access is granted per-task, per-file only

### Forbidden directories (always read-only):
- /docs
- /android
- /ios
- /web

---

## 3. One-Task / One-File Rule

- One task = one file
- AI must never modify multiple files in a single task
- AI must confirm the target file BEFORE writing any code

Example confirmation:
> "I will modify only: test/features/weekly/weekly_worship_service_test.dart"

---

## 4. Test-First (Hard Requirement)

- Tests must exist before implementation
- AI must NOT create test names
- AI may implement test bodies ONLY when test names already exist
- Red (failing) test must be confirmed before implementation
- Green (passing) test is the only completion criterion

---

## 5. Codex-Specific Restrictions

Codex is allowed to:
- Implement test bodies
- Implement service or repository methods
- Implement code strictly required to satisfy existing tests

Codex is NOT allowed to:
- Change architecture
- Propose refactors
- Create or delete files
- Modify documentation
- Read unrelated files "for context"

---

## 6. Context Limitation

AI must limit its context to:
- The explicitly targeted file
- Directly dependent interfaces or models only

Full-project scans are forbidden.

---

## 7. Git & Workflow Rules

- AI must never commit, push, or merge
- AI may suggest commit messages only
- All commits are performed by the human developer

---




## 8. Authority

- This file (AGENTS.md) has highest priority
- Detailed rules are documented in:
  - docs/AI_DEV_RULES.md
  - docs/CODEX_USAGE_RULES.md
  - docs/DEV_FLOW_WEEKLY.md

If conflicts exist, AGENTS.md overrides all other instructions.
