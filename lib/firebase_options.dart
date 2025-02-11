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
    apiKey: 'AIzaSyB6I11UQMzVV5NLBlLGzq7U2vjhiEtkmno',
    appId: '1:343458581107:web:dc46be3d53f840cfe77806',
    messagingSenderId: '343458581107',
    projectId: 'code-general-des-impots-maroc',
    authDomain: 'code-general-des-impots-maroc.firebaseapp.com',
    storageBucket: 'code-general-des-impots-maroc.firebasestorage.app',
    measurementId: 'G-475W367EPM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDPVXBitiHNUrGHd8c9G2VyXUgNJ4BQpqo',
    appId: '1:343458581107:android:a9461124b80d1e43e77806',
    messagingSenderId: '343458581107',
    projectId: 'code-general-des-impots-maroc',
    storageBucket: 'code-general-des-impots-maroc.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDyvXQOXh2jbDH2yieCFCp81FyoV23y5Wo',
    appId: '1:343458581107:ios:cf0b198c967c2337e77806',
    messagingSenderId: '343458581107',
    projectId: 'code-general-des-impots-maroc',
    storageBucket: 'code-general-des-impots-maroc.firebasestorage.app',
    iosBundleId: 'com.example.codeGeneralMaroc',
  );
}
