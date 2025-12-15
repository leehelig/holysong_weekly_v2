//# 중요한 설계 결정(결재 문서 개념)
# 60_decisions.md
Bethel Weekly Worship — Architecture Decision Record (ADR)

본 문서는 시스템의 주요 설계 결정을 기록하여  
향후 변경 시 참고할 수 있는 근거를 제공한다.  
(ADD + Clean Architecture + Firebase 기반)

---

# D001 — 단일 화면 구조(Single Screen Architecture)
## 결정
- User 용 화면은 한 개(`weekly_screen.dart`)만 존재한다.
- 날짜 선택 → 해당 주의 WeeklyWorship 문서를 읽어 화면에 즉시 표시한다.
- 상세 화면은 제공하지 않는다.

## 이유
- 예배자료는 “한 화면에서 완결되는 경험”이 가장 직관적이다.
- 복잡한 라우팅/내비게이션을 제거해 유지보수 비용 감소.
- 모바일 사용자가 많아 페이지 전환이 불리함.

## 대안
- 상세 페이지 생성 (곡 상세, 악보 상세 등)
- 모달 팝업 기반 상세

## 반대 이유
- UX 과부하 증가
- 사용자 입장에서 정보가 흩어질 수 있음

---

# D002 — Firebase Connect-Only 초기화
## 결정
- 프로젝트 시작 시점에 Firebase 초기화만 수행한다.
- 도메인 개발은 이후에 진행한다.

## 이유
- Flutter/Firebase 환경 설정 이슈를 초기에 해결하면  
  나머지 개발에 지장이 없다.
- Firestore/Storage 동작 여부를 빠르게 검증 가능.

## 대안
- 개발 완성 후 Firebase 연결
- 개발 후반부에서 Storage/Firestore 검사

## 반대 이유
- 후반부에 환경 문제 발생 시 리스크가 너무 큼.

---

# D003 — 단일 문서 구조(WeeklyWorship = 1 Document)
## 결정
- 날짜(`yyyy-mm-dd`)를 Firestore Document ID로 사용한다.
- WeeklyWorship 데이터는 하나의 문서에 모두 포함시킨다.

## 이유
- “하나의 주”는 “하나의 자료 묶음”이라는 비즈니스 단위와 일치.
- 무결성 관리 용이 (여러 문서로 찢어질 필요 없음)
- Query 없이 Document만 읽으면 끝 → 속도 빠름

## 대안
- 곡/음원/악보 문서를 여러 개로 분리
- SubCollection 형태로 설계

## 반대 이유
- 불필요한 복잡도 증가
- 데이터 consistency 관리가 어려움

---

# D004 — 악보 파트 7개 고정 (Scores Keys Fixed)
## 결정
- conductor, choir, horn, bassoon, clarinet, oboe, flute  
  총 7파트를 **고정된 Key**로 사용한다.

## 이유
- 예배팀 악기 구성은 변하지 않는다.
- 관리자가 매주 다른 구조를 생성할 필요가 없다.
- UI/Service/Validators 코드가 단순해짐.

## 대안
- 악기 파트를 동적으로 추가/삭제 가능하게 만들기

## 반대 이유
- UI 변경 필요
- 데이터 설계 복잡
- Validation 복잡성이 급증

---

# D005 — 음원(URL) 최대 3개 제한
## 결정
- 각 파트 음원은 최대 3개의 URL만 등록 가능하게 한다.

## 이유
- 실제 운영 경험상 1~3개면 충분
- 너무 많은 음원이 등록되면 UI 복잡

## 대안
- 개수 제한 없음

## 반대 이유
- 품질 관리 어려움
- 불필요한 데이터 누적

---

# D006 — PDF 새 탭(Open in New Tab)
## 결정
- 악보 PDF 클릭 시 브라우저에서 새 탭으로 열리도록 한다.

## 이유
- 모바일/PC 표준 PDF Viewer 사용 가능
- Flutter Web 내부에서 PDF 렌더링의 성능 이슈를 피함

## 대안
- Flutter Web PDF 뷰어 직접 구현

## 반대 이유
- 유지보수 부담
- 성능 저하 가능성

---

# D007 — Publish Gate(공개 전 검증) 필수
## 결정
- publish() 호출 전 반드시 유효성 검사를 수행한다.
- 검증 실패 시 PublishGateException 발생.

## 이유
- 잘못된 자료가 공개되면 주일 예배 품질에 직접적인 악영향
- 데이터 품질을 보장해야 함

## Gate 규칙
- 공지 비어있지 않음
- song.title 존재
- 음원 파트별 최대 3개
- scores 7파트 모두 유효 URL 또는 null

---

# D008 — Clean Architecture 계층 유지
## 결정
UI → ViewModel → Service → Repository → Firebase 구조 유지.

## 이유
- 구조가 명확하여 테스트, 유지보수, 확장이 쉬움
- Firebase 의존성을 도메인 로직에서 완전히 분리

## 대안
- UI에서 Repository 직접 호출

## 반대 이유
- 도메인 규칙이 사라짐
- 유지보수 불가 수준으로 복잡해짐

---

# D009 — 최신본만 유지 (Versioning 없음)
## 결정
- WeeklyWorship은 Draft → Publish 형식으로 관리하되,  
  Publish 후에도 별도 버전 저장을 하지 않는다.

## 이유
- 저장 공간 절약
- 운영 단순성
- 관리자가 복잡한 버전 관리할 필요 없음

## 대안
- 전체 히스토리 보존

## 반대 이유
- Storage/Firestore 비용 증가
- 관리 부담 증가

---

# D010 — 반응형 UI 필수 (1/2/3열)
## 결정
- 모바일: 1열
- 태블릿: 2열
- 데스크톱: 3열

## 이유
- 성도·관리자 대부분이 모바일/PC 환경 혼합 사용
- 가독성 최적화

## 대안
- 데스크톱 전용
- 모바일 중심 UI

## 반대 이유
- 사용자 경험 저하
- 레이아웃 깨짐 가능성

