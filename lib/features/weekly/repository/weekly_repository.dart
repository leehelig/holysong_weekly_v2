import 'dart:typed_data';
import '../models/weekly_worship.dart';

abstract class WeeklyRepository {
  /// 단일 문서 읽기
  Future<WeeklyWorship?> fetch(String date);

  /// 실시간 변경 감지
  Stream<WeeklyWorship?> watch(String date);

  /// 저장 (draft/publish 포함)
  Future<void> save(WeeklyWorship weekly);

  /// 악보 PDF 업로드 (Storage → URL 반환)
  Future<String> uploadScorePdf({
    required String date,
    required String instrument,
    required Uint8List fileBytes,
  });
}
