import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rhythm_reveal/globals.dart' as globals;
import 'package:rhythm_reveal/models.dart';

class FullHistoryPage extends StatefulWidget {
  const FullHistoryPage({Key? key}) : super(key: key);

  @override
  _FullHistoryPageState createState() => _FullHistoryPageState();
}

class _FullHistoryPageState extends State<FullHistoryPage> {
  late Stream<List<SongHistory>> _songHistoryStream;

  @override
  void initState() {
    super.initState();
    _songHistoryStream = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: globals.currentUser) 
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) {
            throw Exception('User not found with email ${globals.currentUser}');
          }
          var userDoc = snapshot.docs.first;
          var fullHistory = userDoc.data()['fullHistory'] as List<dynamic> ?? [];
          return fullHistory.map((historyData) => SongHistory.fromFirestore(historyData as Map<String, dynamic>)).toList();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Full History'),
      ),
      body: StreamBuilder<List<SongHistory>>(
        stream: _songHistoryStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var history = snapshot.data![index];
                return ListTile(
                  title: Text('${history.songName} by ${history.artist}'),
                );
              },
            );
          } else {
            return const Text("No history available");
          }
        },
      ),
    );
  }
}
