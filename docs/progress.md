# Holysong Weekly V2 — Development Progress
(Last updated: 2026-01-08)

---

## 📊 Overall Progress Summary

| Layer | Status |
|------|--------|
| Model | ✅ 100% |
| Repository | ✅ 100% |
| Service | ✅ 85% |
| ViewModel | 🟡 40% |
| UI | 🟡 50% |
| Admin (HTML) | 🔴 30% |
| Docs / Architecture | 🟢 85% |

---

## ✅ Completed (Confirmed by Tests)

### 🧱 Model
- WeeklyWorship, Song
- copyWith, 유효성(서비스 단에서 검증)

### 🧱 Repository
- WeeklyWorshipRepository: fetch, watch, save, uploadScorePdf

### 🧱 Service

✔ Task 18 — load(date)  
✔ Task 19 — watch(date)  
✔ Task 20 — saveDraft(weekly)  
✔ Task 21 — publish(weekly)  
✔ Task 22 — updateAnnouncement  
✔ Task 23 — updateSong  
✔ Task 24 — updateAudio (테스트 그린)  
✔ **Task 25 — updateScore (실제 구현 추가, 테스트 그린)**

> flutter test — **All tests passed!** (2026-01-08)

---

## ⏳ In Progress
- ViewModel 테스트 설계/구현
- UI 연결

---

## ⛔ Not Started
- 실제 Firestore 연동 테스트
- Admin UI ↔ Service 연결

---

## 🎯 Next Milestone
1. ViewModel 테스트 추가
2. UI 연동
3. (선택) scores/audios 모델 반영 설계

---

## 🧾 History
- **2026-01-08**: Task 25 — updateScore 구현/테스트 완료. Service 80% → **85%**.  
- **2026-01-08**: Task 24 — updateAudio 테스트 완료. 전체 테스트 그린. GitHub 머지/푸시 완료(머지 커밋 b7050b9).
