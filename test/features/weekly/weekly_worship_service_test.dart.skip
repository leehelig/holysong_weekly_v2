import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:holysong_weekly_v2/features/weekly/models/weekly_worship.dart';
import 'package:holysong_weekly_v2/features/weekly/models/song_info.dart';
import 'package:holysong_weekly_v2/features/weekly/services/weekly_worship_service.dart';
import 'package:holysong_weekly_v2/features/weekly/repository/weekly_repository.dart';

/// 테스트용 Fake Repository
class FakeWeeklyRepository implements WeeklyRepository {
  WeeklyWorship? _latest;
  final _controller = StreamController<WeeklyWorship?>.broadcast();

  @override
  Future<WeeklyWorship?> fetch(String date) async => _latest;

  @override
  Stream<WeeklyWorship?> watch(String date) => _controller.stream;

  @override
  Future<void> save(WeeklyWorship weekly) async {
    _latest = weekly;
    _controller.add(weekly);
  }

  void push(WeeklyWorship value) {
    _latest = value;
    _controller.add(value);
  }

  @override
  Future<String> uploadScorePdf({
    required String date,
    required String instrument,
    required Uint8List fileBytes,
  }) async {
    return 'https://fake.local/$date/$instrument.pdf';
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}

void main() {
  group('WeeklyWorshipService.saveDraft', () {
    test('should throw when announcement exceeds 200 chars', () {
      // TODO: Codex will implement the test body
    });

    test('should throw when song.title is empty or null', () {
      // TODO: Codex will implement the test body
    });

    test('should call repository.save when data is valid', () {
      // TODO: Codex will implement the test body
    });
  });

  group('WeeklyWorshipService.watch', () {
    test('watch() returns a Stream of WeeklyWorship', () async {
      final fake = FakeWeeklyRepository();
      final service = WeeklyWorshipService(fake);

      final stream = service.watch('2025-01-01');

      expect(stream, isA<Stream<WeeklyWorship?>>());

      await fake.dispose();
    });

    test('watch() emits updated WeeklyWorship when repository pushes new data',
        () async {
      final fake = FakeWeeklyRepository();
      final service = WeeklyWorshipService(fake);

      final events = <WeeklyWorship?>[];
      final sub = service.watch('2025-01-01').listen(events.add);

      fake.push(
        WeeklyWorship(
          date: '2025-01-01',
          announcement: 'Hello',
          song: SongInfo(
            title: 'Test',
            composer: 'A',
            arranger: 'B',
          ),
          audios: const {},
          scores: const {},
          status: 'draft',
        ),
      );

      await Future.delayed(const Duration(milliseconds: 10));

      expect(events.length, 1);
      expect(events.first!.announcement, 'Hello');

      await sub.cancel();
      await fake.dispose();
    });
  });
}
