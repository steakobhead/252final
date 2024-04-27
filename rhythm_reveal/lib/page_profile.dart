//page_profile.dart

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
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
                        'Username',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      CircleAvatar(
                        radius: 50,
                        // Placeholder image for profile picture
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
                SizedBox(width: 16), // Add some spacing between sections
                Expanded(
                  child: FavoriteSongsSection(),
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
                            // Handle click on "View Full History"
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
                    // Add bump history content here
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

class FavoriteSongsSection extends StatelessWidget {
  const FavoriteSongsSection({super.key});

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
        const SizedBox(height: 8,),
        //add input stuff here for favorite songs
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Song 1',
          ),
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Song 2',
          ),
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Song 3',
          ),
        ),
      ],
    );
  }
}

class YesterdayBumpSection extends StatelessWidget {
  const YesterdayBumpSection({super.key});

  @override
  Widget build(BuildContext context) {
    //REPLACE WITH ACTUAL CONTENT AFTER
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