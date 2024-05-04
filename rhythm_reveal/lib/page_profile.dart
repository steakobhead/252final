import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:rhythm_reveal/page_history.dart';
import 'package:rhythm_reveal/song_history.dart';
import 'package:rhythm_reveal/globals.dart' as globals;

// Model Classes

class UserProfile {
  final String email;
  final String username;
  final String password;
  final List<Song> topThree;
  final List<SongHistory> fullHistory;

  UserProfile({required this.email, required this.username, required this.password, required this.topThree, required this.fullHistory});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    var topThreeFromJson = json['topThree'] as List;
    List<Song> topThreeList = topThreeFromJson.map((i) => Song.fromJson(i.values.first)).toList();
    List<SongHistory> fullHistoryList = (json['fullHistory'] as List)
        .map((item) => SongHistory.fromJson(item))
        .toList();

    return UserProfile(
      email: json['email'],
      username: json['username'],
      password: json['password'],
      topThree: topThreeList,
      fullHistory: fullHistoryList,
    );
  }
}


class Song {
  final String title;
  final String artist;
  final String genre;
  final int year;
  final String album;

  Song(
      {required this.title,
      required this.artist,
      required this.genre,
      required this.year,
      required this.album});

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      title: json['title'],
      artist: json['artist'],
      genre: json['genre'],
      year: json['year'],
      album: json['album'],
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

// Profile Page Widget
class _ProfilePageState extends State<ProfilePage> {
  late Future<UserProfile> userProfile;

  @override
  void initState() {
    super.initState();
    userProfile = loadUserData();
  }

  Future<UserProfile> loadUserData() async {
    final String response = await rootBundle.loadString('assets/users.json');
    final List<dynamic> data = json.decode(response);
    final Map<String, dynamic> userJson = data.firstWhere(
            (user) =>
                user is Map<String, dynamic> &&
                user['email'] == globals.currentUser,
            orElse: () => throw Exception(
                'User not found with email ${globals.currentUser}'))
        as Map<String, dynamic>;

    return UserProfile.fromJson(userJson);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile>(
      future: userProfile,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return buildUserProfilePage(snapshot.data!);
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Widget buildUserProfilePage(UserProfile profile) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        profile.username,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            AssetImage('assets/profile_placeholder.png'),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Yesterday's Bump",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      YesterdayBumpSection(fullHistory: profile.fullHistory),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FavoriteSongsSection(favoriteSongs: profile.topThree),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF5F0F40),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Bump History",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FullHistoryPage(
                                      fullHistory: profile.fullHistory)),
                            );
                          },
                          child: const Row(
                            children: <Widget>[
                              Text(
                                "View Full History",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF993B74),
                                ),
                              ),
                              Icon(Icons.history, color: Color(0xFF993B74)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: profile.fullHistory.length,
                        itemBuilder: (context, index) {
                          SongHistory song = profile.fullHistory[index];
                          return ListTile(
                            title: Text(
                              '${song.songName} by ${song.artist}',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Favorite Songs Section
class FavoriteSongsSection extends StatelessWidget {
  final List<Song> favoriteSongs;

  const FavoriteSongsSection({super.key, required this.favoriteSongs});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          "Top 3 Favs",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...favoriteSongs.map((song) => Text(
              '${song.title} by ${song.artist}',
              style: const TextStyle(
                fontSize: 14,
              ),
            )),
      ],
    );
  }
}

class YesterdayBumpSection extends StatelessWidget {
  final List<SongHistory> fullHistory;

  const YesterdayBumpSection({super.key, required this.fullHistory});

  @override
  Widget build(BuildContext context) {
    // Assuming the most recent song is considered as "Yesterday's Bump"
    // Check if there is at least one song in the history
    if (fullHistory.isNotEmpty) {
      SongHistory lastSong = fullHistory.first; // You can change the logic to pick the song
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lastSong.songName, // Song title
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              lastSong.artist, // Artist name
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(); // Or any placeholder if no history is available
    }
  }
}