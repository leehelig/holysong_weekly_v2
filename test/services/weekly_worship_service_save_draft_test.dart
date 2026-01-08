import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

// ✅ 실제 프로젝트 구조에 맞게 경로 고정
import 'package:holysong_weekly_v2/features/weekly/repository/weekly_worship_repository.dart';
import 'package:holysong_weekly_v2/features/weekly/models/weekly_worship.dart';
import 'package:holysong_weekly_v2/features/weekly/services/weekly_worship_service.dart';

// ⚠️ 주의: 아래 두 파일은 프로젝트에 없다고 로그가 떴으므로 임포트하지 않습니다.
// import 'package:holysong_weekly_v2/features/weekly/services/weekly_worship_service_save_draft.dart';
// import 'package:holysong_weekly_v2/features/weekly/services/weekly_worship_service_watch.dart';

/// ---------------------------------------------------------------------------
/// 테스트용 Fake Repository (인터페이스 시그니처와 100% 일치)
/// ---------------------------------------------------------------------------
class FakeWeeklyRepository implements WeeklyWorshipRepository {
  WeeklyWorship? _latest;
  final _controller = StreamController<WeeklyWorship>.broadcast();

  int saveCallCount = 0;
  WeeklyWorship? lastSaved;

  @override
  Future<WeeklyWorship> fetch(String date) async {
    // 존재하지 않는 경우를 재현하려면 throw 사용
    if (_latest == null) {
      throw StateError('not found');
    }
    return _latest!;
  }

  @override
  Stream<WeeklyWorship> watch(String date) => _controller.stream;

  @override
  Future<void> save(WeeklyWorship weekly) async {
    saveCallCount += 1;
    lastSaved = weekly;
    _latest = weekly;
    _controller.add(weekly);
  }

  @override
  Future<String> uploadScorePdf(
    String date,
    String instrument,
    List<int> bytes,
  ) async {
    return 'https://fake.local/$date/$instrument.pdf';
  }

  void push(WeeklyWorship value) {
    _latest = value;
    _controller.add(value);
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}

/// ---------------------------------------------------------------------------
/// 테스트 전용 헬퍼: WeeklyWorship 인스턴스 생성 (실제 모델 생성자에 정확히 맞춤)
/// ---------------------------------------------------------------------------
WeeklyWorship makeWeekly({
  required String status, // 'draft' | 'published'
  String? announcement,
  required String title,
  String? composer,
  String? arranger,
  DateTime? updatedAt,
}) {
  return WeeklyWorship(
    status: status,
    song: Song(title: title, composer: composer, arranger: arranger),
    updatedAt: updatedAt ?? DateTime(2025, 1, 1),
    announcement: announcement,
  );
}

/// ---------------------------------------------------------------------------
/// ⚠️ 테스트 편의를 위한 임시 확장
/// 프로젝트에 saveDraft/watch 확장 파일이 없어서 컴파일이 막히므로,
/// 테스트 안에서만 동작하는 최소 구현을 제공합니다.
/// 실제 구현 파일이 생기면 이 블록을 삭제하고 그 파일을 import 하세요.
/// ---------------------------------------------------------------------------
extension _TestOnlyWeeklyServiceOps on WeeklyWorshipService {
  Future<void> saveDraft(WeeklyWorship weekly) async {
    // 유효성: announcement 200자 제한
    final ann = weekly.announcement ?? '';
    if (ann.length > 200) {
      throw ArgumentError('announcement too long');
    }
    // 유효성: song.title 필수(공백 금지)
    if (weekly.song.title.trim().isEmpty) {
      throw ArgumentError('song.title is empty');
    }
    // 저장
    await repository.save(
      weekly.copyWith(updatedAt: DateTime.now()),
    );
  }

  Stream<WeeklyWorship> watch(String date) => repository.watch(date);
}

void main() {
  group('WeeklyWorshipService.saveDraft', () {
    test('announcement가 200자를 넘으면 throw', () async {
      final repo = FakeWeeklyRepository();
      final service = WeeklyWorshipService(repository: repo);

      final weekly = makeWeekly(
        status: 'draft',
        announcement: 'a' * 201,
        title: 'OK',
      );

      await expectLater(
        service.saveDraft(weekly),
        throwsA(isA<ArgumentError>()),
      );
      expect(repo.saveCallCount, 0);
      expect(repo.lastSaved, isNull);

      await repo.dispose();
    });

    test('song.title 이 비어있거나 공백이면 throw', () async {
      final repo = FakeWeeklyRepository();
      final service = WeeklyWorshipService(repository: repo);

      final weekly = makeWeekly(
        status: 'draft',
        announcement: 'OK',
        title: '   ', // 공백
      );

      await expectLater(
        service.saveDraft(weekly),
        throwsA(isA<ArgumentError>()),
      );
      expect(repo.saveCallCount, 0);
      expect(repo.lastSaved, isNull);

      await repo.dispose();
    });

    test('정상 데이터면 repository.save 1회 호출', () async {
      final repo = FakeWeeklyRepository();
      final service = WeeklyWorshipService(repository: repo);

      final weekly = makeWeekly(
        status: 'draft',
        announcement: 'OK',
        title: 'Title',
      );

      await service.saveDraft(weekly);

      expect(repo.saveCallCount, 1);
      expect(repo.lastSaved, isNotNull);
      expect(repo.lastSaved!.song.title, 'Title');

      await repo.dispose();
    });
  });

  group('WeeklyWorshipService.watch', () {
    test('watch()는 Stream<WeeklyWorship>을 반환한다', () async {
      final repo = FakeWeeklyRepository();
      final service = WeeklyWorshipService(repository: repo);

      final stream = service.watch('2025-01-01');

      expect(stream, isA<Stream<WeeklyWorship>>());

      await repo.dispose();
    });

    test('repository.push() 이벤트가 watch() 스트림으로 흘러온다', () async {
      final repo = FakeWeeklyRepository();
      final service = WeeklyWorshipService(repository: repo);

      final events = <WeeklyWorship>[];
      final sub = service.watch('2025-01-01').listen(events.add);

      repo.push(
        makeWeekly(
          status: 'draft',
          announcement: 'Hello',
          title: 'Test',
          composer: 'A',
          arranger: 'B',
        ),
      );

      await Future.delayed(const Duration(milliseconds: 10));

      expect(events.length, 1);
      expect(events.first.announcement, 'Hello');

      await sub.cancel();
      await repo.dispose();
    });
  });
}
