import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.

/// import 'firebase_options.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
    
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDXJGjy52qofo4zftXB_rjVIPSMxGhnJXY',
    appId: '1:644205849816:web:d11b419822c085c5dbfbad',
    messagingSenderId: '644205849816',
    projectId: 'flutter-ecommerce-app-1db27',
    authDomain: 'flutter-ecommerce-app-1db27.firebaseapp.com',
    storageBucket: 'flutter-ecommerce-app-1db27.firebasestorage.app',
    measurementId: 'G-G2PRZT4053',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDNAOfFZbw5KXSR7yBKBVTH3yaiiCvojL0',
    appId: '1:644205849816:android:78befe145daddd0ddbfbad',
    messagingSenderId: '644205849816',
    projectId: 'flutter-ecommerce-app-1db27',
    storageBucket: 'flutter-ecommerce-app-1db27.firebasestorage.app',
  );
}
