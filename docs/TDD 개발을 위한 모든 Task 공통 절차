# Holysong 개발 공통 작업 절차 (ALL TASK 공용)

모든 Task(모델, 레포지토리, 서비스, 뷰모델, UI)는  
아래 5단계 절차를 **동일하게** 따른다.  
이 절차는 TDD + Clean Architecture 기반으로 안정성, 추적성, 유지보수성을 극대화하는 구조다.

---

## 1️⃣ 준비 단계 (Context Set-up)

**이 Task를 수행하기 위해 필요한 모든 정보 확인**

- WeeklyWorship 모델 구조
- Firestore 문서 구조
- 비즈니스 규칙 (예: 공지 ≤ 200자)
- UI 요구사항
- 상태 관리 규칙
- 이미 존재하는 함수 시그니처
- 00_overall_architecture.md 기준

❗ **이 단계에서 정보 부족 시 반드시 보완해야 함**

---

## 2️⃣ TDD 기준 설계 (Test Design)

해당 Task가 충족해야 하는 **테스트 조건을 먼저 정의**한다.

예시 (모델 Task):
- 필드 누락 → 기본값 처리 or 예외
- JSON → 모델 정상 변환
- audio가 null이면 빈 리스트로

예시 (ViewModel Task):
- saveDraft 호출 후 isSaving=false 되어야 함
- publish 중 오류 → errorMessage 설정

👉 테스트 코드를 작성하든, **수동 테스트 조건**으로 정의하든 상관없다.  
핵심은 **“예상 입력과 출력이 명확히 정해져 있어야 한다”**는 것.

---

## 3️⃣ 구현 단계 (Implementation)

이 Task에서 요구한 범위만 구현한다.  
❗ **범위 밖 기능(Side effect) 추가 금지**

예)
- 모델 Task → 모델 파일만 수정
- 레포 Task → Firestore 접근만 구현
- 서비스 Task → 비즈니스 로직만 처리
- 뷰모델 Task → 상태 업데이트만 처리

---

## 4️⃣ 테스트 단계 (Self Test)

TDD 테스트 또는 수동 테스트로 검증.

예:
```dart
final map = {...};
final weekly = WeeklyWorship.fromMap(map);
assert(weekly.date == '2025-11-23');

예 (ViewModel):

viewModel.saveDraft();
expect(viewModel.isSaving, false);


