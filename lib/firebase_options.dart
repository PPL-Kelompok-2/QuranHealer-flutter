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
    apiKey: 'AIzaSyD9BXU3wp68vEjj_H_2E9coygm0D6APAhE',
    appId: '1:140721656982:web:faae64e02c315b04695eb7',
    messagingSenderId: '140721656982',
    projectId: 'quranhealerapp',
    authDomain: 'quranhealerapp.firebaseapp.com',
    storageBucket: 'quranhealerapp.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBQDp_4xHPiA1Rr3_lAUS-y1gFs4eHS4rk',
    appId: '1:140721656982:android:45e9d70c7d5fe55c695eb7',
    messagingSenderId: '140721656982',
    projectId: 'quranhealerapp',
    storageBucket: 'quranhealerapp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDx9pQzvTmUsRot1CpFVuSa2qEronnptg0',
    appId: '1:140721656982:ios:5428b95337258674695eb7',
    messagingSenderId: '140721656982',
    projectId: 'quranhealerapp',
    storageBucket: 'quranhealerapp.appspot.com',
    iosBundleId: 'com.example.quranhealer',
  );

}