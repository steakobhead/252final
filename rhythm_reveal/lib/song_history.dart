class SongHistory {
  final String songName;
  final String artist;

  SongHistory({required this.songName, required this.artist});

  factory SongHistory.fromJson(Map<String, dynamic> json) {
    return SongHistory(
      songName: json['songName'],
      artist: json['artist'],
    );
  }
}