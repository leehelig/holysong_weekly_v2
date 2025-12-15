# architecture.md — Holysong V2 Architecture Master Spec

이 문서는 프로젝트의 단일한 기준(Single Source of Truth)이다.
모든 개발은 이 파일을 기준으로 이루어진다.

## 1. 프로젝트 목적
매주 업데이트되는 찬양대 정보(공지, 찬양곡, 파트별 음원, 악보)를
관리자가 쉽게 등록하고, 대원들이 조회할 수 있는 플랫폼 구축.

## 2. ADD 철학 (건물–부서–직원)
- 건물(Building) = 파일(.dart)
- 부서(Department) = 클래스(Class)
- 직원(Employee) = 함수(Function)
- 매개변수 = 직원이 들고가는 서류
- 리턴값 = 직원이 만들어내는 보고서
- 단방향 흐름: Repository → Service → ViewModel → UI

## 3. 시스템 구조 (클린 아키텍처 반영)
lib/
├─ core/ (Firebase, Theme, Routing)
├─ features/
│  └─ weekly/
│     ├─ models/
│     │   ├─ weekly_worship.dart
│     │   └─ song_info.dart
│     ├─ repository/
│     ├─ service/
│     ├─ viewmodel/
│     └─ ui/

## 4. WeeklyWorship 모델 스키마
- date (yyyy-mm-dd)
- announcement (String)
- song (SongInfo)
- audios: Map<String, List<String>>
- scores: Map<String, String?>
- status: draft | published
- updatedAt: DateTime?

## 5. 기능(Weekly)
- Fetch
- Watch
- Save
- Upload Score
- Fetch Latest

## 6. PRD 링크
- 00_overall_architecture.md
- 10_buildings.md
- 20_departments_weekly.md
- 30_functions_weekly.md

> GPT/Gemini는 반드시 이 파일을 기준으로 답변해야 한다.
