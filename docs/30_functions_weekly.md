# 30_functions_weekly.md
Bethel Weekly Worship — Function-level Specification (TDD Ready)

본 문서는 모든 “직원(함수)”의 **입력 / 출력 / 책임 / 예외조건 / TDD 시나리오(Given-When-Then)** 를 정의한다.  
Gemini CLI는 이 문서를 기반으로 함수/테스트 코드를 자동 생성한다.

---

# 1. Model Functions

## 1.1 WeeklyWorship.fromMap(map)
### 책임
- Firestore 문서를 모델로 변환

### 입력
- Map<String, dynamic>

### 출력
- WeeklyWorship 인스턴스

### 예외 조건
- 필수 필드(date, announcement, song.title)가 없으면 throw

### TDD
GIVEN Firestore 문서 map
WHEN fromMap 호출
THEN WeeklyWorship 인스턴스 생성되고 모든 필드가 매칭됨

yaml
코드 복사

---

## 1.2 WeeklyWorship.toMap()
### 책임
- 모델을 Firestore 문서 형태로 변환

### 출력
- Map<String, dynamic>

### TDD
GIVEN WeeklyWorship 객체
WHEN toMap 호출
THEN Firestore 규격대로 Map이 생성됨 (필드 누락/과잉 없음)

yaml
코드 복사

---

## 1.3 WeeklyWorship.copyWith()
### 책임
- Draft/Publish 과정에서 안전한 필드 업데이트

### TDD
GIVEN WeeklyWorship 객체
WHEN copyWith 특정 필드값 변경
THEN 나머지는 동일하고 원하는 필드만 변경된 새 객체 생성

yaml
코드 복사

---

# 2. Repository (Port) Functions

## 2.1 fetch(date)
### 책임
- Firestore에서 해당 날짜 문서 1개 읽기

### 입력
- date(String, yyyy-mm-dd)

### 출력
- WeeklyWorship? (없으면 null)

### TDD
GIVEN weekly/2025-11-23 문서가 존재함
WHEN fetch("2025-11-23")
THEN WeeklyWorship 인스턴스 리턴

GIVEN 문서 없음
WHEN fetch("2025-01-01")
THEN null 리턴

yaml
코드 복사

---

## 2.2 watch(date)
### 책임
- 문서 스트림 실시간 구독

### 출력
- Stream<WeeklyWorship?>

### TDD
GIVEN 문서가 초기값 A
WHEN watch() 구독 시작
THEN 첫 이벤트로 A 수신

WHEN 문서를 B로 수정
THEN 다음 이벤트로 B 수신

yaml
코드 복사

---

## 2.3 save(weekly)
### 책임
- WeeklyWorship 문서를 Firestore에 저장

### 입력


### TDD
GIVEN WeeklyWorship w
WHEN save(w)
THEN Firestore에 동일한 필드로 저장됨

yaml
코드 복사

---

## 2.4 uploadScorePdf(date, instrument, file)
### 책임
- Storage에 PDF 업로드 → URL 발급

### TDD
GIVEN PDF 파일
WHEN uploadScorePdf("2025-11-23", "flute")
THEN scores/2025-11-23/flute.pdf 위치에 업로드되고 URL 반환

yaml
코드 복사

---

# 3. Service Functions (비즈니스 규칙)

## 3.1 load(date)
### 책임
- Repository.fetch 호출 → WeeklyWorship 로딩

### 예외
- date 형식 오류 시 throw

### TDD
GIVEN 존재하는 날짜
WHEN load
THEN WeeklyWorship 리턴

yaml
코드 복사

---

## 3.2 watch(date)
### 책임
- Repository.watch 단순 위임

---

## 3.3 saveDraft(weekly)
### 책임
- 상태를 draft로 저장
- 간단 유효성 검사만 통과하면 저장

### 유효성 규칙
- announcement 길이 ≤ 200
- song.title 필수

### TDD
GIVEN WeeklyWorship w
WHEN saveDraft(w)
THEN status=draft 로 저장됨

yaml
코드 복사

---

## 3.4 publish(weekly)
### 책임
- **Publish 게이트** 검증 수행
- 검증 통과 시 Firestore에 status=published로 저장

### Publish Gate 규칙
- announcement 비어있지 않아야 한다
- song.title 존재해야 한다
- audios 각 파트 ≤ 3개
- scores 모든 파트가 Valid URL 또는 null

### 실패 시
- throw PublishGateException

### TDD
GIVEN 모든 항목이 유효
WHEN publish
THEN status=published 저장

GIVEN song.title 없음
WHEN publish
THEN PublishGateException 발생

yaml
코드 복사

---

## 3.5 updateAnnouncement(value)
### TDD
GIVEN 기존 WeeklyWorship
WHEN updateAnnouncement("새 공지")
THEN announcement 필드만 변경됨

yaml
코드 복사

---

## 3.6 updateSong(songInfo)
### TDD
GIVEN 기존 WeeklyWorship
WHEN updateSong(newSong)
THEN song 필드가 newSong으로 변경됨

yaml
코드 복사

---

## 3.7 updateAudio(part, urls)
### 규칙
- 최대 3개

### TDD
GIVEN urls 4개
WHEN updateAudio
THEN AudioLimitExceededException 발생

yaml
코드 복사

---

## 3.8 updateScore(part, url)
### TDD
GIVEN flute.pdf URL
WHEN updateScore("flute", url)
THEN scores["flute"]=url 반영

yaml
코드 복사

---

# 4. ViewModel Functions (상태 + orchestration)

## 4.1 load(date)
### 책임
- 로딩 상태 true
- Service.load 호출
- 결과 data에 반영

### TDD
WHEN load("2025-11-23")
THEN isLoading=true → false
AND data != null

yaml
코드 복사

---

## 4.2 subscribe(date)
### 책임
- watch 스트림 구독
- 데이터 변화 발생 시 data 업데이트

### TDD
GIVEN watch 스트림에서 A → B 이벤트 발생
WHEN subscribe
THEN ViewModel.data가 A → B로 갱신됨

yaml
코드 복사

---

## 4.3 saveDraft()
### 책임
- isSaving true → false
- Service.saveDraft 호출

---

## 4.4 publish()
### 책임
- Service.publish 호출
- 검증 실패 시 error 상태 반영

### TDD
GIVEN 곡 제목 없음
WHEN publish
THEN error="PublishGateException"

yaml
코드 복사

---

## 4.5 setAnnouncement / setSong / setAudio / setScore
### 책임
- data.copyWith() 사용해서 부분 업데이트
- UI 반영을 위해 notifyListeners()

---

# 5. Validator Functions

## 5.1 isValidUrl(url)
### TDD
GIVEN "http://test.com/file.pdf"
WHEN isValidUrl
THEN true

GIVEN "abc"
WHEN isValidUrl
THEN false

yaml
코드 복사

---

## 5.2 validateAudioCount(list)
GIVEN list length <= 3 → true
GIVEN list length > 3 → false

yaml
코드 복사

---

## 5.3 validateScoreKeys(scores)
GIVEN scores has 7 fixed keys
WHEN validateScoreKeys
THEN true

GIVEN missing key
WHEN validateScoreKeys
THEN false

yaml
코드 복사

---

## 5.4 canPublish(weekly)
### 규칙
- 공지 비어있지 않음
- 곡 제목 존재
- 음원 ≤ 3
- 악보 키 7개 유지

GIVEN 모든 조건 ok → true
GIVEN 하나라도 실패 → false

yaml
코드 복사

---

# 6. 직원 간 협업 시나리오 (End-to-End)

User selects date → ViewModel.load(date)
→ Service.load(date)
→ Repository.fetch
→ Firestore doc → model 변환 → UI 렌더

Admin edits → setAnnouncement/setSong...
→ saveDraft() → Service.saveDraft → Repository.save

Admin clicks Publish → publish()
→ Service.publish (검증)
→ Repository.save (status=published)
→ User 화면에서 즉시 반영(watch)

yaml
코드 복사

---

# 7. 예외 타입 정의

- `PublishGateException`
- `AudioLimitExceededException`
- `InvalidUrlException`
- `InvalidScorePartException`