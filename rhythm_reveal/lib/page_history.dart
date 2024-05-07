import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rhythm_reveal/globals.dart' as globals;

class SongHistory {
  final String songName;
  final String artist;
  final DateTime dateListened;

  SongHistory({
    required this.songName,
    required this.artist,
    required this.dateListened,
  });

  factory SongHistory.fromFirestore(Map<String, dynamic> data) {
    return SongHistory(
      songName: data['songName'] as String,
      artist: data['artist'] as String,
      dateListened: (data['dateListened'] as Timestamp).toDate(),
    );
  }
}

class FullHistoryPage extends StatefulWidget {
  const FullHistoryPage({Key? key}) : super(key: key);

  @override
  _FullHistoryPageState createState() => _FullHistoryPageState();
}

class _FullHistoryPageState extends State<FullHistoryPage> {
  late Future<List<SongHistory>> _fullHistoryFuture;

  @override
  void initState() {
    super.initState();
    _fullHistoryFuture = loadFullHistory();
  }

  Future<List<SongHistory>> loadFullHistory() async {
    var collection = FirebaseFirestore.instance
        .collection('users')
        .doc(globals.currentUser)
        .collection('fullHistory');
    var snapshot = await collection.get();

    return snapshot.docs
        .map((doc) =>
            SongHistory.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Full History'),
      ),
      body: FutureBuilder<List<SongHistory>>(
        future: _fullHistoryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  SongHistory history = snapshot.data![index];
                  return ListTile(
                    title: Text('${history.songName} by ${history.artist}'),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}