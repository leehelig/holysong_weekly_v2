import '../models/weekly_worship.dart';
import '../models/song_info.dart';
import '../repository/weekly_repository.dart';

class WeeklyWorshipService {
  final WeeklyRepository repository;

  WeeklyWorshipService(this.repository);

  // ---------------------------------------------
  // Task 18 — load(date)
  // ---------------------------------------------
  Future<WeeklyWorship> load(String date) async {
    if (date.trim().isEmpty) {
      throw ArgumentError('date is empty');
    }

    final result = await repository.fetch(date);

    if (result == null) {
      throw StateError('WeeklyWorship not found for $date');
    }

    return result;
  }

  // ---------------------------------------------
  // Task 19 — watch(date)
  // ---------------------------------------------
  Stream<WeeklyWorship?> watch(String date) {
    if (date.trim().isEmpty) {
      throw ArgumentError('date is empty');
    }
    return repository.watch(date);
  }

  // ---------------------------------------------
  // Task 20 — saveDraft(weekly)
  // 비즈니스 규칙:
  // - announcement ≤ 200자
  // - song.title 필수
  // ---------------------------------------------
  Future<void> saveDraft(WeeklyWorship weekly) async {
    // 1) announcement 길이 검증
    if (weekly.announcement.length > 200) {
      throw ArgumentError('announcement must be 200 characters or fewer');
    }

    // 2) 제목 필수 검증
    if (weekly.song.title.trim().isEmpty) {
      throw ArgumentError('song title is required');
    }

    // 3) 저장
    await repository.save(weekly);
  }

  // ---------------------------------------------
  // Task 21 — publish(weekly)
  // ---------------------------------------------
  Future<void> publish(WeeklyWorship weekly) async {
    if (!weekly.isCompleteForPublish()) {
      throw Exception('Cannot publish: Required fields missing');
    }

    final published = weekly.copyWith(
      status: 'published',
      updatedAt: DateTime.now(),
    );

    await repository.save(published);
  }

  // ---------------------------------------------
  // Task 22 — updateAnnouncement
  // ---------------------------------------------
  WeeklyWorship updateAnnouncement(
    WeeklyWorship weekly,
    String value,
  ) {
    return weekly.copyWith(announcement: value.trim());
  }

  // ---------------------------------------------
  // Task 23 — updateSong
  // ---------------------------------------------
  WeeklyWorship updateSong(
    WeeklyWorship weekly,
    SongInfo song,
  ) {
    return weekly.copyWith(song: song);
  }

  // ---------------------------------------------
  // Task 24 — updateAudio
  // ---------------------------------------------
  WeeklyWorship updateAudio(
    WeeklyWorship weekly,
    String part,
    List<String> urls,
  ) {
    if (urls.length > 3) {
      throw Exception('Audio cannot exceed 3 files per part');
    }

    final newAudios = Map<String, List<String>>.from(weekly.audios);
    newAudios[part] = List<String>.from(urls);

    return weekly.copyWith(audios: newAudios);
  }

  // ---------------------------------------------
  // Task 25 — updateScore
  // ---------------------------------------------
  WeeklyWorship updateScore(
    WeeklyWorship weekly,
    String part,
    String? url,
  ) {
    final newScores = Map<String, String?>.from(weekly.scores);
    newScores[part] = url;

    return weekly.copyWith(scores: newScores);
  }
}
