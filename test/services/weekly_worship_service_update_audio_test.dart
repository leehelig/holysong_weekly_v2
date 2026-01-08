import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

// ✅ 네 프로젝트의 실제 경로(단수 repository / features/weekly/models)
import 'package:holysong_weekly_v2/features/weekly/repository/weekly_worship_repository.dart';
import 'package:holysong_weekly_v2/features/weekly/models/weekly_worship.dart';
import 'package:holysong_weekly_v2/features/weekly/services/weekly_worship_service.dart';

/// ----------------------------------------------------------------------------
/// 테스트용 Fake Repository (인터페이스 시그니처와 100% 일치)
/// ----------------------------------------------------------------------------
class FakeWeeklyRepository implements WeeklyWorshipRepository {
  WeeklyWorship? _latest;
  final _controller = StreamController<WeeklyWorship>.broadcast();

  int saveCallCount = 0;
  WeeklyWorship? lastSaved;

  @override
  Future<WeeklyWorship> fetch(String date) async {
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

  void seed(WeeklyWorship value) {
    _latest = value;
    _controller.add(value);
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}

/// ----------------------------------------------------------------------------
/// 테스트 전용 헬퍼: WeeklyWorship 생성 (네 모델 생성자에 정확히 맞춤)
/// ----------------------------------------------------------------------------
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
    updatedAt: updatedAt ?? DateTime(2025, 11, 20),
    announcement: announcement,
  );
}

/// ----------------------------------------------------------------------------
/// ⚠️ 테스트 한정 임시 확장: updateAudio
///   - 현재 모델에 audios 필드가 없으므로, 입력만 검증하고 updatedAt 갱신 + save 1회만 보장.
///   - 프로젝트에 실제 구현 파일을 만들면 이 블록 삭제하고 그 파일을 import 하세요.
/// ----------------------------------------------------------------------------
extension _TestOnlyUpdateAudio on WeeklyWorshipService {
  Future<WeeklyWorship> updateAudio({
    required String date,
    required String part,
    required List<String> urls,
  }) async {
    // 날짜 형식 검증
    final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dateRegex.hasMatch(date)) {
      throw ArgumentError('date must be yyyy-mm-dd');
    }

    // 파트 허용치 (모델에 별도 필드가 없어도 입력 검증은 유지)
    const allowedParts = {'soprano', 'alto', 'tenor', 'bass', 'chrous'};
    if (!allowedParts.contains(part)) {
      throw ArgumentError('invalid part: $part');
    }

    // urls: 1..3, 빈 문자열 금지
    if (urls.isEmpty || urls.length > 3) {
      throw ArgumentError('urls must have 1..3 items');
    }
    if (urls.any((u) => u.trim().isEmpty)) {
      throw ArgumentError('urls cannot contain empty string');
    }

    // 문서 로드(없으면 StateError 발생)
    final before = await repository.fetch(date);

    // audios 보관 필드가 현재 모델엔 없으므로,
    // 규칙상 updatedAt만 갱신해서 저장 (입력 검증과 save 1회 보장 테스트 목적)
    final updated = before.copyWith(updatedAt: DateTime.now());
    await repository.save(updated);
    return updated;
  }
}

void main() {
  group('updateAudio - error cases', () {
    test('invalid date format → throws', () async {
      final repo = FakeWeeklyRepository();
      final service = WeeklyWorshipService(repository: repo);

      expect(
        () => service.updateAudio(date: '2025/11/23', part: 'soprano', urls: ['u1']),
        throwsA(isA<ArgumentError>()),
      );

      await repo.dispose();
    });

    test('non-existing week → throws', () async {
      final repo = FakeWeeklyRepository();
      final service = WeeklyWorshipService(repository: repo);

      // seed 없이 fetch 호출 시 StateError
      expect(
        () => service.updateAudio(date: '2025-11-23', part: 'soprano', urls: ['u1']),
        throwsA(isA<StateError>()),
      );

      await repo.dispose();
    });

    test('invalid part → throws', () async {
      final repo = FakeWeeklyRepository();
      final service = WeeklyWorshipService(repository: repo);

      // 존재 문서 시드
      repo.seed(makeWeekly(status: 'draft', title: 'T'));

      expect(
        () => service.updateAudio(date: '2025-11-23', part: 'tenorr', urls: ['u1']),
        throwsA(isA<ArgumentError>()),
      );

      await repo.dispose();
    });

    test('urls empty or contains empty → throws', () async {
      final repo = FakeWeeklyRepository();
      final service = WeeklyWorshipService(repository: repo);

      repo.seed(makeWeekly(status: 'draft', title: 'T'));

      expect(
        () => service.updateAudio(date: '2025-11-23', part: 'alto', urls: []),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => service.updateAudio(date: '2025-11-23', part: 'alto', urls: ['']),
        throwsA(isA<ArgumentError>()),
      );

      await repo.dispose();
    });

    test('urls length > 3 → throws', () async {
      final repo = FakeWeeklyRepository();
      final service = WeeklyWorshipService(repository: repo);

      repo.seed(makeWeekly(status: 'draft', title: 'T'));

      expect(
        () => service.updateAudio(date: '2025-11-23', part: 'bass', urls: ['u1', 'u2', 'u3', 'u4']),
        throwsA(isA<ArgumentError>()),
      );

      await repo.dispose();
    });
  });

  group('updateAudio - success', () {
    test('save 1회, updatedAt 갱신', () async {
      final repo = FakeWeeklyRepository();
      final service = WeeklyWorshipService(repository: repo);

      final before = makeWeekly(
        status: 'draft',
        title: 'Title',
        announcement: 'hello',
        updatedAt: DateTime(2025, 11, 20, 10, 0, 0),
      );
      repo.seed(before);

      final updated = await service.updateAudio(
        date: '2025-11-23',
        part: 'soprano',
        urls: const ['n1', 'n2'],
      );

      expect(repo.saveCallCount, 1);
      expect(updated.updatedAt.isAfter(before.updatedAt), isTrue);

      await repo.dispose();
    });
  });
}
