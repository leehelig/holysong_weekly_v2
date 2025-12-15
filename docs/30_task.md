# 30_task.md — Weekly Worship Function-level Tasks (Updated Progress)

## 1. Model Layer Tasks (WeeklyWorship, SongInfo)

### 📌 WeeklyWorship
- [x] **Task 1 — fromMap(map) 구현**
- [x] **Task 2 — toMap() 구현**
- [x] **Task 3 — copyWith() 구현**
- [x] **Task 4 — updatedAt 필드 반영**

### 📌 SongInfo
- [x] **Task 5 — fromMap()**
- [x] **Task 6 — toMap()**
- [x] **Task 7 — copyWith()**

---

## 2. Repository Layer Tasks (Port + Implementation)

### 📌 Abstract Repository
- [x] **Task 8 — fetch(date)**
- [x] **Task 9 — watch(date)**
- [x] **Task 10 — save(weekly)**
- [x] **Task 11 — uploadScorePdf()**

### 📌 Implementation
- [x] **Task 12 — _doc(date)**
- [x] **Task 13 — fetch(date)**
- [x] **Task 14 — watch(date)**
- [x] **Task 15 — save(weekly)**
- [x] **Task 16 — uploadScorePdf(date, part, file)**
- [x] **Task 17 — _validateScorePart(part)**

---

## 3. Service Layer Tasks (비즈니스 규칙)

### 📌 WeeklyWorshipService
- [x] **Task 18 — load(date)**  
- [x] **Task 19 — watch(date)**  
- [ ] **Task 20 — saveDraft(weekly)**  
- [ ] **Task 21 — publish(weekly)**  
- [ ] **Task 22 — updateAnnouncement(value)**  
- [ ] **Task 23 — updateSong(songInfo)**  
- [ ] **Task 24 — updateAudio(part, urls)**  
- [ ] **Task 25 — updateScore(part, url)**  

---

## 4. ViewModel Layer Tasks

### 📌 WeeklyWorshipViewModel
- [ ] **Task 26 — load(date)**
- [ ] **Task 27 — subscribe(date)**
- [ ] **Task 28 — saveDraft()**
- [ ] **Task 29 — publish()**
- [ ] **Task 30 — setAnnouncement()**
- [ ] **Task 31 — setSong()**
- [ ] **Task 32 — setAudio()**
- [ ] **Task 33 — setScore()**

---

## 5. Validator Layer Tasks
- [ ] **Task 34 — isValidUrl(url)**
- [ ] **Task 35 — validateAudioCount(list)**
- [ ] **Task 36 — validateScoreKeys(scores)**
- [ ] **Task 37 — canPublish(weekly)**

---

## 6. Exceptions Tasks
- [ ] **Task 38 — PublishGateException**
- [ ] **Task 39 — AudioLimitExceededException**
- [ ] **Task 40 — InvalidScorePartException**
- [ ] **Task 41 — InvalidUrlException**

---

## 7. End-to-End Scenario Tasks
- [ ] **Task 42 — User Flow: load → render → subscribe**
- [ ] **Task 43 — Admin: edit → saveDraft → publish**
- [ ] **Task 44 — Storage 업로드 + URL 반영**
- [ ] **Task 45 — Firestore 문서 자동 생성 테스트**
- [ ] **Task 46 — 반응형 UI와 데이터 변경 즉시 반영 확인**
