import 'package:flutter/material.dart';

class FullHistoryPage extends StatelessWidget {
  final List<String> fullHistory;

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
          return ListTile(
            title: Text(fullHistory[index]),
          );
        },
      ),
    );
  }
}
