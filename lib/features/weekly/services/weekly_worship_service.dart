import '../models/weekly_worship.dart';
import '../repository/weekly_worship_repository.dart';

class WeeklyWorshipService {
  final WeeklyWorshipRepository repository;
  WeeklyWorshipService({required this.repository});

  Future<WeeklyWorship> publish(WeeklyWorship weekly) async {
    // 1) 도메인 검증 (null-safe)
    final announcement = (weekly.announcement ?? '').trim();
    if (announcement.length > 200) {
      throw ArgumentError('announcement length > 200');
    }
    if (weekly.song.title.trim().isEmpty) {
      throw ArgumentError('song.title is required');
    }
    if (weekly.status == 'published') {
      throw StateError('already published');
    }

    // 2) 상태 전이 + 타임스탬프
    final now = DateTime.now();
    final updated = weekly.copyWith(
      status: 'published',
      updatedAt: now,
      // announcement를 트림된 값으로 고정하고 싶다면 다음 줄 활성화:
      // announcement: announcement,
    );

    // 3) 저장 위임
    await repository.save(updated);
    return updated;
  }

// ✅ Task 22 — updateAnnouncement
  Future<WeeklyWorship> updateAnnouncement(String date, String text) async {
    final trimmed = text.trim();
    if (trimmed.length > 200) {
      throw ArgumentError('announcement length > 200');
    }

    // 존재 문서만 업데이트
    final current = await repository.fetch(date);

    final updated = current.copyWith(
      announcement: trimmed,
      updatedAt: DateTime.now(),
    );

    await repository.save(updated);
    return updated;
  }

}
