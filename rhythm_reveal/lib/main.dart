import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Importing google fonts package
import 'package:rhythm_reveal/page_auth.dart';

void main() {
  runApp(const MainApp());
}

Map<int, Color> color =
{
50:Color.fromRGBO(136,14,79, .1),
100:Color.fromRGBO(136,14,79, .2),
200:Color.fromRGBO(136,14,79, .3),
300:Color.fromRGBO(136,14,79, .4),
400:Color.fromRGBO(136,14,79, .5),
500:Color.fromRGBO(136,14,79, .6),
600:Color.fromRGBO(136,14,79, .7),
700:Color.fromRGBO(136,14,79, .8),
800:Color.fromRGBO(136,14,79, .9),
900:Color.fromRGBO(136,14,79, 1),
};
MaterialColor colorCustom = MaterialColor(0xFF880E4F, color);


class MainApp extends StatelessWidget {
  const MainApp({super.key});
  

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
      home: const AuthPage(),
    );
  }
}

