import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rhythm_reveal/globals.dart' as globals;
import 'package:rhythm_reveal/models.dart';

import 'package:rhythm_reveal/models.dart' as models;
import 'package:rhythm_reveal/page_history.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Stream<UserProfile>? _userProfileStream;

  @override
  void initState() {
    super.initState();
    _userProfileStream = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: globals.currentUser)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        throw Exception('User not found with email ${globals.currentUser}');
      }
      return UserProfile.fromFirestore(
          snapshot.docs.first.data()! as Map<String, dynamic>);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserProfile>(
      stream: _userProfileStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (snapshot.hasData) {
          return buildUserProfilePage(snapshot.data!);
        } else {
          return const Text("No data available");
        }
      },
    );
  }

  Widget buildUserProfilePage(UserProfile profile) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
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
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage('assets/profile_placeholder.png'),
                        ),
                        const SizedBox(height: 16),
                        const SizedBox(height: 16),
                        YesterdayBumpSection(fullHistory: profile.fullHistory),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child:
                        FavoriteSongsSection(favoriteSongs: profile.topThree),
                  ),
                ],
              ),
              Container(
                height: 300,
                child: FullHistorySection(
                  fullHistory: profile.fullHistory,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FullHistoryPage()),
                  );
                },
                child: const Text('View Full History'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
        if (favoriteSongs.isEmpty)
          const Text("No favorite songs added yet.",
              style: TextStyle(fontSize: 14))
        else
          ...favoriteSongs
              .map((song) => Card(
                    child: ListTile(
                      title: Text('${song.title}'),
                      subtitle: Text('${song.artist}'),
                    ),
                  ))
              .toList(),
      ],
    );
  }
}

class FullHistorySection extends StatelessWidget {
  final List<models.SongHistory> fullHistory;

  const FullHistorySection({super.key, required this.fullHistory});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: fullHistory.length,
      itemBuilder: (context, index) {
        final history = fullHistory[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          elevation: 4, // Adds shadow effect
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            title: Text(
              history.songName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            subtitle: Text(
              history.artist,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ),
        );
      },
    );
  }
}

class YesterdayBumpSection extends StatelessWidget {
  final List<models.SongHistory> fullHistory;

  const YesterdayBumpSection({Key? key, required this.fullHistory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (fullHistory.isNotEmpty) {
      models.SongHistory lastSong = fullHistory.first;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Yesterday's Bump",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.lightBlue[50],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lastSong.songName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  lastSong.artist,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Yesterday's Bump",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "No songs played yesterday.",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      );
    }
  }
}
