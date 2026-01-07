// Path: test/services/weekly_worship_service_update_song_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:holysong_weekly_v2/features/weekly/services/weekly_worship_service.dart';
import 'package:holysong_weekly_v2/features/weekly/models/weekly_worship.dart';
import 'fake_weekly_repository.dart';
import 'package:holysong_weekly_v2/features/weekly/services/weekly_worship_service_update_song.dart';
import 'package:holysong_weekly_v2/features/weekly/services/weekly_worship_service_update_song.dart';
import 'package:holysong_weekly_v2/features/weekly/services/weekly_worship_service_update_song.dart';

void main() {
  group('WeeklyWorshipService.updateSong', () {
    late WeeklyWorshipService service;
    late FakeWeeklyRepository repo;

    setUp(() {
      repo = FakeWeeklyRepository();
      service = WeeklyWorshipService(repository: repo);
    });

    test('date empty → throws ArgumentError', () async {
      expect(
        () => service.updateSong('', const Song(title: 't')),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('not found document → throws StateError', () async {
      expect(
        () => service.updateSong('2026-01-11', const Song(title: 't')),
        throwsA(isA<StateError>()),
      );
    });

    test('song.title empty or blank → throws ArgumentError', () async {
      // given: 미리 존재하는 문서 삽입(현재 모델은 date 필드 없음, repo key로 식별)
      repo.seed(
        '2026-01-11',
        WeeklyWorship(
          status: 'draft',
          announcement: '',
          song: const Song(title: 'Old'),
          updatedAt: DateTime.now().subtract(const Duration(minutes: 10)),
        ),
      );

      expect(
        () => service.updateSong('2026-01-11', const Song(title: '')),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => service.updateSong('2026-01-11', const Song(title: '   ')),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('updates only song fields, preserves others, touches updatedAt, save 1회', () async {
      // given: 존재 문서(seed)
      final before = DateTime.now().subtract(const Duration(minutes: 5));
      repo.seed(
        '2026-01-11',
        WeeklyWorship(
          status: 'draft',
          announcement: 'keep me',
          song: const Song(title: 'Old', composer: 'A', arranger: 'B'),
          updatedAt: before,
        ),
      );

      final beforeCalls = repo.saveCalls;

      // when
      final result = await service.updateSong(
        '2026-01-11',
        const Song(title: 'New', composer: 'NewC'),
      );

      // then: 보존/갱신 검증
      expect(result.song.title, 'New');
      expect(result.song.composer, 'NewC');
      expect(result.song.arranger, 'B'); // 미지정 필드는 기존값 유지
      expect(result.announcement, 'keep me');
      expect(result.updatedAt.isAfter(before), true);
      expect(repo.saveCalls, beforeCalls + 1); // 저장 1회
      expect(repo.saved.last.song.title, 'New');
    });
  });
}
