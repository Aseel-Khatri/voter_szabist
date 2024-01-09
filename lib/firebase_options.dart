// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyCrGA_s1hoSFrfWAh4thuXS9ote63rVKRk',
    appId: '1:470118869969:web:ccc8c139b3fb7feb12cef0',
    messagingSenderId: '470118869969',
    projectId: 'voter-1b17d',
    authDomain: 'voter-1b17d.firebaseapp.com',
    storageBucket: 'voter-1b17d.appspot.com',
    measurementId: 'G-5EJWFZ6KDD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC6UtNX-3aToQLn48iiUv04imN3mfJqMZ4',
    appId: '1:470118869969:android:2de0a3d7a34fff0f12cef0',
    messagingSenderId: '470118869969',
    projectId: 'voter-1b17d',
    storageBucket: 'voter-1b17d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBQOx0b6LcAPFJqOyf9D116D01i3BzxmPI',
    appId: '1:470118869969:ios:be3a624e059683e912cef0',
    messagingSenderId: '470118869969',
    projectId: 'voter-1b17d',
    storageBucket: 'voter-1b17d.appspot.com',
    androidClientId: '470118869969-gbjg85fst8l58njpiq09pkud4ictk4ps.apps.googleusercontent.com',
    iosBundleId: 'com.example.voterSzabist',
  );
}
