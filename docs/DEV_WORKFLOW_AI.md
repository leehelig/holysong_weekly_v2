# DEV_WORKFLOW_AI (ChatGPT + Codex)

## 목적
이 프로젝트는 TDD 기반으로 안전하게 개발한다.
Codex(자동 구현)는 생산성을 높이되, 코드 오염/구조 붕괴를 방지하기 위해 사용 범위를 엄격히 제한한다.

---

## 1. AI 도구 역할 분담
### ChatGPT (일반모드)
- 설계/규칙 정리
- 테스트 시나리오 작성
- 코드 리뷰 및 수정 지시
- “작업 범위”와 “완료 조건”을 문서화

### Codex
- 정해진 파일/경로에서만 구현 수행
- 테스트 body 채우기, 작은 함수/메서드 구현
- 리팩토링이나 구조 변경은 금지

---

## 2. Codex 사용 허용 범위 (Hard Rules)
### 2.1 수정 허용 경로
Codex가 읽고/수정할 수 있는 경로는 아래로 제한한다.

- lib/features/weekly/**
- test/features/weekly/**
- test/fakes/** (필요 시)

### 2.2 수정 금지 경로
Codex는 아래 파일/폴더를 수정하거나 참조하지 않는다.

- docs/**
- *.md (README 포함)
- android/**, ios/**, web/**
- build/**, .dart_tool/**, .idea/**, .vscode/**
- pubspec.yaml, analysis_options.yaml (명시적 승인 없이는 금지)

---

## 3. Codex 작업 단위 규칙
- 한 번의 작업에서 수정 파일은 **최대 2개**
- 한 번의 작업에서 구현 범위는 **단일 기능/단일 메서드**
- “이름 변경 / 폴더 이동 / 아키텍처 변경”은 금지

---

## 4. 작업 절차 (반드시 순서대로)
1) ChatGPT가 작업 범위/테스트 시나리오를 확정한다.
2) Codex는 `/plan`으로 계획을 먼저 제출한다.
3) 사람이 plan을 검토한다 (수정 파일/범위가 규칙을 위반하면 중단).
4) 승인 후에만 `/implement` 실행한다.
5) 구현 후 변경(diff)을 사람이 확인하고, 로컬에서 `flutter test`로 검증한다.
6) 테스트 통과 후에만 merge/commit 한다.

---

## 5. TDD 규칙
- 테스트 먼저(RED) → 구현(GREEN)
- 기존 테스트가 깨지면 즉시 복구가 우선
- 리팩토링은 “기능 구현”과 분리된 별도 작업으로 수행

---

## 6. Codex 프롬프트 기본 문구 (매번 사용)
아래 문구를 Codex 요청에 항상 포함한다.

> Allowed files: lib/features/weekly/** and test/features/weekly/** only.  
> Modify at most 2 files.  
> No renames, no moving files, no refactoring outside scope.  
> Implement only what the tests require.  
> If you need to touch any other file, stop and ask.

---

## 7. 완료 조건
- `flutter test test/features/weekly/weekly_worship_service_test.dart` 통과
- 변경 파일 수/경로 규칙 준수
- 불필요한 파일 수정 없음
