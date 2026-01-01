import 'package:flutter_test/flutter_test.dart';
import 'package:holysong_weekly_v2/features/weekly/services/weekly_worship_service.dart';
import 'package:holysong_weekly_v2/features/weekly/models/weekly_worship.dart';
import 'fake_weekly_repository.dart';

void main() {
  group('WeeklyWorshipService.publish', () {
    late WeeklyWorshipService service;
    late FakeWeeklyRepository repo;

    setUp(() {
      repo = FakeWeeklyRepository();
      service = WeeklyWorshipService(repository: repo);
    });

    test('announcement 200자 초과면 throw', () async {
      final longText = 'a' * 201;
      final weekly = WeeklyWorship.sample().copyWith(
        announcement: longText,
        status: 'draft',
      );
      expect(() => service.publish(weekly), throwsA(isA<ArgumentError>()));
    });

    test('song.title 없으면 throw', () async {
      final weekly = WeeklyWorship.sample().copyWith(
        song: WeeklyWorship.sample().song.copyWith(title: ''),
        status: 'draft',
      );
      expect(() => service.publish(weekly), throwsA(isA<ArgumentError>()));
    });

    test('이미 published면 throw', () async {
      final weekly = WeeklyWorship.sample().copyWith(status: 'published');
      expect(() => service.publish(weekly), throwsA(isA<StateError>()));
    });

    test('draft→published 전이 & updatedAt 갱신 & repository.save 1회', () async {
      final before = DateTime.now().subtract(const Duration(minutes: 5));
      final weekly = WeeklyWorship.sample().copyWith(status: 'draft', updatedAt: before);

      final result = await service.publish(weekly);

      expect(result.status, 'published');
      expect(result.updatedAt.isAfter(before), true);
      expect(repo.saveCalls, 1);
      expect(repo.saved.last.status, 'published');
    });
  });
}
