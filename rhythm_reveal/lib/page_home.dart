import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rhythm_reveal/page_profile.dart';
import 'package:rhythm_reveal/page_settings.dart';
import 'package:rhythm_reveal/globals.dart' as globals;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _buildPostsPage(),
      const ProfilePage(),
      const SettingsPage(),
    ];
  }

  Widget _buildPostsPage() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No posts available.');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          padding: const EdgeInsets.all(8),
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            String songName = data['songName'] ?? 'No song name';
            String artist = data['artist'] ?? 'Unknown artist';
            List<dynamic> comments = data['comments'] ?? [];
            String linkedUser = data['linkedUser'] ?? 'Anonymous';

            return Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                title: Text(songName,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Artist: $artist'),
                    Text('Linked User: $linkedUser'),
                    SizedBox(height: 10),
                    Text('Comments:'),
                    ...comments
                        .map((comment) =>
                            Text(comment, style: TextStyle(fontSize: 14)))
                        .toList(),
                    TextButton(
                        onPressed: () => _addComment(document.id),
                        child: Text("Add Comment")),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void _showAddPostDialog() {
    final _formKey = GlobalKey<FormState>();
    String artist = '';
    String songName = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Post'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Artist'),
                  onSaved: (value) => artist = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter an artist name' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Song Name'),
                  onSaved: (value) => songName = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a song name' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Add Post'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  DocumentReference postRef =
                      await FirebaseFirestore.instance.collection('posts').add({
                    'artist': artist,
                    'songName': songName,
                    'comments': [],
                    'linkedUser': globals.username,
                  });

                  DocumentSnapshot userDoc = await FirebaseFirestore.instance
                      .collection('users')
                      .where('username', isEqualTo: globals.username)
                      .limit(1)
                      .get()
                      .then((snapshot) => snapshot.docs.first);

                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(userDoc.id)
                      .update({
                    'fullHistory': FieldValue.arrayUnion([
                      {'artist': artist, 'songName': songName}
                    ])
                  });

                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _addComment(String postId) {
    final TextEditingController _commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add a comment'),
          content: TextField(
            controller: _commentController,
            decoration: InputDecoration(hintText: "Type your comment here"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_commentController.text.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection('posts')
                      .doc(postId)
                      .update({
                    'comments': FieldValue.arrayUnion([_commentController.text])
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Post Comment'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPostDialog,
        child: const Icon(Icons.add),
        tooltip: 'Add Post',
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
