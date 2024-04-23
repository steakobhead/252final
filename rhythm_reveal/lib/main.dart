import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Importing google fonts package

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
          backgroundColor: Colors.grey,
          accentColor: Colors.amber,
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
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
