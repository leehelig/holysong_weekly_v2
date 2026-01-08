// lib/features/weekly/services/weekly_worship_service_update_audio.dart

import 'package:holysong_weekly_v2/features/weekly/models/weekly_worship.dart';
import 'package:holysong_weekly_v2/features/weekly/repository/weekly_worship_repository.dart';
import 'package:holysong_weekly_v2/features/weekly/service/weekly_worship_service.dart';

extension WeeklyWorshipServiceUpdateAudio on WeeklyWorshipService {
  /// updateAudio(date, part, urls)
  /// - date: 'YYYY-MM-DD' 고정 형식
  /// - part: soprano|alto|tenor|bass|chrous
  /// - urls: 1..3, 빈 문자열 불가
  Future<WeeklyWorship> updateAudio({
    required String date,
    required String part,
    required List<String> urls,
  }) async {
    // 1) 입력 검증 — 형식과 스키마를 테스트로 고정한다.
    // 날짜 형식
    final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dateRegex.hasMatch(date)) {
      throw ArgumentError('date must be yyyy-mm-dd');
    }

    // 파트 허용 목록 (아키텍처 문서의 audios 스키마)
    const allowedParts = {'soprano', 'alto', 'tenor', 'bass', 'chrous'}; // 의도적 철자 그대로
    if (!allowedParts.contains(part)) {
      throw ArgumentError('invalid part: $part');
    }

    // urls: 1..3, 공백/빈 문자열 금지
    if (urls.isEmpty || urls.length > 3) {
      throw ArgumentError('urls must have 1..3 items');
    }
    if (urls.any((u) => u.trim().isEmpty)) {
      throw ArgumentError('urls cannot contain empty string');
    }

    // 2) 대상 주간 문서 로드 (없으면 실패)
    final before = await repository.fetch(date);
    if (before == null) {
      throw StateError('weekly($date) not found');
    }

    // 3) 지정된 part만 치환 — 나머지 파트/상위 필드는 보존
    final beforeAudios = Map<String, List<String>>.from(before.audios ?? {});
    // 모든 파트 키가 존재하도록 보정(빈 배열 기본값)
    for (final p in allowedParts) {
      beforeAudios.putIfAbsent(p, () => <String>[]);
    }
    final afterAudios = Map<String, List<String>>.from(beforeAudios);
    afterAudios[part] = List<String>.unmodifiable(urls);

    // 4) updatedAt 갱신 + 저장은 1회만
    final updated = before.copyWith(
      audios: afterAudios,
      updatedAt: DateTime.now(),
    );

    await repository.save(updated); // save 호출 1회

    // 5) 갱신 결과 반환
    return updated;
  }
}
