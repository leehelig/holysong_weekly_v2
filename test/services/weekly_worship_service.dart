*** Apply this patch to your repo ***

--- a/lib/features/weekly/services/weekly_worship_service.dart
+++ b/lib/features/weekly/services/weekly_worship_service.dart
@@
 // (ensure this import exists; add it if missing)
+import 'package:holysong_weekly_v2/features/weekly/models/weekly_worship.dart';
@@
 class WeeklyWorshipService {
   // ... existing fields/ctors/methods ...
+
+  /// Updates only the song fields for a given date and returns the updated entity.
+  Future<WeeklyWorship> updateSong(String date, Song song) async {
+    // 1) validate inputs
+    if (date.trim().isEmpty) {
+      throw ArgumentError('date must not be empty');
+    }
+    if (song.title.trim().isEmpty) {
+      throw ArgumentError('song.title must not be empty');
+    }
+
+    // 2) fetch existing document (normalize to StateError if not found)
+    WeeklyWorship existing;
+    try {
+      existing = await repository.fetch(date);
+      // some repos might return null instead of throwing
+      // ignore: unnecessary_null_comparison
+      if (existing == null) {
+        throw StateError('weekly worship not found for date=$date');
+      }
+    } catch (_) {
+      throw StateError('weekly worship not found for date=$date');
+    }
+
+    // 3) merge: update only provided song fields; keep others
+    final mergedSong = Song(
+      title: song.title.trim(),
+      composer: song.composer ?? existing.song.composer,
+      arranger: song.arranger ?? existing.song.arranger,
+    );
+
+    final updated = existing.copyWith(
+      song: mergedSong,
+      updatedAt: DateTime.now(),
+    );
+
+    // 4) persist exactly once
+    await repository.save(date, updated);
+    return updated;
+  }
 }
