// lib/models/weekly_worship.dart
class Song {
  final String title;
  final String? composer;
  final String? arranger;

  const Song({required this.title, this.composer, this.arranger});

  Song copyWith({String? title, String? composer, String? arranger}) {
    return Song(
      title: title ?? this.title,
      composer: composer ?? this.composer,
      arranger: arranger ?? this.arranger,
    );
  }
}

class WeeklyWorship {
  final String status; // 'draft' | 'published'
  final String? announcement;
  final Song song;
  final DateTime updatedAt;

  const WeeklyWorship({
    required this.status,
    required this.song,
    required this.updatedAt,
    this.announcement,
  });

  WeeklyWorship copyWith({
    String? status,
    String? announcement,
    Song? song,
    DateTime? updatedAt,
  }) {
    return WeeklyWorship(
      status: status ?? this.status,
      announcement: announcement ?? this.announcement,
      song: song ?? this.song,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // 테스트용 샘플 데이터
  factory WeeklyWorship.sample() {
    return WeeklyWorship(
      status: 'draft',
      announcement: 'welcome',
      song: const Song(title: 'Hymn 1', composer: 'comp', arranger: 'arr'),
      updatedAt: DateTime.now(),
    );
  }
}
