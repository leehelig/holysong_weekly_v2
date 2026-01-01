// lib/features/weekly/repositories/weekly_worship_repository.dart
import '../models/weekly_worship.dart';

abstract class WeeklyWorshipRepository {
  Future<WeeklyWorship> fetch(String date);
  Stream<WeeklyWorship> watch(String date);
  Future<void> save(WeeklyWorship weekly);
  Future<String> uploadScorePdf(
    String date,
    String instrument,
    List<int> bytes,
  );
}
