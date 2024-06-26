// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCZfweOEuDu8NT8jEsuWTla-EkDJ3fBTs0',
    appId: '1:1008180353302:web:af7a8f0033094068eb1837',
    messagingSenderId: '1008180353302',
    projectId: 'rhythmreveal-252',
    authDomain: 'rhythmreveal-252.firebaseapp.com',
    databaseURL: 'https://rhythmreveal-252-default-rtdb.firebaseio.com',
    storageBucket: 'rhythmreveal-252.appspot.com',
    measurementId: 'G-SRX3CKPD71',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD5M47El0ucYjgZjKDpkJABxJ-8xMu8N_M',
    appId: '1:1008180353302:android:a155603712d2fdf3eb1837',
    messagingSenderId: '1008180353302',
    projectId: 'rhythmreveal-252',
    databaseURL: 'https://rhythmreveal-252-default-rtdb.firebaseio.com',
    storageBucket: 'rhythmreveal-252.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCSuPpaHomqN26cJeqMVPdA5ntyPNBvl5I',
    appId: '1:1008180353302:ios:31591f90d0b70076eb1837',
    messagingSenderId: '1008180353302',
    projectId: 'rhythmreveal-252',
    databaseURL: 'https://rhythmreveal-252-default-rtdb.firebaseio.com',
    storageBucket: 'rhythmreveal-252.appspot.com',
    iosBundleId: 'com.example.rhythmReveal',
  );
}
