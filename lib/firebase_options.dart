import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyABNx3ECCx4mzHTfeNaN5vCYS6qwHUSTh4',
    appId: '1:690679299544:web:fc126371788a09175a46ad',
    messagingSenderId: '690679299544',
    projectId: 'recepti-93d6c',
    authDomain: 'recepti-93d6c.firebaseapp.com',
    storageBucket: 'recepti-93d6c.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBBtx5JB8i7LWfPEjwX24VObsnixgInU0k',
    appId: '1:690679299544:android:f90d2e20d23e10705a46ad',
    messagingSenderId: '690679299544',
    projectId: 'recepti-93d6c',
    storageBucket: 'recepti-93d6c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCw3T60jXGCHXhNdvT0QVeEYMBQ6981qzc',
    appId: '1:690679299544:ios:58301f19147740f25a46ad',
    messagingSenderId: '690679299544',
    projectId: 'recepti-93d6c',
    storageBucket: 'recepti-93d6c.firebasestorage.app',
    iosBundleId: 'com.example.recepti',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCw3T60jXGCHXhNdvT0QVeEYMBQ6981qzc',
    appId: '1:690679299544:ios:58301f19147740f25a46ad',
    messagingSenderId: '690679299544',
    projectId: 'recepti-93d6c',
    storageBucket: 'recepti-93d6c.firebasestorage.app',
    iosBundleId: 'com.example.recepti',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyABNx3ECCx4mzHTfeNaN5vCYS6qwHUSTh4',
    appId: '1:690679299544:web:2af5644ff708ac455a46ad',
    messagingSenderId: '690679299544',
    projectId: 'recepti-93d6c',
    authDomain: 'recepti-93d6c.firebaseapp.com',
    storageBucket: 'recepti-93d6c.firebasestorage.app',
  );
}
