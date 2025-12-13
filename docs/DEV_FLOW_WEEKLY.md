# Weekly Worship Development Flow

본 문서는 holysong_weekly_v2 프로젝트의 표준 개발 절차를 정의한다.

AI 사용 여부와 관계없이 본 흐름을 따른다.

---

## 1. Standard Flow

1. 테스트 이름 작성
2. 테스트 body는 비워둔다
3. `flutter test` 실행 → 실패 확인
4. Codex 사용 (선택)
5. 구현 완료
6. `flutter test` 통과
7. 사람이 직접 커밋

---

## 2. AI Usage Timing

- Codex 사용 가능 시점:
  - 테스트 이름이 존재할 것
  - 실패 상태가 확인되었을 것

- Codex 사용 금지 시점:
  - 설계 단계
  - 구조 논의 단계
  - 파일 분할/통합 단계

---

## 3. Commit Policy

- 커밋 단위:
  - 하나의 테스트 그룹
  - 하나의 서비스 메서드

- 커밋 메시지 규칙:
