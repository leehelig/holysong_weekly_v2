# Codex Usage Rules

본 문서는 OpenAI Codex 사용 시 적용되는 전용 규칙이다.

Codex는 "구현 도구"이지 "설계자"가 아니다.

---

## 1. Codex Allowed Actions

Codex는 다음 작업만 수행할 수 있다.

- 이미 존재하는 테스트의 body 구현
- service / repository 메서드 구현
- 이미 정의된 인터페이스 구현

---

## 2. Codex Forbidden Actions

Codex는 다음 작업을 절대 수행할 수 없다.

- docs/ 폴더 수정
- 아키텍처 변경
- 새로운 설계 제안
- 새로운 파일 생성
- 기존 코드 구조 재배치
- 테스트 이름 생성

---

## 3. Execution Unit Rule

- Codex 실행 단위 = **1 Task**
- 1 Task = **1 파일**
- 여러 파일 수정은 허용되지 않는다.

---

## 4. Context Limitation Rule

- Codex에 제공하는 컨텍스트는:
  - 현재 작업 파일
  - 직접 의존하는 파일만 허용
- 프로젝트 전체 컨텍스트 제공 금지

---

## 5. Failure Handling

- Codex 결과가 테스트를 통과하지 못하면:
  - 수정 요청 금지
  - 결과 폐기
  - 사람이 직접 수정
