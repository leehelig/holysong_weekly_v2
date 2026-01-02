import 'package:flutter_test/flutter_test.dart';
import 'package:holysong_weekly_v2/features/weekly/services/weekly_worship_service.dart';
import 'package:holysong_weekly_v2/features/weekly/models/weekly_worship.dart';
import 'fake_weekly_repository.dart';

void main() {
  group('WeeklyWorshipService.updateAnnouncement', () {
    late WeeklyWorshipService service;
    late FakeWeeklyRepository repo;

    setUp(() {
      repo = FakeWeeklyRepository();
      service = WeeklyWorshipService(repository: repo);

      // 가짜 DB에 기본 문서(draft) 심기 (현재 모델은 date 필드 없음)
      repo.seed('2026-01-04', WeeklyWorship(
        status: 'draft',
        announcement: '',
        song: const Song(title: 'Hymn 1'),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ));
    });

    test('200자 초과면 throw ArgumentError', () async {
      final tooLong = 'a' * 201;
      expect(
        () => service.updateAnnouncement('2026-01-04', tooLong),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('존재하지 않는 date면 StateError', () async {
      expect(
        () => service.updateAnnouncement('1999-01-01', 'hello'),
        throwsA(isA<StateError>()),
      );
    });

    test('정상: announcement만 갱신 + updatedAt 최신 + save 1회', () async {
      final before = DateTime.now().subtract(const Duration(minutes: 5));

      // seed로 넣은 문서의 updatedAt을 비교 기준보다 과거로 세팅
      final orig = await repo.fetch('2026-01-04');
      repo.data['2026-01-04'] = orig.copyWith(updatedAt: before);

      final result = await service.updateAnnouncement('2026-01-04', ' 공지 입니다 ');

      expect(result.announcement, '공지 입니다');        // trim 적용
      expect(result.updatedAt.isAfter(before), true);   // 타임스탬프 갱신
      expect(result.status, orig.status);               // 상태/노래 등은 그대로
      expect(result.song.title, orig.song.title);

      expect(repo.saveCalls, 1);                        // 저장 호출 1회
      expect(repo.saved.last.announcement, '공지 입니다');
    });
  });
}
