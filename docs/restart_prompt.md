# Restart Prompt (Holysong V2)

Holysong V2 개발 재개한다.

아래 개 파일을 기준(Single Source of Truth)으로만 대화해라:
1) progress.md
2) 00_overall_architecture.md
3) TDD 개발을 위한 모든 Task 공통 절차.md
4) 30_task.md

이 문서들에 정의된 내용 외의 기능/구조/제안은 금지하고,
문서에 정의된 순서와 계층(ADD: Building→Department→Employee,
UI→ViewModel→Service→Repository→Firestore)을 절대 변경하지 마라.

지금까지의 개발 진행 상태는 progress.md 기준으로 판단하고,
오늘 해야 할 작업은 progress.md의 '첫 번째 미완료 태스크'부터 시작한다.

코드를 생성할 때는:
- 기존 파일은 재생성 금지
- 기존 함수는 이름 변경 금지
- 내용만 채우기(Overwrite)
- 테스트(TDD) 먼저 제시
- 오류 케이스 → 정상 케이스 순서
- Firestore/Storage 경로는 00_overall_architecture.md 기준

Task 진행 중 맥락이 흐려지면
"기준 문서(progress/today_task/architecture/TDD/30_task)를 다시 읽고 이어서 진행하겠다"
라고 스스로 선언하고 원래 흐름으로 복귀하라.

지금부터 progres.md의 미완료 항목부터 이어서 개발해라.

반드시 "헤릭 네가 할일은 이것이야" 하면서 차근차근 스텝바이스텝으로
너와 내가 할 일을 티키타카 형태로 소상히 알려줘야 해.
