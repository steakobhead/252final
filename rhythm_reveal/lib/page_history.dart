import 'package:flutter/material.dart';
import 'package:rhythm_reveal/song_history.dart';

class FullHistoryPage extends StatelessWidget {
  final List<SongHistory> fullHistory;

  // Constructor to accept the full history data
  const FullHistoryPage({super.key, required this.fullHistory});

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
          return ListTile(
            title: Text(displayText),
          );
        },
      ),
    );
  }
}
