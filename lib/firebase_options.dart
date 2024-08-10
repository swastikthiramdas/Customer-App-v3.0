import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      // case TargetPlatform.windows:
      //   return web;
      default:
        return android;
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCdUIIuSsxNsEyp07YTCgOpu4WdqNd-yHU',
    appId: '1:1026006800173:android:ac4813157de3af0afde5a4',
    messagingSenderId: '1026006800173',
    projectId: 'jyotishi-uttarkashi',
    storageBucket: 'jyotishi-uttarkashi.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCXVlRSXpLHfXHbqeGDPSz8e5-NdDh521s',
    appId: '1:1026006800173:ios:d753018dc1ba12d1fde5a4',
    messagingSenderId: '1026006800173',
    projectId: 'jyotishi-uttarkashi',
    storageBucket: 'jyotishi-uttarkashi.appspot.com',
    iosBundleId: 'com.astrowaydiploy.user',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCHg0qWYNLdvc5vg2gfMz2zef4Vn0P88r4',
    appId: '1:1026006800173:web:78ad0d303a5dd809fde5a4',
    messagingSenderId: '1026006800173',
    projectId: 'jyotishi-uttarkashi',
    authDomain: 'jyotishi-uttarkashi.firebaseapp.com',
    storageBucket: 'jyotishi-uttarkashi.appspot.com',
    measurementId: 'G-CCB12Z3JDS',
  );

}