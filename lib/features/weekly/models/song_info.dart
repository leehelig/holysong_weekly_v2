class SongInfo {
  final String title;          // 필수
  final String? composer;      // Optional
  final String? arranger;      // Optional

  SongInfo({
    required this.title,
    this.composer,
    this.arranger,
  });

  // ---------------------------------------------
  // fromMap (TDD-friendly: 최소 구조만 강제)
  // ---------------------------------------------
  factory SongInfo.fromMap(Map<String, dynamic> map) {
    return SongInfo(
      title: map['title'] ?? '',
      composer: map['composer'] as String?,
      arranger: map['arranger'] as String?,
    );
  }

  // JSON alias
  factory SongInfo.fromJson(Map<String, dynamic> json) {
    return SongInfo.fromMap(json);
  }

  // ---------------------------------------------
  // toMap
  // ---------------------------------------------
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'composer': composer,
      'arranger': arranger,
    };
  }

  Map<String, dynamic> toJson() => toMap();

  // ---------------------------------------------
  // copyWith — Null-intent 지원 완성형
  //
  // 1) 인자를 아예 전달하지 않으면 기존값 유지
  // 2) 전달된 인자가 null이면 실제로 null로 리셋
  // ---------------------------------------------
  SongInfo copyWith({
    String? title,
    String? composer,
    String? arranger,
    bool composerToNull = false,
    bool arrangerToNull = false,
  }) {
    return SongInfo(
      title: title ?? this.title,

      // composer:  
      //  - composerToNull == true → null로 설정
      //  - composer != null → 새로운 값
      //  - 둘 다 아니면 기존값 유지
      composer: composerToNull
          ? null
          : (composer != null ? composer : this.composer),

      // arranger 동일 패턴
      arranger: arrangerToNull
          ? null
          : (arranger != null ? arranger : this.arranger),
    );
  }
}
