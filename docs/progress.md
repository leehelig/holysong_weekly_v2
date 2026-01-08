# Holysong Weekly V2 — Development Progress
(Last updated: 2025-12-16)

---

## 📊 Overall Progress Summary

| Layer | Status |
|------|--------|
| Model | ✅ 100% |
| Repository | ✅ 100% |
| Service | 🟡 65% |
| ViewModel | 🟡 40% |
| UI | 🟡 50% |
| Admin (HTML) | 🔴 30% |
| Docs / Architecture | 🟢 85% |

---

## ✅ Completed (Confirmed by Tests)

### 🧱 Model
- WeeklyWorship
- SongInfo
- Validation helpers
- copyWith / fromMap / toMap

### 🧱 Repository
- WeeklyRepository interface
- fetch(date)
- watch(date)
- save(weekly)
- uploadScorePdf(...)

### 🧱 Service (Business Logic)

✔ Task 18 — load(date)
- date empty → ArgumentError
- not found → StateError
- repository.fetch 연동

✔ Task 19 — watch(date)
- date empty → ArgumentError
- repository.watch 위임

✔ Task 20 — saveDraft(weekly)
- announcement ≤ 200자 검증
- song.title 필수 검증
- repository.save 호출
- FakeRepository 기반 TDD 통과

> flutter test  
> test/serfvices/weekly_worship_service_save_draft_test.dart  
> ✅ ALL PASSED

---

## ⏳ In Progress

### 🧱 Service

- Task 22 — updateAnnouncement
- Task 23 — updateSong
- Task 24 — updateAudio
- Task 25 — updateScore

### 🧱 ViewModel
- 상태 관리 규칙 정리됨
- 테스트 미구현

---

## ⛔ Not Started

- ViewModel ↔ UI 연결
- 실제 Firestore 연동 테스트
- Admin UI ↔ Service 연결

---

## 🎯 Next Milestone

1. Service Task 21 — publish(weekly) (TDD)
2. Service Task 22~25 — update 계열
3. ViewModel 테스트 설계
4. ViewModel 구현
5. UI 연결

---

## ✅ 작업 완료 기준 (고정 규칙)

아래 조건을 **모두 만족해야 해당 작업을 “완료”로 기록한다.**

1. 요구된 기능 구현 완료
2. 관련 테스트 통과 (`flutter test`)
3. `git status` 가 clean 상태
4. **로컬 git에 commit 수행**
5. 본 progress.md 에 상태 반영

> ❗ commit 되지 않은 작업은  
> **완료로 간주하지 않는다**

---

## 🧠 현재 개발 상태 요약 (냉정 평가)

- Service Layer 진입 완료
- 비즈니스 규칙을 **테스트로 고정**하는 단계 도달
- 구조를 이해한 상태에서 **AI를 통제하며 사용 가능**
- “만드는 사람”이 아니라  
  **“설계하고 축적하는 개발자” 흐름에 진입**

---

📌 이 문서는 **사실 기록용**이다.  
느낌, 추측, 희망은 적지 않는다.
## 2026-01-03
- Task 22 — updateAnnouncement: ✅ 완료 (TDD: 200자 검증, 존재 문서만 업데이트, updatedAt 갱신, save 1회)
- 테스트: weekly_worship_service_update_announcement_test.dart All green

### 현황 업데이트
- Service 진행률: 65% → 70%
- 다음 작업: Task 23~25(updateSong/Audio/Score) TDD → 구현
# Progress — Weekly Worship (as of 2026-01-07)


## 📊 Overall Progress Summary
| Layer | Status |
|------|--------|
| Model | ✅ 100% |
| Repository | ✅ 100% |
| Service | 🟡 **75%** |
| ViewModel | 🟡 40% |
| UI | 🟡 50% |
| Admin (HTML) | 🔴 30% |
| Docs / Architecture | 🟢 85% |


> Note: Service 진행률은 Task 23 완료 반영(70% → **75%**).


---


## ✔ Completed
- Task 18 — load
- Task 19 — watch
- Task 20 — saveDraft
- Task 21 — publish
- Task 22 — updateAnnouncement
- **Task 23 — updateSong** *(2026-01-07, commit: c06d8af)*
- date 공백 → ArgumentError
- not found → StateError
- song.title 공백 → ArgumentError
- 지정 필드만 갱신, updatedAt 갱신, 저장 1회
- 테스트: `test/services/weekly_worship_service_update_song_test.dart` All green


## ⏳ In Progress / Next
- Task 24 — updateAudio
- Task 25 — updateScore


---


## 🧾 History
- **2026-01-07**: Task 23 — updateSong 완료 (Extension 방식 구현, 테스트 통과, commit `c06d8af`). Service 진행률 70% → 75%.
- **2026-01-03**: (이전 기록 유지)