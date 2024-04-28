import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:rhythm_reveal/page_history.dart';

// Model Classes
class UserProfile {
  final String email;
  final String username;
  final String password;
  final List<Song> topThree;
  final List<String> fullHistory;

  UserProfile({required this.email, required this.username, required this.password, required this.topThree, required this.fullHistory});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    var topThreeFromJson = json['topThree'] as List;
    List<Song> topThreeList = topThreeFromJson.map((i) => Song.fromJson(i.values.first)).toList();

    return UserProfile(
      email: json['email'],
      username: json['username'],
      password: json['password'],
      topThree: topThreeList,
      fullHistory: List<String>.from(json['fullHistory']),
    );
  }
}

class Song {
  final String title;
  final String artist;
  final String genre;
  final int year;
  final String album;

  Song({required this.title, required this.artist, required this.genre, required this.year, required this.album});

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

// Profile Page Widget
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<UserProfile> userProfile;

  @override
  void initState() {
    super.initState();
    userProfile = loadUserData();
  }

  Future<UserProfile> loadUserData() async {
    final String response = await rootBundle.loadString('assets/users.json');
    final data = json.decode(response) as List;
    return UserProfile.fromJson(data.first);
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
        return CircularProgressIndicator();
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
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/profile_placeholder.png'),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Yesterday's Bump",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      YesterdayBumpSection(),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: FavoriteSongsSection(favoriteSongs: profile.topThree),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF5F0F40),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
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
                              MaterialPageRoute(builder: (context) => FullHistoryPage(fullHistory: profile.fullHistory)),
                            );
                          },
                          child: Row(children: <Widget>[
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
                    SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: profile.fullHistory.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              profile.fullHistory[index],
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
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

  const FavoriteSongsSection({Key? key, required this.favoriteSongs}) : super(key: key);

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
        ...favoriteSongs.map((song) => Text('${song.title} by ${song.artist}',
          style: TextStyle(
            fontSize: 14,
          ),
        )).toList(),
      ],
    );
  }
}

// Yesterday's Bump Section
class YesterdayBumpSection extends StatelessWidget {
  const YesterdayBumpSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Placeholder content for "Yesterday's Bump"
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Song Title',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Artist Name',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
