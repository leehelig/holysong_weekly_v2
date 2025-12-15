# 40_integration.md
Bethel Weekly Worship — Firebase Integration Guide  
(Connect-Only Initialization + Storage + Firestore Structure)

---

# 1. 목적
본 문서는 Flutter 프로젝트가 Firebase(Firestore + Storage)와  
안전하고 안정적으로 연결되도록 초기화 절차를 정의한다.

주요 목표:
1) **Firebase 연결 정합성 확보**
2) **Firestore 문서 구조 정의**
3) **Storage 업로드 경로 정의**
4) **Admin/User UI 양쪽에서 공통 데이터 사용 가능하도록 설계**

---

# 2. Firebase 준비 절차 (Connect-Only)

## 2.1 패키지 설치
```bash
flutter pub add firebase_core cloud_firestore firebase_storage
2.2 FlutterFire CLI 설치
bash
코드 복사
dart pub global activate flutterfire_cli
2.3 Firebase와 Flutter 프로젝트 연결
프로젝트 루트에서:

bash
코드 복사
flutterfire configure
선택:

Firebase 프로젝트 선택

Web 플랫폼 활성화

결과:

lib/firebase_options.dart 자동 생성

3. Firebase 초기화 (Flutter 코드 측)
3.1 firebase_init.dart
경로:

bash
코드 복사
lib/core/firebase/firebase_init.dart
코드:

dart
코드 복사
import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';

class FirebaseBoot {
  static bool _inited = false;

  static Future<void> ensure() async {
    if (_inited) return;
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _inited = true;
  }
}
3.2 main.dart
dart
코드 복사
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseBoot.ensure();
  runApp(const MyApp());
}
4. Firestore 구조 정의
Collection: weekly
Document ID = yyyy-mm-dd (주일 날짜)

yaml
코드 복사
weekly/
 └─ 2025-11-23/
       announcement: "200자 이내 공지"
       status: "draft" | "published"
       song:
         title: "주 예수보다 더 귀한 것은 없네"
         composer: "Unknown"
         arranger: "편곡자"
       audios:
         soprano: ["url1", "url2"]
         alto: [...]
         tenor: [...]
         bass: [...]
         choir: [...]
       scores:
         conductor: "PDF_URL"
         choir: "PDF_URL"
         horn: "PDF_URL"
         bassoon: "PDF_URL"
         clarinet: "PDF_URL"
         oboe: "PDF_URL"
         flute: "PDF_URL"
악보 파트는 7개 고정

음원은 파트별 최대 3개

5. Storage 구조 정의
5.1 악보 PDF 경로
css
코드 복사
scores/{yyyy-mm-dd}/{instrument}.pdf
예:

bash
코드 복사
scores/2025-11-23/flute.pdf
scores/2025-11-23/conductor.pdf
5.2 업로드 규칙
파일은 반드시 .pdf

업로드 성공 → 다운로드 URL 획득 → Firestore 업데이트
(WeeklyWorshipRepository.uploadScorePdf에서 구현)

6. Health Check (개발용)
6.1 health_check.dart
bash
코드 복사
lib/core/health/health_check.dart
dart
코드 복사
import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> healthPing() async {
  final ref = FirebaseFirestore.instance.collection('health').doc('ping');
  await ref.set({'ok': true, 'ts': DateTime.now().toIso8601String()});
  final snap = await ref.get();
  return snap.data()?['ok'] == true;
}
테스트 후 삭제 또는 주석 처리.

7. Firestore Rules (개발→운영)
7.1 개발(임시)
js
코드 복사
allow read: if true;
allow write: if request.auth != null;
7.2 운영(베델)
관리자 쓰기만 허용하도록 강화 예정.

8. Firebase 서비스 연결 요약
계층	역할	Firebase 의존
UI	화면 렌더링	X
ViewModel	상태 관리	X
Service	규칙 적용	X
Repository	DB/FIle IO	Firestore + Storage
core/firebase	Firebase 초기화	Firebase Core

9. 완료 체크리스트
 Firebase Web 앱 생성

 firebaseConfig 발급

 flutterfire configure → firebase_options.dart 생성

 firebase_init.dart 구성

 Firestore/Storage 경로 정의

 초기화 성공 확인 (health ping)

10. 다음 단계
WeeklyWorshipRepository 구현

Service publish gate 구현

Admin UI 구현

User UI 구현

Storage 업로드/다운로드 테스트

Rules 강화

yaml
코드 복사

---


