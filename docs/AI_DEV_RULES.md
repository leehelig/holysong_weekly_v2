# AI Development Rules (Mandatory)

본 문서는 holysong_weekly_v2 프로젝트에서 모든 AI 도구(ChatGPT, Codex, Gemini 등)가
반드시 따라야 하는 최상위 규칙이다.

본 규칙을 위반한 AI 결과물은 즉시 폐기한다.

---

## 1. Scope Rule (작업 범위 규칙)

- AI는 **명시적으로 지정된 파일만 수정**할 수 있다.
- 지정되지 않은 파일 및 폴더는 **읽기 전용**이다.
- 기본 수정 금지 폴더:
  - /docs
  - /android
  - /ios
  - /web
- `/lib`, `/test` 하위에서도 **요청된 파일만 수정 가능**하다.

---

## 2. Architecture Preservation Rule

- 기존 아키텍처를 변경하지 않는다.
- 레이어 순서를 변경하지 않는다.

허용된 레이어 흐름:
