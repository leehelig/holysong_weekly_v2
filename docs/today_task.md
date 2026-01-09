# today_task.md — 오늘 작업 요약

## ✔ 오늘 완료한 작업

- WeeklyWorshipService.publish 구현
- Fake Repository 기반 단위 테스트 작성
- 검증(announcement ≤ 200, song.title 필수), 상태 전이(draft→published), updatedAt 갱신 확인
- repository.save 1회 호출 검증
- flutter test 통과 / git status clean / commit 완료
- updateAnnouncement 구현 + 테스트 통과

## 📌 오늘의 핵심 성과

- Service Layer의 퍼블리시 규칙을 테스트로 고정
- Repository 위임 구조와 단방향 원칙 재확인

## ▶ 다음 작업 계획
2. Task 23 — updateSong (TDD → 구현)
3. Task 24 — updateAudio (TDD → 구현)
4. Task 25 — updateScore (TDD → 구현)
5. Service → ViewModel 연동 테스트 설계
