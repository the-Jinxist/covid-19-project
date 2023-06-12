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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBAuuFi88nqVA8nA3hqTvB8XX_NWNIIIhM',
    appId: '1:896115515295:android:b0f2bd900351d133dfe7aa',
    messagingSenderId: '896115515295',
    projectId: 'covid-tracker-project-baf91',
    storageBucket: 'covid-tracker-project-baf91.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDYcBKSB_wvzlF7o_qtuGl_EA8XoIR0sfE',
    appId: '1:896115515295:ios:eb4a17e2e83d22a4dfe7aa',
    messagingSenderId: '896115515295',
    projectId: 'covid-tracker-project-baf91',
    storageBucket: 'covid-tracker-project-baf91.appspot.com',
    iosClientId: '896115515295-j3lsqbd7kh7g725mrlroup26etnjdcnp.apps.googleusercontent.com',
    iosBundleId: 'com.neo.org.covidTrackerApp',
  );
}
