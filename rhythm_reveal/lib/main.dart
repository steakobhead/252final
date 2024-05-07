import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rhythm_reveal/firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rhythm_reveal/page_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

Map<int, Color> color = {
  50: const Color.fromRGBO(136, 14, 79, .1),
  100: const Color.fromRGBO(136, 14, 79, .2),
  200: const Color.fromRGBO(136, 14, 79, .3),
  300: const Color.fromRGBO(136, 14, 79, .4),
  400: const Color.fromRGBO(136, 14, 79, .5),
  500: const Color.fromRGBO(136, 14, 79, .6),
  600: const Color.fromRGBO(136, 14, 79, .7),
  700: const Color.fromRGBO(136, 14, 79, .8),
  800: const Color.fromRGBO(136, 14, 79, .9),
  900: const Color.fromRGBO(136, 14, 79, 1),
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
