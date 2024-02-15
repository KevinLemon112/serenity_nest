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
        return macos;
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
    apiKey: 'AIzaSyAMTxEAa8toAhcXteMFCdrRlPDKqZri_UY',
    appId: '1:552186026922:web:4f32dc92e1f36d664829d3',
    messagingSenderId: '552186026922',
    projectId: 'serenitynest-6fdb1',
    authDomain: 'serenitynest-6fdb1.firebaseapp.com',
    storageBucket: 'serenitynest-6fdb1.appspot.com',
    measurementId: 'G-032ZJN26GX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDDfa0ROmyDkxdW6OtOujIpIicS7mEXn0g',
    appId: '1:552186026922:android:544d0555069e45734829d3',
    messagingSenderId: '552186026922',
    projectId: 'serenitynest-6fdb1',
    storageBucket: 'serenitynest-6fdb1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCHM3sH5hxtC2B3aFBcLHH5WQztHhpzWyM',
    appId: '1:552186026922:ios:5766de8fed9845554829d3',
    messagingSenderId: '552186026922',
    projectId: 'serenitynest-6fdb1',
    storageBucket: 'serenitynest-6fdb1.appspot.com',
    iosBundleId: 'com.KevinB.serenityNest',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCHM3sH5hxtC2B3aFBcLHH5WQztHhpzWyM',
    appId: '1:552186026922:ios:6ba2b98b477fb6ca4829d3',
    messagingSenderId: '552186026922',
    projectId: 'serenitynest-6fdb1',
    storageBucket: 'serenitynest-6fdb1.appspot.com',
    iosBundleId: 'com.KevinB.serenityNest.RunnerTests',
  );
}