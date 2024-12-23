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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyCRXTLx-n5NUKpg_Qd2ecF251uFWo0ZWIU',
    appId: '1:1061617340244:web:36dc32901289191295c2c1',
    messagingSenderId: '1061617340244',
    projectId: 'flutterfirebase-892c6',
    authDomain: 'flutterfirebase-892c6.firebaseapp.com',
    storageBucket: 'flutterfirebase-892c6.firebasestorage.app',
    measurementId: 'G-N46K6JSDXT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDKMdo3jINkPUPsCUzVWhVAQTN9_hPKSRk',
    appId: '1:1061617340244:android:97938c7e4c645cd095c2c1',
    messagingSenderId: '1061617340244',
    projectId: 'flutterfirebase-892c6',
    storageBucket: 'flutterfirebase-892c6.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCRXTLx-n5NUKpg_Qd2ecF251uFWo0ZWIU',
    appId: '1:1061617340244:web:158974432c80776895c2c1',
    messagingSenderId: '1061617340244',
    projectId: 'flutterfirebase-892c6',
    authDomain: 'flutterfirebase-892c6.firebaseapp.com',
    storageBucket: 'flutterfirebase-892c6.firebasestorage.app',
    measurementId: 'G-QTB3JKP4LG',
  );
}
