import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Importing google fonts package
import 'package:rhythm_reveal/page_profile.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      title: 'Rhythm Reveal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
          backgroundColor: Colors.deepPurple,
          accentColor: Colors.purpleAccent,
        ),
         // Use the default Material typography from 2021
        typography: Typography.material2021(),
        // text styles for headlines and body text
        textTheme: GoogleFonts.aBeeZeeTextTheme(textTheme).copyWith(
          displayLarge: GoogleFonts.aBeeZee(fontSize: 24, fontWeight: FontWeight.bold), // Headline 1
          displayMedium: GoogleFonts.aBeeZee(fontSize: 20, fontWeight: FontWeight.bold), // Headline 2
          displaySmall: GoogleFonts.aBeeZee(fontSize: 18, fontWeight: FontWeight.bold), // Headline 3
          bodyLarge: GoogleFonts.yantramanav(fontSize: 16), // Body text
          bodySmall: GoogleFonts.yantramanav(fontSize: 14), // Alternative body text
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePageContent(),
    ProfilePage(),
    //SettingsPage(),
    //BumpHistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rhythm Reveal'),
      ),
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

class HomePageContent extends StatelessWidget {
  const HomePageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Home Page Content'),
    );
  }
}
