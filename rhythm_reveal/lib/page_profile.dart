import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rhythm_reveal/globals.dart' as globals;
import 'package:rhythm_reveal/models.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<UserProfile> _userProfileFuture;

  @override
  void initState() {
    super.initState();
    _userProfileFuture = _loadUserData();
  }

  Future<UserProfile> _loadUserData() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: globals.currentUser)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      throw Exception('User not found with email ${globals.currentUser}');
    }

    DocumentSnapshot userDoc = snapshot.docs.first;
    return UserProfile.fromFirestore(userDoc.data()! as Map<String, dynamic>);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile>(
      future: _userProfileFuture,
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
                          ),
                        ),
                        const SizedBox(height: 8),
                        const CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage('assets/profile_placeholder.png'),
                        ),
                        const SizedBox(height: 16),
                        FavoriteSongsSection(favoriteSongs: profile.topThree),
                        const SizedBox(height: 16),
                        Container(
                          height: 300,
                          child: FullHistorySection(
                              fullHistory: profile.fullHistory),
                        ),
                      ],
                    ),
                  ),
                ],
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

class FullHistorySection extends StatelessWidget {
  final List<SongHistory> fullHistory;

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
