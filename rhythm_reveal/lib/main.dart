import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rhythm_reveal/firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rhythm_reveal/page_auth.dart';
import 'package:rhythm_reveal/page_home.dart';
import 'package:rhythm_reveal/page_profile.dart';
import 'package:rhythm_reveal/page_settings.dart';
import 'package:nowplaying/nowplaying.dart';
import 'package:provider/provider.dart';
import 'package:nowplaying/nowplaying_track.dart';







void main() async{
  await NowPlaying.instance.start(
    resolveImages: false,
    spotifyClientId: 'xxxx',
    spotifyClientSecret: 'xxxx',
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}


Map<int, Color> color =
{
50:const Color.fromRGBO(136,14,79, .1),
100:const Color.fromRGBO(136,14,79, .2),
200:const Color.fromRGBO(136,14,79, .3),
300:const Color.fromRGBO(136,14,79, .4),
400:const Color.fromRGBO(136,14,79, .5),
500:const Color.fromRGBO(136,14,79, .6),
600:const Color.fromRGBO(136,14,79, .7),
700:const Color.fromRGBO(136,14,79, .8),
800:const Color.fromRGBO(136,14,79, .9),
900:const Color.fromRGBO(136,14,79, 1),
};
MaterialColor colorCustom = MaterialColor(0xFF880E4F, color);

class MainApp extends StatelessWidget {
  const MainApp({Key? key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      title: 'Rhythm Reveal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: colorCustom,
          backgroundColor: Colors.deepPurple,
          accentColor: Colors.purpleAccent,
        ),
        typography: Typography.material2021(),
        textTheme: GoogleFonts.aBeeZeeTextTheme(textTheme).copyWith(
          displayLarge:
              GoogleFonts.aBeeZee(fontSize: 24, fontWeight: FontWeight.bold),
          displayMedium:
              GoogleFonts.aBeeZee(fontSize: 20, fontWeight: FontWeight.bold),
          displaySmall:
              GoogleFonts.aBeeZee(fontSize: 18, fontWeight: FontWeight.bold),
          bodyLarge: GoogleFonts.yantramanav(fontSize: 16),
          bodySmall: GoogleFonts.yantramanav(fontSize: 14),
        ),
      ),
      home: const AuthPage(),
    );
  }
}

List<Post> loadPostsFromJson(String jsonString) {
  final parsed = jsonDecode(jsonString).cast<Map<String, dynamic>>();
  return parsed.map<Post>((json) => Post.fromJson(json)).toList();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ProfilePage(),
    const SettingsPage(),
    //BumpHistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const[
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
            label: 'Settings'),
        ]
      ),
    );
  }
}