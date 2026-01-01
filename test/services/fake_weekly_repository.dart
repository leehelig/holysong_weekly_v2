import 'package:holysong_weekly_v2/features/weekly/models/weekly_worship.dart';
import 'package:holysong_weekly_v2/features/weekly/repository/weekly_worship_repository.dart';

class FakeWeeklyRepository implements WeeklyWorshipRepository {
  final List<WeeklyWorship> saved = [];
  int saveCalls = 0;

  @override
  Future<void> save(WeeklyWorship weekly) async {
    saveCalls += 1;
    saved.add(weekly);
  }

  // 테스트에 불필요한 메서드는 던지기
  @override
  Future<WeeklyWorship> fetch(String date) => throw UnimplementedError();
  @override
  Stream<WeeklyWorship> watch(String date) => throw UnimplementedError();
  @override
  Future<String> uploadScorePdf(String date, String instrument, List<int> bytes)
      => throw UnimplementedError();
}
