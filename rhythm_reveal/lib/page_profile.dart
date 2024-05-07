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
        return ListTile(
          title: Text('${history.songName} by ${history.artist}'),
        );
      },
    );
  }
}
