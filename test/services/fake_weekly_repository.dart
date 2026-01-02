import 'package:holysong_weekly_v2/features/weekly/models/weekly_worship.dart';
import 'package:holysong_weekly_v2/features/weekly/repository/weekly_worship_repository.dart';

class FakeWeeklyRepository implements WeeklyWorshipRepository {
  // 가짜 DB (date 키로 관리)
  final Map<String, WeeklyWorship> data = {};

  // 저장 호출 기록
  final List<WeeklyWorship> saved = [];
  int saveCalls = 0;

  // 마지막으로 접근한 키(서비스가 fetch(date) 후 save(updated) 호출한다고 가정)
  String? _lastKey;

  // 테스트 시작 전 seed
  void seed(String date, WeeklyWorship weekly) {
    data[date] = weekly;
  }

  @override
  Future<WeeklyWorship> fetch(String date) async {
    final w = data[date];
    if (w == null) throw StateError('not found: $date');
    _lastKey = date;
    return w;
  }

  @override
  Stream<WeeklyWorship> watch(String date) => throw UnimplementedError();

  @override
  Future<void> save(WeeklyWorship weekly) async {
    saveCalls += 1;
    saved.add(weekly);
    if (_lastKey != null) {
      data[_lastKey!] = weekly; // fetch한 동일 키에 덮어쓰기
    }
  }

  @override
  Future<String> uploadScorePdf(String date, String instrument, List<int> bytes)
      => throw UnimplementedError();
}
