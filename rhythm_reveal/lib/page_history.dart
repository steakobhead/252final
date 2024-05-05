import 'package:flutter/material.dart';
import 'package:rhythm_reveal/song_history.dart';

class FullHistoryPage extends StatelessWidget {
  final List<SongHistory> fullHistory;

  // Constructor to accept the full history data
  const FullHistoryPage({Key? key, required this.fullHistory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Full History'),
      ),
      body: ListView.builder(
        itemCount: fullHistory.length,
        itemBuilder: (context, index) {
          // Creating a text representation that includes both the song name and artist
          String displayText =
              "${fullHistory[index].songName} by ${fullHistory[index].artist}";
          return Card(
            child: ListTile(
              leading: Icon(Icons.music_note), // You can use any icon here
              title: Text(fullHistory[index].songName),
              subtitle: Text(fullHistory[index].artist),
              onTap: () {
                // Add onTap functionality here if needed
              },
            ),
          );
        },
      ),
    );
  }
}