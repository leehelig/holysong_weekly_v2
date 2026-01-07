// Path: lib/features/weekly/services/weekly_worship_service_update_song.dart
// Adds updateSong() to WeeklyWorshipService via extension — no need to edit the class body.

import 'package:holysong_weekly_v2/features/weekly/models/weekly_worship.dart';
import 'package:holysong_weekly_v2/features/weekly/services/weekly_worship_service.dart';

extension WeeklyWorshipServiceSong on WeeklyWorshipService {
  /// Updates only the song fields for a given date and returns the updated entity.
  Future<WeeklyWorship> updateSong(String date, Song song) async {
    // 1) validate inputs
    if (date.trim().isEmpty) {
      throw ArgumentError('date must not be empty');
    }
    if (song.title.trim().isEmpty) {
      throw ArgumentError('song.title must not be empty');
    }

    // 2) fetch existing document (throw if missing)
    final existing = await repository.fetch(date);
    if (existing == null) {
      throw StateError('weekly worship not found for date=$date');
    }

    // 3) merge: update only provided song fields; keep others
    final mergedSong = Song(
      title: song.title.trim(),
      composer: song.composer ?? existing.song.composer,
      arranger: song.arranger ?? existing.song.arranger,
    );

    final updated = existing.copyWith(
      song: mergedSong,
      updatedAt: DateTime.now(),
    );

    // 4) persist exactly once
    await repository.save(updated);


    return updated;
  }
}
