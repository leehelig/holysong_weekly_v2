# 20_task.md: WeeklyWorship 도메인 개발 상세 계획

이 문서는 `20_departments_weekly.md`를 기반으로 WeeklyWorship 도메인 개발을 위한 원자 단위의 상세 태스크 목록을 정의합니다. 각 태스크는 체크박스로 관리됩니다.

---

## 전반적인 구현 지침:
- **경로**: 기존 프로젝트 컨벤션(`lib/features/...`)을 유지하고, `lib/src/` 접두사는 사용하지 않습니다.
- **메서드명**: `freezed`와 `json_serializable`이 생성하는 `fromJson`/`toJson` 메서드를 `fromMap`/`toMap`과 동일한 목적으로 사용합니다.

---

## 1. Model Building 구현

### 1.1 `lib/features/weekly/models/weekly_worship.dart`
#### 부서: `WeeklyWorship`
- [x] `WeeklyWorship` 모델 클래스 정의 (`freezed` 활용)
- [x] 필드 정의: `date` (String), `announcement` (String), `song` (SongInfo), `audios` (Map<String, List<String>>), `scores` (Map<String, String?>), `status` (`WorshipStatus` enum)
- [x] `fromJson(Map<String, dynamic>)` 팩토리 생성자 구현 (자동 생성)
- [x] `toJson()` 메서드 구현 (자동 생성)
- [x] `copyWith({...})` 메서드 구현 (자동 생성)
- [ ] **Task 4 — `isCompleteForPublish()` 메서드 구현 (반환 타입: `bool`)**
    - [ ] `announcement` 필드가 비어 있지 않은지 검증 (`weekly.announcement.isNotEmpty`)
    - [ ] `song.title` 필드가 비어 있지 않은지 검증 (`weekly.song.title.isNotEmpty`)
    - [ ] `audios` 맵의 각 파트 리스트의 길이가 3 이하인지 검증 (`weekly.audios.values.every((urls) => urls.length <= 3)`)
    - [ ] 다음 7개 악보 파트의 키가 존재하고 (`scores.containsKey(part)`), 각 악보의 URL이 비어 있지 않은지 검증 (`scores[part] != null && scores[part]!.isNotEmpty`): `conductor`, `choir`, `horn`, `bassoon`, `clarinet`, `oboe`, `flute`
- [ ] **Task 5 — `updatedAt` 필드 추가:**
    - [ ] `DateTime? updatedAt` 필드를 `WeeklyWorship` 모델에 추가 (optional)
    - [ ] Firestore에서 `Timestamp`가 오면 `DateTime`으로 변환, `DateTime`을 Firestore로 보낼 때 `Timestamp`로 변환 로직은 Repository에서 처리

### 1.2 `lib/features/weekly/models/song_info.dart`
#### 부서: `SongInfo`
- [x] `SongInfo` 모델 클래스 정의 (`freezed` 활용)
- [x] 필드 정의: `title` (String), `composer?` (String?), `arranger?` (String?)
- [x] `fromJson(Map<String, dynamic>)` 팩토리 생성자 구현 (자동 생성)
- [x] `toJson()` 메서드 구현 (자동 생성)
- [x] `copyWith({...})` 메서드 구현 (자동 생성)
- [ ] `composer` 및 `arranger` 필드가 `null`이거나 비어 있는 경우 특별한 기본값은 없으며, `json_serializable`의 기본 `null` 처리 로직을 따름.

---

## 2. Repository Building 구현

### 2.1 `lib/features/weekly/repositories/weekly_worship_repository.dart`
#### 부서: `WeeklyWorshipRepository` (추상)
- [x] 추상 클래스 `WeeklyWorshipRepository` 정의
- [x] 추상 메서드 정의:
    - [x] `Future<WeeklyWorship?> fetch(String date)`
    - [x] `Stream<WeeklyWorship?> watch(String date)`
    - [x] `Future<void> save(WeeklyWorship weekly)`
    - [x] `Future<String> uploadScorePdf(String date, String instrument, dynamic file)`

### 2.2 `lib/features/weekly/repositories/weekly_worship_repository_impl.dart`
#### 부서: `WeeklyWorshipRepositoryImpl`
- [x] `WeeklyWorshipRepository` 추상 클래스를 구현하는 `WeeklyWorshipRepositoryImpl` 클래스 정의
- [x] Firebase Firestore 및 Storage 인스턴스 주입을 위한 생성자 구현
- [x] **Task 13 — `_doc(String date)` 내부 헬퍼 메서드 구현:**
    - [x] Firestore `collection('weekly')`에서 `doc(date)` 참조자 생성
- [x] **Task 14 — `fetch(date)` 구현:**
    - [x] Firestore 문서 읽기
    - [x] `fromMap` (`fromJson`) 호출
- [x] **Task 15 — `watch(date)` 구현:**
    - [x] `snapshots()` 스트림 → `fromMap` (`fromJson`) 변환
- [x] **Task 16 — `save(weekly)` 구현:**
    - [x] `toMap()` (`toJson`) 결과 `set()`
    - [ ] `updatedAt` 필드가 있을 경우 `FieldValue.serverTimestamp()`를 사용하여 Firestore에 저장 (필요 시)
- [x] **Task 17 — `uploadScorePdf(date, instrument, file)` 구현:**
    - [x] `_validateScorePart(instrument)` 호출
    - [x] Storage 경로: `scores/YYYY-MM-DD/instrument_name.pdf`
        - [ ] `instrument` 이름에 특수 문자가 포함될 경우를 대비하여 파일명으로 사용 전에 소문자 변환 및 특수 문자(공백 포함)를 밑줄('_')로 치환하는 sanitize 로직 구현 (가정: `part`는 안전하다고 가정)
    - [x] 파일 업로드 후 downloadURL 반환
- [x] **Task 18 — `_validateScorePart(part)` 내부 헬퍼 메서드 구현:**
    - [x] `part` 이름이 다음 고정된 악보 파트 목록 중 하나인지 검사: `[conductor, choir, horn, bassoon, clarinet, oboe, flute]` (이 목록은 `WeeklyValidators`에서 가져와서 사용)
    - [x] 아니면 `InvalidScorePartException` throw

---

## 3. Service Building 구현

### 3.1 `lib/features/weekly/services/weekly_worship_service.dart`
#### 부서: `WeeklyWorshipService`
- [x] `WeeklyWorshipService` 클래스 정의
- [x] `WeeklyWorshipRepository` 의존성 주입을 위한 생성자 구현
- [x] `maxAudioUrls` (3) 상수를 서비스 내부에 정의
- [x] **Task 19 — `fetchWeeklyWorship(String date)` 메서드 구현:**
    - [x] `repository.fetch` 호출 및 결과 반환
- [x] **Task 20 — `watchWeeklyWorship(String date)` 메서드 구현:**
    - [x] `repository.watch` 위임
- [ ] **Task 21 — `updateAnnouncement(WeeklyWorship weekly, String text)` 구현:**
    - [ ] `text.trim()` 처리
    - [ ] `weekly.copyWith(announcement: trimmedText)` 반환 (새로운 `WeeklyWorship` 객체 반환)
    - [ ] (선택 사항) `announcement` 길이 (예: 200자) 검증은 `WeeklyValidators.validateDraft`에서 주로 처리하므로 이 단계에서는 필수는 아님.
- [ ] **Task 22 — `updateSong(WeeklyWorship weekly, SongInfo songInfo)` 구현:**
    - [ ] `weekly.copyWith(song: songInfo)` 반환
- [ ] **Task 23 — `updateAudio(WeeklyWorship weekly, String part, List<String> urls)` 구현:**
    - [ ] `WeeklyValidators.validateAudioCount(urls, maxAudioUrls)` 호출 (또는 `urls.length > maxAudioUrls` 직접 검증)
    - [ ] 초과 시 `AudioLimitExceededException` throw
    - [ ] `Map<String, List<String>> newAudios = Map.from(weekly.audios); newAudios[part] = urls;` 후 `weekly.copyWith(audios: newAudios)` 반환
- [ ] **Task 24 — `updateScore(WeeklyWorship weekly, String part, String? url)` 구현:**
    - [ ] `WeeklyValidators.validateScorePart(part)` 호출 (Repository의 `_validateScorePart`와 동일)
    - [ ] `InvalidScorePartException` throw
    - [ ] `Map<String, String?> newScores = Map.from(weekly.scores); newScores[part] = url;` 후 `weekly.copyWith(scores: newScores)` 반환
- [x] **Task 25 — `saveDraft(WeeklyWorship weekly)` 구현:**
    - [x] `WeeklyValidators.validateDraft(weekly)` 호출 및 반환된 에러 메시지가 있다면 `Exception` throw
    - [x] `weekly.copyWith(status: WorshipStatus.draft)`를 사용하여 `repository.save` 호출
    - [ ] `updatedAt` 필드가 있을 경우 갱신 로직 추가
- [x] **Task 26 — `publish(WeeklyWorship weekly)` 구현:**
    - [x] `WeeklyValidators.validateForPublish(weekly)` 호출 및 반환된 에러 메시지가 있다면 `PublishGateException` throw
    - [x] `weekly.copyWith(status: WorshipStatus.published)`를 사용하여 `repository.save` 호출
- [x] **Task 27 — `uploadScorePdf(date, part, file)` 구현:**
    - [x] `repository.uploadScorePdf` 호출 및 URL 반환

---

## 4. ViewModel Building 구현

### 4.1 `lib/features/weekly/viewmodels/weekly_worship_view_model.dart`
#### 부서: `WeeklyWorshipViewModel`
- [x] `ChangeNotifier`를 상속받는 `WeeklyWorshipViewModel` 클래스 정의
- [x] `WeeklyWorshipService` 의존성 주입을 위한 생성자 구현
- [x] UI 상태 프로퍼티 정의 (`get` 접근자 포함):
    - [x] `WeeklyWorship? currentWeeklyWorship` (getter/setter)
    - [x] `String? selectedDate`
    - [x] `bool isLoading`
    - [x] `bool isSaving`
    - [x] `String? errorMessage`
    - [ ] `double pdfUploadProgress` (구현 필요: Repository/Service에서 progress를 ViewModel로 전달하는 메커니즘 고려)
    - [ ] `double audioUploadProgress` (구현 필요: 위와 동일)
- [x] `_weeklyWorshipStream` private 필드 및 구독/해제 로직 구현

#### 초기화/날짜 이동 직원
- [x] **Task 28 — `load(String date)` 메서드 구현:**
    - [x] `isLoading` 상태 `true`로 설정 후 `notifyListeners()` 호출
    - [x] `service.fetchWeeklyWorship` 호출
    - [x] 결과로 `currentWeeklyWorship` 업데이트
    - [x] `isLoading` 상태 `false`로 설정 후 `notifyListeners()` 호출
    - [x] 오류 발생 시 `errorMessage` 설정
- [x] **Task 29 — `subscribe(String date)` 메서드 구현:**
    - [x] `isLoading` 상태 `true`로 설정 후 `notifyListeners()` 호출
    - [x] 기존 스트림 구독 해제 (null 체크 후 `cancel()`)
    - [x] `service.watch(date)` 구독 시작
    - [x] 스트림 이벤트 발생 시 `currentWeeklyWorship` 업데이트, `isLoading` `false`, `errorMessage` `null` 설정 후 `notifyListeners()` 호출
    - [x] 스트림 오류 발생 시 `errorMessage` 설정, `isLoading` `false` 설정 후 `notifyListeners()` 호출
- [x] `selectDate(String date)` (Task 28의 `load(date)`를 대체하거나 호출)
    - [x] `selectedDate` 업데이트 및 `notifyListeners()` 호출
    - [x] `subscribe(date)` 호출하여 데이터 구독 시작

#### 필드 업데이트 직원
- [ ] **Task 30 — `setAnnouncement(String text)` 구현:**
    - [ ] `service.updateAnnouncement` 호출 (반환된 새 WeeklyWorship 객체로 `currentWeeklyWorship` 업데이트)
    - [ ] `notifyListeners()`
- [ ] **Task 31 — `setSong(SongInfo info)` 구현:**
    - [ ] `service.updateSong` 호출 (반환된 새 WeeklyWorship 객체로 `currentWeeklyWorship` 업데이트)
    - [ ] `notifyListeners()`
- [ ] **Task 32 — `addAudioUrl(String part, String url)` 구현:**
    - [ ] `currentWeeklyWorship`의 해당 파트 `urls` 리스트에 `url` 추가
    - [ ] `service.updateAudio` 호출 (반환된 새 WeeklyWorship 객체로 `currentWeeklyWorship` 업데이트)
    - [ ] `notifyListeners()`
    - [ ] 길이 ≤3 검증은 Service에서 예외를 던지면 ViewModel에서 `errorMessage` 설정
- [ ] **Task 33 — `removeAudioUrl(String part, int index)` 구현:**
    - [ ] `currentWeeklyWorship`의 해당 파트 `urls` 리스트에서 `index` 위치의 `url` 제거
    - [ ] `service.updateAudio` 호출 (반환된 새 WeeklyWorship 객체로 `currentWeeklyWorship` 업데이트)
    - [ ] `notifyListeners()`
- [ ] **Task 34 — `setAudio(String part, List<String> urls)` 구현:**
    - [ ] `service.updateAudio` 호출 (반환된 새 WeeklyWorship 객체로 `currentWeeklyWorship` 업데이트)
    - [ ] `notifyListeners()`
    - [ ] 길이 ≤3 검증은 Service에서 예외를 던지면 ViewModel에서 `errorMessage` 설정
- [ ] **Task 35 — `setScore(String part, String? url)` 구현:**
    - [ ] `WeeklyValidators.validateScorePart(part)`를 사용하여 `part` 키 1차 검증 (유효하지 않으면 `InvalidScorePartException` throw)
    - [ ] `service.updateScore` 호출 (반환된 새 WeeklyWorship 객체로 `currentWeeklyWorship` 업데이트)
    - [ ] `notifyListeners()`
- [ ] **Task 39 — `resetFields()` 메서드 구현:**
    - [ ] `WeeklyWorship.empty(selectedDate)` 팩토리 생성자를 통해 `currentWeeklyWorship`을 새로운 draft로 초기화
    - [ ] `errorMessage`도 `null`로 초기화
    - [ ] `notifyListeners()`

#### 저장/출판 직원
- [x] **Task 36 — `saveDraft()` 구현:**
    - [x] `isSaving` 상태 `true`로 설정 후 `notifyListeners()` 호출
    - [x] `service.saveDraft(currentWeeklyWorship!)` 호출
    - [x] `isSaving` 상태 `false`로 설정 후 `notifyListeners()` 호출
    - [x] 오류 발생 시 `errorMessage` 설정
- [x] **Task 37 — `publish()` 구현:**
    - [x] `isSaving` 상태 `true`로 설정 후 `notifyListeners()` 호출
    - [x] `service.publishWeeklyWorship(currentWeeklyWorship!)` 호출
    - [x] `isSaving` 상태 `false`로 설정 후 `notifyListeners()` 호출
    - [x] 오류 발생 시 `errorMessage` 설정

#### 오류 관리 직원
- [x] **Task 38 — `clearError()` 메서드 구현:**
    - [x] `errorMessage = null`로 설정 후 `notifyListeners()` 호출

#### 주차 이동 직원
- [ ] **Task 40 — `goToPreviousWeek()` 메서드 구현:**
    - [ ] `selectedDate` (String)를 `DateTime`으로 변환 후 7일 빼기
    - [ ] 결과 `DateTime`을 다시 String으로 포맷 후 `selectDate()` 호출
- [ ] **Task 41 — `goToNextWeek()` 메서드 구현:**
    - [ ] `selectedDate` (String)를 `DateTime`으로 변환 후 7일 더하기
    - [ ] 결과 `DateTime`을 다시 String으로 포맷 후 `selectDate()` 호출

---

## 5. UI Building 구현

### 5.1 `lib/features/weekly/presentation/screens/weekly_screen.dart`
#### 부서: `WeeklyScreen` (User)
- [x] `WeeklyWorshipViewModel`을 `Consumer` 위젯 또는 `Provider.of`를 사용하여 상태 구독
- [x] `TableCalendar` 위젯을 사용하여 날짜 선택 UI 구현
    - [x] 날짜 선택 시 `ViewModel.selectDate()` 호출
- [x] `LayoutBuilder`를 활용하여 반응형 레이아웃 구현 (모바일 1열, 태블릿 2열, 데스크톱 3열)
- [x] `ViewModel` 데이터에 기반하여 다음 섹션들을 렌더링하도록 구현 (`features/weekly/presentation/components`의 위젯 사용):
    - [x] `_buildAnnouncementSection()`
    - [x] `_buildSongSection()`
    - [x] `_buildAudiosSection()`
    - [x] `_buildScoresSection()`
- [x] PDF URL 클릭 시 `url_launcher`를 통해 새 탭에서 PDF 오픈 (`_openPdf(url)` 헬퍼 활용)
- [x] 로딩(`isLoading`) 및 오류(`errorMessage`) 상태에 따른 UI 피드백 표시
- [ ] **Task 47 — 섹션별 접기/펼치기 기능 구현:**
    - [ ] 각 섹션 (공지, 곡, 음원, 악보)에 확장 가능한 위젯 (e.g., `ExpansionTile`) 적용

### 5.2 `lib/features/weekly/presentation/screens/weekly_admin_screen.dart`
#### 부서: `WeeklyAdminScreen` (Admin)
- [x] `WeeklyWorshipViewModel`을 `Consumer` 위젯 또는 `Provider.of`를 사용하여 상태 구독
- [x] **Task 48 — 날짜 선택 UI 구현:**
    - [x]
    - (Admin 화면 진입 시 URL 파라미터로 날짜를 받으므로, 초기 로드 시 `viewModel.selectDate` 호출로 대체)
- [x] **Task 49 — 공지 입력(UI → ViewModel) 구현:**
    - [x] `TextFormField`를 사용하여 `announcement` 입력 및 `viewModel.setAnnouncement` 호출
- [x] **Task 50 — 곡 정보 입력(UI → ViewModel) 구현:**
    - [x] `TextFormFields`를 사용하여 `song.title`, `song.composer`, `song.arranger` 입력 및 `viewModel.setSong` 호출
- [x] **Task 51 — Audio URL 추가/삭제 구현:**
    - [x] `ManageAudioList` 컴포넌트 사용 및 `viewModel.addAudioUrl`/`removeAudioUrl` 호출
- [x] **Task 52 — PDF 업로드 → Service.uploadScorePdf → setScore 구현:**
    - [x] `PdfUploadButton` 컴포넌트 사용 및 `viewModel.uploadScorePdf` 호출
- [x] **Task 53 — Draft 저장 버튼 구현:**
    - [x] 버튼 클릭 시 `viewModel.saveDraft()` 호출, `isSaving` 상태 피드백 표시
- [x] **Task 54 — Publish 버튼 구현:**
    - [x] "정말로 공개하시겠습니까?" 확인 팝업 (`_showPublishDialog` 활용)
    - [x] `viewModel.publish()` 호출, `isSaving` 상태 피드백 표시
- [ ] **Task 55 — Reset 버튼 구현:**
    - [ ] 버튼 클릭 시 `viewModel.resetFields()` 호출
- [ ] **Task 56 — 실시간 미리보기(UI = data 상태 반영) 구현:**
    - [ ] 편집기 필드 변경 사항을 반영하는 별도의 미리보기 섹션 (간소화된 `WeeklyScreen` 구성 요소) 구현
- [x] 로딩(`isLoading`), 저장(`isSaving`), 오류(`errorMessage`) 상태에 따른 UI 피드백 표시

### 5.3 `lib/features/weekly/presentation/components/audio_item.dart`
#### 부서: `AudioItem` (Component)
- [ ] **Task 57 — `AudioItem` 위젯 정의:**
    - [ ] URL 표시
    - [ ] 삭제 버튼 (`onRemove(index)` 콜백)
    - [ ] 클릭 시 재생 버튼 (`onTap(url)` 콜백)

### 5.4 `lib/features/weekly/presentation/components/score_item.dart`
#### 부서: `ScoreItem` (Component)
- [ ] **Task 58 — `ScoreItem` 위젯 정의:**
    - [ ] PDF 다운로드 버튼 렌더링
    - [ ] `onOpen(url)` 콜백 함수 정의 및 UI 연결 (새 탭으로 열기)

### 5.5 `lib/features/weekly/presentation/components/weekly_summary_card.dart`
#### 부서: `WeeklySummaryCard` (Component)
- [ ] **Task 59 — `WeeklySummaryCard` 위젯 정의:**
    - [ ] 공지 요약 (`announcement`의 첫 N 글자)
    - [ ] 곡 제목 표시
    - [ ] 날짜 표시

---

## 6. 예외 부서(Exception Building) 구현

- [ ] **Task 60 — `lib/features/core/exceptions/publish_gate_exception.dart`:**
    - [ ] `PublishGateException` 클래스 정의 (`Exception` 상속)
- [ ] **Task 61 — `lib/features/core/exceptions/audio_limit_exceeded_exception.dart`:**
    - [ ] `AudioLimitExceededException` 클래스 정의 (`Exception` 상속)
- [ ] **Task 62 — `lib/features/core/exceptions/invalid_score_part_exception.dart`:**
    - [ ] `InvalidScorePartException` 클래스 정의 (`Exception` 상속)
- [ ] **T
- ask 63 — `lib/features/core/exceptions/invalid_url_exception.dart`:**
    - [ ] `InvalidUrlException` 클래스 정의 (`Exception` 상속)

---

## 7. Validators Tasks 구현

### 7.1 `lib/features/weekly/validators/weekly_validators.dart`
#### 부서: `WeeklyValidators`
- [x] `WeeklyValidators` 클래스 정의
- [x] **Task 64 — `validateDraft(WeeklyWorship weekly)` 구현:**
    - [x] `announcement` 길이 ≤200 검증
    - [x] 각 `audio` 파트의 길이 ≤3 검증
    - [x] `scores` 맵에 7개 키가 존재하는지 검증 (필수 파트 목록은 `WeeklyValidators` 내부 상수 활용)
    - [x] 검증 실패 시 에러 메시지(String?) 반환
- [x] **Task 65 — `validateForPublish(WeeklyWorship weekly)` 구현:**
    - [x] `announcement` 비어 있지 않은지 검증
    - [x] `song.title` 비어 있지 않은지 검증
    - [x] `audios` 맵의 각 파트 길이 ≤3 검증
    - [x] `scores` 맵의 7개 파트 모두 URL이 존재하는지 검증 (필수 파트 목록은 `WeeklyValidators` 내부 상수 활용)
    - [x] 검증 실패 시 에러 메시지(String?) 반환

---

## 8. End-to-End Tasks (수동 테스트 항목)

- [ ] **Task 66 — Admin 전체 흐름 점검:**
    - [ ] load → edit → saveDraft → publish
    - [ ] published 이후 사용자 화면 즉시 반영 확인
- [ ] **Task 67 — Storage 업로드 + URL 반영 통합 테스트:**
    - [ ] PDF 업로드 기능 및 URL이 모델에 정확히 반영되는지 테스트
- [ ] **Task 68 — Firestore 문서 구조 자동 생성 테스트:**
    - [ ] 새 날짜로 저장 시 Firestore 문서 구조가 예상대로 생성되는지 확인
- [ ] **Task 69 — 반응형 UI 테스트:**
    - [ ] 모바일, 태블릿, 데스크톱 환경에서 UI 레이아웃이 올바르게 작동하는지 확인
