# ⚠️ CLI 금지 명령
Do NOT run or modify any of the following commands:
flutter pub get
dart run build_runner build
dart analyze
dart format
flutter run / build
flutterfire configure
firebase login
git add/commit/push
[Environment
]::SetEnvironmentVariable()

These must be executed manually by developer in PowerShell.
Gemini CLI may only modify source code files as described in this task list.


# docs/22_task.md — 최소 필수 안정화 태스크
(Optimized for Gemini CLI — Core Only / Safe Mode)

이 문서는 `20_task.md`와 `21_task.md`를 기준으로,
**앱 동작에 직접 필수적인 미완료 작업만** 추려 실행하기 위한 체크리스트입니다.
UI 편의, 테스트, 부가 위젯 등은 제외했습니다.

---

## 🚫 공통 규칙 (반드시 준수)
1) 이미 완료된 코드/파일은 절대 수정 금지
2) 파일 전체 재생성·대규모 리팩터링 금지
3) 클래스/필드/파일 이름 변경 금지
4) 존재 함수는 내용만 채우기(시그니처 불가변), 신규 함수만 최소 추가
5) Task는 **한 번에 하나씩** 처리하고, 매 Task 후 빌드·런 확인
6) `WeeklyValidators` 수정 금지

---

## ✔ 1. Model/Repository Layer — 필수
### WeeklyWorshipRepositoryImpl
- [x] **M3** — `save()` 시 `updatedAt = FieldValue.serverTimestamp()` 저장
    - 조건: 모델에 `updatedAt`가 존재할 경우에만 적용
    - 구현 포인트: `toJson()` 결과에 `updatedAt` 키를 `FieldValue.serverTimestamp()`로 병합(set with merge)
- [x] **M4** — 악보 파일 업로드 시 part 이름 sanitize (lowercase + space → `_`)

> 참고: `21_task.md` 기준으로 **M4(악보 파트 sanitize)** 는 이미 완료됨.

---

## ✔ 2. Service Layer — 필수
### WeeklyWorshipService
- [x] **S1** — `updateAnnouncement(WeeklyWorship weekly, String text)`
    - `trim` 적용 후 `weekly.copyWith(announcement: trimmed)` 반환
- [x] **S2** — `updateSong(WeeklyWorship weekly, SongInfo songInfo)`
    - `weekly.copyWith(song: songInfo)` 반환
- [x] **S3** — `updateAudio(WeeklyWorship weekly, String part, List<String> urls)`
    - `WeeklyValidators.validateAudioCount(urls, 3)` 또는 길이 직접 검사
    - 초과 시 `AudioLimitExceededException` throw
    - `newAudios = Map.from(weekly.audios); newAudios[part] = urls;` 후 copyWith
- [x] **S4** — `updateScore(WeeklyWorship weekly, String part, String? url)`
    - `WeeklyValidators.validateScorePart(part)` 호출(유효하지 않으면 `InvalidScorePartException`)
    - `newScores = Map.from(weekly.scores); newScores[part] = url;` 후 copyWith
- [x] **S5** — `saveDraft(WeeklyWorship weekly)`에서 `updatedAt` 갱신
    - 저장 직전 `weekly = weekly.copyWith(status: WorshipStatus.draft, updatedAt: DateTime.now())`
    - 이후 `repository.save(weekly)`

---

## ✔ 3. ViewModel Layer — 필수
### WeeklyWorshipViewModel
> 진행 중 로직과 UI 버튼이 실제로 동작하려면 아래 바인딩이 필요합니다.  
> (진행률 프로퍼티 V1/V2, 주차 이동 V10/V11은 **핵심 경로와 무관**하여 제외)

- [x] **V3** — `setAnnouncement(String text)`
    - `service.updateAnnouncement`로 새 모델 수신 → `currentWeeklyWorship` 반영 → `notifyListeners()`
- [x] **V4** — `setSong(SongInfo info)`
    - `service.updateSong` 결과 반영 → `notifyListeners()`
- [x] **V5** — `addAudioUrl(String part, String url)`
    - 현 모델의 `audios[part]`에 url 추가 후 `service.updateAudio` → 결과 반영 → `notifyListeners()`
    - 길이 초과 예외 발생 시 `errorMessage` 설정
- [x] **V6** — `removeAudioUrl(String part, int index)`
    - 인덱스 제거 후 `service.updateAudio` → 결과 반영 → `notifyListeners()`
- [x] **V7** — `setAudio(String part, List<String> urls)`
    - `service.updateAudio` → 결과 반영 → `notifyListeners()`
- [x] **V8** — `setScore(String part, String? url)`
    - `WeeklyValidators.validateScorePart(part)` 선검증
    - `service.updateScore` → 결과 반영 → `notifyListeners()`
- [x] **V9** — `resetFields()`
    -co `WeeklyWorship.empty(selectedDate)`로 초기화, `errorMessage = null`, `notifyListeners()`
- [ ] **V10** — `goToPreviousWeek()`
    - `selectedDate` (String)를 `DateTime`으로 변환 후 7일 빼기
    - 결과 `DateTime`을 다시 String으로 포맷 후 `selectDate()` 호출
- [ ] **V11** — `goToNextWeek()`
    - `selectedDate` (String)를 `DateTime`으로 변환 후 7일 더하기
    - 결과 `DateTime`을 다시 String으로 포맷 후 `selectDate()` 호출

---

## ✔ 4. Exceptions — 최소 정의(컴파일/런타임 경로용)
- [x] **E1** — `PublishGateException` (`Exception` 상속)
- [x] **E2** — `AudioLimitExceededException` (`Exception` 상속)
- [x] **E3** — `InvalidScorePartException` (`Exception` 상속)

> `E4: InvalidUrlException` 은 현재 필수 경로에서 직접 사용 증거 없음 → 보류

---

## 🧪 수행·검증 절차(간단)
1) **M3 → S1~
2) S5 → V3~V9 → E1~E3** 순으로 하나씩 적용
2) 각 단계 후 **빌드 & Admin 화면 수동 확인**
    - 공지/곡/음원/악보 수정 → Draft 저장 → Publish까지 흐름 점검
3) Firestore: `weekly/{date}` 문서에 `updatedAt` 생성/갱신 확인
4) 음원 리스트 길이 3 초과 시 예외/UI 에러메시지 노출 확인

---

## ✅ 완료 기대 상태
- Firestore 저장 시 `updatedAt` 자동 반영
- Admin에서 공지/곡/음원/악보 편집 → Draft 저장 → Publish 정상 동작
- 파트 검증·개수 제한 등 기본 비즈 룰 준수
- UI 부가 기능/테스트 미구현이어도 **앱 핵심 플로우 정상**

---