# 벧엘 프로젝트 – 전체 지휘 구조(Architecture Master Plan)

---

## 1. 프로젝트 목적(Why)

벧엘 프로젝트는 **매주 업데이트되는 찬양대 정보(공지, 찬양곡 정보, 파트별 음원, 악보)를
하나의 화면에서 사용자에게 제공**하는 웹 애플리케이션이다.

관리자는 매주 자료를 쉽고 안정적으로 등록·수정해야 하고,

사용자는 날짜만 선택하면 해당 주의 모든 콘텐츠를 한눈에 확인해야 한다.

---


## 2. 핵심 원칙 (ADD: 건물–부서–직원 방법론)

이 프로젝트는 다음 철학을 따른다:

1. **건물(Building) = 파일(.dart)**
2. **부서(Department) = 클래스(Class)**
3. **직원(Employee) = 함수(Function)**
4. **매개변수 = 직원이 들고 들어가는 서류**
5. **리턴값 = 직원이 만들어내는 보고서**
6. **서비스 계층은 반드시 Repository → Service → ViewModel → UI 단일 방향**

---

## 3. 전체 도메인 구조 (Macro Domain Architecture)

### 3.1 WeeklyWorship 도메인 (핵심)

- 공지사항(텍스트, 줄바꿈 가능)
- 찬양곡 정보: 제목/작곡자/편곡자
- 파트별 음원 URL (각 파트 최대 3개)
- 악보(PDF) — 7개 악기 고정

  (지휘자, 찬양대, 호른, 바순, 클라리넷, 오보에, 플룻)

- 날짜(YYYY-MM-DD)
- 상태: draft / published

### 3.2 PDF Storage 도메인

- PDF 업로드 → Firebase Storage URL 발급
- Storage 구조 고정

### 3.3 Authentication 도메인

- 관리자 로그인
- 사용자/관리자 권한 관리

### 3.4 UI 도메인

- **사용자 화면**: 날짜 선택 → 단일 페이지 출력
- **관리자 화면**: CRUD, URL 입력, PDF 업로드, draft 저장
- **반응형 필수** (모바일 1열 → 데스크톱 2~3열)

---

## 4. 데이터 흐름(Information Flow Architecture)

### 4.1 사용자(User) 흐름

```
날짜 선택 → ViewModel.load(date)
         → WeeklyWorshipRepository.fetch(date)
         → Firestore의 /weeks/{date} 조회
         → UI 렌더링

음원 URL 클릭 → 플레이어 실행
PDF 보기 클릭 → 브라우저 새 탭에서 PDF 렌더링

```

### 4.2 관리자(Admin) 흐름

```
Draft 생성 → PDF 업로드 → URL 생성
음원 URL 입력 → 필드 입력
Save → Firestore에 전체 WeeklyWorship 문서 덮어쓰기

```

---

## 5. 기술 아키텍처(Tech Architecture)

### 5.1 Firestore 구조

```
/weeks/{yyyy-mm-dd}
  announcement: string
  song:
    title: string
    composer: string
    arranger: string
  audios:
    soprano: [url1, url2, ...]
    alto: []
    tenor: []
    bass: []
    chrous: []
  scores:
    conductor: url
    choir: url
    horn: url
    bassoon: url
    clarinet: url
    oboe: url
    flute: url
  status: 'draft' | 'published'
  date: '2025-11-23'

```

### 5.2 Storage 구조

```
/scores/{yyyy-mm-dd}/{instrument}.pdf

```

### 5.3 Routing

- 단일 라우트 `/`
- 상세페이지 없음
- PDF 상세는 브라우저 탭에서 처리

### 5.4 반응형 레이아웃

- mobile: 1 column
- tablet: 2 columns
- desktop: 3 columns
- Tailwind/Grid/Flex 기반

---

## 6. 파일(건물) 전체 분류 (High-level Buildings)

### WeeklyWorship Domain

- models/weekly_worship.dart
- repositories/weekly_worship_repository.dart
- services/weekly_worship_service.dart
- viewmodels/weekly_worship_view_model.dart

### UI – User

- ui/user/weekly_screen.dart
- ui/user/components/audio_section.dart
- ui/user/components/scores_section.dart
- ui/user/components/announcement_section.dart
- ui/user/components/song_section.dart

### UI – Admin

- ui/admin/edit_weekly_screen.dart
- ui/admin/manage_audio_list.dart
- ui/admin/pdf_upload_button.dart

### Core

- core/firebase/firebase_init.dart
- core/theme/app_theme.dart
- core/routing/app_router.dart

---

## 7. 레이어 규칙 (변경 금지)

```
[ UI ] → [ ViewModel ] → [ Service ] → [ Repository ] → [ Firestore/Storage ]

```

- 상위 레이어는 하위 레이어를 호출할 수 있으나
- 하위 레이어는 상위 레이어를 접근할 수 없다
- UI는 Repository를 직접 호출하지 않는다
- Repository는 Firestore/Storage 외의 계층을 참조하지 않는다
- ViewModel은 UI/Service 사이의 중간 조정자

---

## 8. 프로젝트 운영 규칙

- 모든 개발은 docs/ 폴더 안의 설계 문서 기반
- **C(00_overall_architecture.md)는 프로젝트 헌법**
- 10_buildings.md, 20_departments_*.md, 30_functions_*.md는 C를 따름
- Gemini CLI에게 코드 작성을 명령할 때는 반드시 다음을 포함해야 한다:

```
먼저 docs/00_overall_architecture.md의 전체 지휘 구조를 읽고,
해당 구조를 절대로 변경하지 말고,
그 안에서 20, 30 문서를 기반으로 코드를 생성하라.

```