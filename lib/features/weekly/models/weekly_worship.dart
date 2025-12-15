import 'package:cloud_firestore/cloud_firestore.dart';
import 'song_info.dart';

class WeeklyWorship {
  final String date;
  final String announcement;
  final String status; // 'draft' or 'published'
  final SongInfo song;
  final Map<String, List<String>> audios;
  final Map<String, String?> scores;
  final DateTime? updatedAt;

  WeeklyWorship({
    required this.date,
    this.announcement = '',
    this.status = 'draft',
    required this.song,
    Map<String, List<String>>? audios,
    Map<String, String?>? scores,
    this.updatedAt,
  })  : audios = audios ?? {},
        scores = scores ?? {};

  // --------------------------------------------------
  // Task 1 — fromMap (필수 필드 검증 + Firestore 타입 대응)
  // --------------------------------------------------
  factory WeeklyWorship.fromMap(Map<String, dynamic> map) {
    if (!map.containsKey('date')) {
      throw Exception('date field is required');
    }
    if (!map.containsKey('song')) {
      throw Exception('song field is required');
    }

    // audios : Map<String, List<String>>
    final audiosMap = Map<String, List<String>>.from(
      (map['audios'] ?? {}).map(
        (key, value) => MapEntry(
          key,
          List<String>.from(value ?? []),
        ),
      ),
    );

    // scores : Map<String, String?>
    final scoresMap = Map<String, String?>.from(map['scores'] ?? {});

    // updatedAt : String/Timestamp 대응
    DateTime? parsedUpdatedAt;
    if (map['updatedAt'] is String) {
      parsedUpdatedAt = DateTime.tryParse(map['updatedAt']);
    } else if (map['updatedAt'] is Timestamp) {
      parsedUpdatedAt = (map['updatedAt'] as Timestamp).toDate();
    }

    return WeeklyWorship(
      date: map['date'] ?? '',
      announcement: map['announcement'] ?? '',
      status: map['status'] ?? 'draft',
      song: SongInfo.fromMap(map['song'] ?? {}),
      audios: audiosMap,
      scores: scoresMap,
      updatedAt: parsedUpdatedAt,
    );
  }

  factory WeeklyWorship.fromJson(Map<String, dynamic> json) {
    return WeeklyWorship.fromMap(json);
  }

  // --------------------------------------------------
  // Task 2 — toMap() (Firestore 저장 최적화)
  // --------------------------------------------------
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'announcement': announcement.trim(),
      'status': status,
      'song': song.toMap(),

      // Firestore-friendly deep copy
      'audios': audios.map(
        (key, value) => MapEntry(key, List<String>.from(value)),
      ),

      'scores': scores.map(
        (key, value) => MapEntry(key, value ?? ''),
      ),

      // updatedAt은 Service layer에서 관리
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toJson() => toMap();

  // --------------------------------------------------
  // Task 3 — copyWith (Deep Copy + TDD 기준 충족)
  // --------------------------------------------------
  WeeklyWorship copyWith({
    String? date,
    String? announcement,
    String? status,
    SongInfo? song,
    Map<String, List<String>>? audios,
    Map<String, String?>? scores,
    DateTime? updatedAt,
  }) {
    final copiedAudios = audios != null
        ? audios.map((key, value) => MapEntry(key, List<String>.from(value)))
        : this.audios.map(
            (key, value) => MapEntry(key, List<String>.from(value)),
          );

    final copiedScores = scores != null
        ? scores.map((key, value) => MapEntry(key, value))
        : this.scores.map((key, value) => MapEntry(key, value));

    return WeeklyWorship(
      date: date ?? this.date,
      announcement: announcement ?? this.announcement,
      status: status ?? this.status,
      song: song ?? this.song.copyWith(),
      audios: copiedAudios,
      scores: copiedScores,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // --------------------------------------------------
  // 출판(Publish) 가능 여부
  // --------------------------------------------------
  bool isCompleteForPublish() {
    if (announcement.isEmpty) return false;
    if (song.title.isEmpty) return false;

    // audio 최대 3개 제한
    final audiosValid = audios.values.every((urls) => urls.length <= 3);
    if (!audiosValid) return false;

    const requiredParts = [
      'conductor',
      'choir',
      'horn',
      'bassoon',
      'clarinet',
      'oboe',
      'flute',
    ];

    final hasAllScores = requiredParts.every((part) {
      final url = scores[part];
      return url != null && url.isNotEmpty;
    });

    return hasAllScores;
  }
}
