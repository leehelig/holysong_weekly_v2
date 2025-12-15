//# 아직 구현 안 된 함수/클래스 목록

# 50_todo_log.md
Bethel Weekly Worship — TODO / Issues / Risks Log  
(항목은 주기적으로 업데이트하며, 완료 시 체크)

---

# 1. High Priority (즉시 해야 할 작업)

## [ ] Repository 구현
- [ ] WeeklyWorshipRepositoryImpl.fetch()
- [ ] WeeklyWorshipRepositoryImpl.watch()
- [ ] WeeklyWorshipRepositoryImpl.save()
- [ ] WeeklyWorshipRepositoryImpl.uploadScorePdf()

## [ ] Service 규칙 구현
- [ ] saveDraft()
- [ ] publish() — Publish Gate
- [ ] updateAnnouncement()
- [ ] updateSong()
- [ ] updateAudio()
- [ ] updateScore()

## [ ] ViewModel 구현
- [ ] load()
- [ ] subscribe()
- [ ] setAnnouncement()
- [ ] setSong()
- [ ] setAudio()
- [ ] setScore()
- [ ] saveDraft()
- [ ] publish()

## [ ] UI — User(사용자)
- [ ] 날짜 선택 UI
- [ ] 공지 Section 렌더링
- [ ] 곡 정보 Section 렌더링
- [ ] 음원 Section 렌더링
- [ ] 악보 Section 렌더링 (PDF 새 탭)

## [ ] UI — Admin(관리자)
- [ ] edit_weekly_screen(전체 편집 화면)
- [ ] manage_audio_list (URL 추가/삭제, 최대3)
- [ ] pdf_upload_button (upload → URL 반영)
- [ ] Draft 저장/Publish 버튼
- [ ] Validation 오류 메시지 표시

---

# 2. Medium Priority (다음 단계)

## [ ] 반응형 레이아웃 적용
- [ ] 모바일(1열)
- [ ] 태블릿(2열)
- [ ] 데스크톱(3열)

## [ ] Validator 구현
- [ ] isValidUrl()
- [ ] validateAudioCount()
- [ ] validateScoreKeys()
- [ ] canPublish()

## [ ] 관리자 UX 개선
- [ ] 자동 저장(Draft Auto-save)
- [ ] 최근 주차 자동 로드
- [ ] 날짜 이동 단축 버튼 (이전주/다음주)

---

# 3. Low Priority / 미래 확장

## [ ] Admin Auth (Google Login)
## [ ] 최근 Publish 리스트 조회(주차 목록)
## [ ] 멀티 캠퍼스 확장
## [ ] 파일 버전 관리(최신본만 유지 → 버전 옵션 추가)
## [ ] Admin Dashboard 생성
## [ ] Logging / Analytics 적용

---

# 4. 버그/리스크 추적

## 리스크
- [ ] Firebase Storage 업로드 실패 시 Firestore 반영 불가 문제
- [ ] 모바일 환경에서 PDF 새 탭이 차단될 가능성 (iOS Safari)
- [ ] Admin이 URL 잘못 입력 시 UI 깨짐 가능성
- [ ] 네트워크 불안정 시 watch() 구독 이벤트 누락 가능성

## 버그(현재 없음)
- 최초 버그 보고 시 이 섹션에 기록

---

# 5. 완료된 항목 (Done Log)
- [x] Firebase Web 앱 생성
- [x] flutterfire configure → firebase_options.dart 생성
- [x] firebase_init.dart 생성
- [x] Firebase 연결 정합성 확인 완료(health ping)

---

# 6. 규칙
- 새로운 기능 요구 발생 시 반드시 TODO에 추가
- 완료된 항목은 Done Log로 이동
- 실제 구현한 코드와 TODO 간 **불일치가 없도록 항상 최신 유지**  
