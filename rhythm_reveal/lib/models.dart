class Song {
   String title;
   String artist;
   String genre;
   int year;
   String album;

  Song({
    required this.title,
    required this.artist,
    required this.genre,
    required this.year,
    required this.album,
  });

  factory Song.fromFirestore(Map<String, dynamic> data) {
    return Song(
      title: data['title'],
      artist: data['artist'],
      genre: data['genre'],
      year: data['year'],
      album: data['album'],
    );
  }

  factory Song.fromMap(Map<String, dynamic> data) {
    return Song(
      title: data['title'],
      artist: data['artist'],
      album: data['album'],
      genre: data['genre'],
      year: data['year'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'artist': artist,
      'album': album,
      'genre': genre,
      'year': year,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'artist': artist,
      'album': album,
      'genre': genre,
      'year': year,
    };
  }
}

class SongHistory {
  final String songName;
  final String artist;

  SongHistory({
    required this.songName,
    required this.artist,
  });

  factory SongHistory.fromFirestore(Map<String, dynamic> data) {
    return SongHistory(
      songName: data['songName'],
      artist: data['artist'],
    );
  }
}

class UserProfile {
  final String email;
  final String username;
  final List<Song> topThree;
  final List<SongHistory> fullHistory;

  UserProfile({
    required this.email,
    required this.username,
    required this.topThree,
    required this.fullHistory,
  });

  factory UserProfile.fromFirestore(Map<String, dynamic> data) {
    List<Song> topThree = List.from(data['topThree'])
        .map((item) => Song.fromFirestore(item as Map<String, dynamic>))
        .toList();
    List<SongHistory> fullHistory = List.from(data['fullHistory'])
        .map((item) => SongHistory.fromFirestore(item as Map<String, dynamic>))
        .toList();

    return UserProfile(
      email: data['email'],
      username: data['username'],
      topThree: topThree,
      fullHistory: fullHistory,
    );
  }
}
