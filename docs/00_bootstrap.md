# 00_bootstrap.md  
# Holysong Weekly V2 — 프로젝트 초기 세팅(BOOTSTRAP)

본 문서는 **Holysong Weekly V2 개발을 시작하기 전에 반드시 먼저 수행해야 할 초기 환경 준비 절차**를 정리한다.  
이 단계를 완료한 후에야 *Task 1~30, Repository·Service·ViewModel·UI 개발*이 올바르게 작동한다.

---

# 1. Flutter 설치 및 프로젝트 생성

### 1) Flutter 설치
- Windows/Mac/Linux 에 Flutter 최신 버전 설치  
- PATH 등록 확인  
```
flutter --version
```

### 2) 프로젝트 생성
```
flutter create holysong_weekly_v2
```

### 3) 의존성 확인
```
flutter doctor
```

---

# 2. Firebase CLI & FlutterFire CLI 설치

### 1) Firebase CLI
```
npm install -g firebase-tools
firebase login
```

### 2) FlutterFire CLI
```
dart pub global activate flutterfire_cli
```

---

# 3. Firebase 프로젝트 준비

Firebase Console에서 다음 설정을 진행한다:

1) 새 프로젝트 생성: `holysong-weekly-v2`  
2) Firestore 활성화  
   - 모드: 테스트 모드 또는 규칙 수동 설정  
3) Firebase Storage 활성화  
4) Android / iOS / Web 앱 등록  
5) GoogleService-Info.plist & google-services.json 다운로드  
6) 프로젝트 경로에 배치

---

# 4. Flutter 프로젝트에 Firebase 연결

프로젝트 루트에서 실행:

```
flutterfire configure
```

성공 시 다음 파일이 자동 생성됨:

```
lib/firebase_options.dart
```

---

# 5. pubspec.yaml 필수 패키지 설치

아래 패키지를 dependencies 아래에 반드시 추가한다:

```yaml
dependencies:
  flutter:
    sdk: flutter

  firebase_core: ^3.6.0
  cloud_firestore: ^5.4.4
  firebase_storage: ^12.3.4
```

이후:

```
flutter pub get
```

---

# 6. main.dart — Firebase 초기화 코드

`main.dart`의 최상단 init 코드:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

---

# 7. Firestore / Storage Rules (기본)

초기 개발용 기본 규칙:

**Firestore**
```
// Allow read/write for development
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

**Storage**
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if true;
    }
  }
}
```

※ 운영 전에는 반드시 최소 권한으로 변경할 것.

---

# 8. 프로젝트 디렉토리 구조 생성

아래 구조를 반드시 생성한다:

```
lib/
 ├─ firebase_options.dart
 ├─ features/
 │   └─ weekly/
 │       ├─ models/
 │       ├─ repository/
 │       ├─ service/
 │       ├─ viewmodel/
 │       └─ ui/
 └─ core/
     ├─ firebase/
     ├─ routing/
     ├─ theme/
     └─ health/
```

---

# 9. 레거시 파일 제거 규칙

다음과 같은 파일이 발견되면 **즉시 제거**한다:

- 예전 이름의 repository 파일  
- 예전 이름의 service/viewmodel 파일  
- 기능이 변경된 오래된 dart 파일  
- firebase_options.dart 구버전  
- import 경로가 다른 버전

규칙:  
> “기능 또는 파일명이 바뀌면, 이전 버전 파일은 프로젝트에서 완전히 제거한다.”

---

# 10. flutter analyze 정상 상태 만들기

첫 analyze 실행:

```
flutter analyze
```

정상 기준:

- 오류 0
- 경고는 있어도 무방

이 단계 이후에야  
Task 8(fetch) → Task 9 → Task 10 → ViewModel → UI 작업을 시작한다.

---

# 11. PRD 실행 순서 요약

1) **00_bootstrap.md (이 문서 → 환경 준비)**
2) 00_overall_architecture.md (전체 구조 이해)
3) 10_buildings.md (파일 구조)
4) 20_departments_weekly.md (클래스 구조)
5) 30_functions_weekly.md (함수 정의)
6) task.md (개발 단계)
7) progress.md (진행 상황)

---

# 12. 문제 발생 시 점검 순서

1) Firebase 패키지가 pubspec.yaml에 있는가?  
2) firebase_options.dart가 있는가?  
3) main.dart에서 Firebase.initializeApp이 호출되는가?  
4) import 경로가 repository / repositories 로 혼재되어 있지 않은가?  
5) 레거시 파일이 남아있지 않은가?  
6) flutter format / flutter analyze 통과하는가?

---

# 최종 메모
이 문서는 앞으로 Holysong V2 개발의 “0단계”를 담당하는 핵심 문서다.  
이 문서를 PRD의 출발점으로 삼으면,  
이후 Task 1~30 개발 중에는 환경 문제로 개발이 멈추는 일이 없다.
