import 'dart:typed_data';

import 'package:holysong_weekly_v2/features/weekly/models/weekly_worship.dart';
import 'package:holysong_weekly_v2/features/weekly/services/weekly_worship_service.dart';

/// 실제 서비스 확장: updateScore
/// - 입력 검증(날짜/악기/바이트)
/// - repository.uploadScorePdf 호출
/// - updatedAt 갱신 후 repository.save 1회
extension WeeklyWorshipServiceUpdateScore on WeeklyWorshipService {
  Future<WeeklyWorship> updateScore({
    required String date,
    required String instrument,
    required Uint8List fileBytes,
  }) async {
    // 날짜 형식 검증
    final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dateRegex.hasMatch(date)) {
      throw ArgumentError('date must be yyyy-mm-dd');
    }

    // 허용 악기 목록(아키텍처/테스트 기준)
    const allowedInstruments = {
      'conductor', 'choir', 'horn', 'bassoon', 'clarinet', 'oboe', 'flute',
    };
    if (!allowedInstruments.contains(instrument)) {
      throw ArgumentError('invalid instrument: $instrument');
    }

    if (fileBytes.isEmpty) {
      throw ArgumentError('fileBytes cannot be empty');
    }

    // 존재 문서 로드(없으면 StateError 전파)
    final before = await repository.fetch(date);

    // 업로드 후(updatedAt만 갱신 저장 — 모델에 scores 필드가 없다면 URL 저장은 생략)
    await repository.uploadScorePdf(
      date,
      instrument,
      fileBytes, // List<int>로 암시적 변환 허용
    );

    final updated = before.copyWith(updatedAt: DateTime.now());
    await repository.save(updated);
    return updated;
  }
}
