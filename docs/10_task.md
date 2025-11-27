# BethelChoir 개발 Task 목록

## 1단계: 프로젝트 구조 리팩토링
- [x] `10_buildings.md`에 명시된 새로운 디렉토리 구조를 생성합니다.
- [x] 기존 UI 파일들을 새로운 `features/weekly/ui/` 경로로 이동시킵니다.

## 2단계: 모델 계층 구현
- [x] `freezed`와 `json_serializable` 관련 의존성을 `pubspec.yaml`에 추가합니다.
- [x] `SongInfo` 모델 클래스를 생성합니다. (`features/weekly/models/song_info.dart`)
- [x] `WorshipStatus` enum (`draft`, `published`)을 생성합니다.
- [x] `WorshipStatus`를 사용하는 `WeeklyWorship` 모델 클래스를 생성합니다. (`features/weekly/models/weekly_worship.dart`)
- [x] `build_runner`를 실행하여 모델 파일들을 생성합니다.

## 3단계: 데이터 및 서비스 계층 구현
- [x] `WeeklyWorshipRepository` 추상 클래스를 생성합니다. (`features/weekly/repositories/weekly_worship_repository.dart`)
- [x] `firebase_storage` 의존성을 추가합니다.
- [x] `WeeklyWorshipRepositoryImpl` 클래스를 구현하여 Firestore 및 Storage와의 연동을 처리합니다.
- [x] `WeeklyWorshipService` 클래스를 구현합니다.
    - [x] 음원 URL은 파트별로 3개까지 제한하는 비즈니스 로직을 포함합니다.
    - [x] 게시(Publish) 시, '찬양대' 악보가 필수로 포함되었는지 검증하는 로직을 포함합니다. (수정 완료)

## 4단계: ViewModel 구현
- [x] `WeeklyWorshipViewModel` 클래스를 `ChangeNotifier`를 상속받아 구현합니다. (`features/weekly/viewmodels/weekly_worship_view_model.dart`)

## 5단계: UI 계층 리팩토링 및 구현
- [x] 사용자 화면(`weekly_screen.dart`)을 ViewModel과 연동하여 리팩토링합니다.
- [x] 공지, 찬양곡, 음원, 악보 섹션을 각각 별도의 위젯 파일로 분리합니다. (`features/weekly/ui/components/`)
- [x] 관리자 화면(`edit_weekly_screen.dart`)을 ViewModel과 연동하여 리팩토링합니다.
- [x] 음원 URL을 관리하는 `ManageAudioList` 위젯을 구현합니다.
- [x] PDF 악보를 업로드하는 `PdfUploadButton` 위젯을 구현합니다.

## 6단계: 핵심 기능 구현
- [x] `go_router` 의존성을 추가하고, `AppRouter`를 구현하여 화면 라우팅을 설정합니다. (`core/routing/app_router.dart`)
- [x] `AppTheme` 클래스를 생성하여 앱의 전체적인 테마(라이트/다크, 폰트 등)를 정의합니다. (`core/theme/app_theme.dart`)
- [x] `main.dart` 파일을 업데이트하여 새로운 아키텍처(Provider, Router, Theme)를 적용하고 앱을 부트스트랩합니다.

## 7단계: 유효성 검사 및 최종화
- [x] `WeeklyValidators` 클래스를 구현하여 URL 형식, 게시 조건 등의 유효성 검사 로직을 통합합니다. (`features/weekly/validators/weekly_validators.dart`) (수정 완료)
- [x] 개발용 Firestore 연결 상태를 확인하는 `HealthCheck` 유틸리티를 구현합니다. (`core/health/health_check.dart`)
- [x] `dart fix --apply` 및 `dart format .` 명령을 실행하여 코드 포맷팅 및 정리를 수행합니다. (실행 및 분석 완료)
- [ ] 최종적으로 모든 기능이 의도대로 동작하는지 검토합니다. (수동 검증 필요)