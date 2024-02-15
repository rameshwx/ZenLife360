import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyBf4j6cIX3QNMo272R2VyW9pvmqIl1sFjk',
    appId: '1:872486912364:android:bbdcecd885483610fc3349',
    messagingSenderId: '872486912364',
    projectId: 'mediclife-2377d',
    storageBucket: 'mediclife-2377d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBefkfmlZqAX3kXwnUHHiK2RiMT-7CpBjQ',
    appId: '1:1018280084568:ios:1f5a076b534961ab1c362d',
    messagingSenderId: '1018280084568',
    projectId: 'check-80ac8',
    storageBucket: 'check-80ac8.appspot.com',
    iosClientId: '1018280084568-cvc0234ubpg59a60oqs6fqrfafde1gde.apps.googleusercontent.com',
    iosBundleId: 'com.example.check',
  );
}
