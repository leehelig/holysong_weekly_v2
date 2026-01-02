# 30_task.md — Current Execution Tasks
(Updated: 2025-12-16)

---

## 🎯 Current Focus
Service Layer 안정화 (TDD 기반)

---

## ✅ Done

### Task 18 — load(date)
- [x] date empty → ArgumentError
- [x] not found → StateError
- [x] repository.fetch
- [x] 테스트 통과

### Task 19 — watch(date)
- [x] date empty → ArgumentError
- [x] repository.watch 위임
- [x] Stream 정상 동작
- [x] 테스트 통과

### Task 20 — saveDraft(weekly)
- [x] announcement 200자 초과 → throw
- [x] song.title 비어있음 → throw
- [x] repository.save 1회 호출
- [x] FakeRepository + flutter_test 통과

---

## ⏳ Next Tasks

### ✅ Task 21 — publish(weekly)
- [x] publish 가능 조건 검증
- [x] status = published
- [x] updatedAt 갱신
- [x] repository.save 호출
- [x] 테스트 작성 및 통과

### ⬜ Task 22 — updateAnnouncement
### ⬜ Task 23 — updateSong
### ⬜ Task 24 — updateAudio
### ⬜ Task 25 — updateScore

---

📌 원칙
- 테스트 → 서비스 구현 순서
- 범위 밖 수정 금지
- 통과한 테스트만 “완료”로 기록
