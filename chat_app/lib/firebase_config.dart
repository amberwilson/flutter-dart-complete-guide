import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig {
  static FirebaseOptions get platformOptions {
    // if (kIsWeb) {
    //   // Web
    //   return const FirebaseOptions(
    //     apiKey: 'AIzaSyA1nNkAPfbU2rfam-nolfK-ILx8588rJw0',
    //     databaseURL: 'https://flutter-chat-3dc1f.firebaseio.com',
    //     projectId: 'flutter-chat-3dc1f',
    //     storageBucket: 'flutter-chat-3dc1f.appspot.com',
    //     messagingSenderId: '448618578101',
    //     appId: '1:448618578101:web:772d484dc9eb15e9ac3efc',
    //     measurementId: 'G-0N1G9FLDZE',
    //   );
    // } else if (Platform.isIOS || Platform.isMacOS) {
    //   // iOS and MacOS
    //   return const FirebaseOptions(
    //     appId: '1:448618578101:ios:2bc5c1fe2ec336f8ac3efc',
    //     apiKey: 'AIzaSyAHAsf51D0A407EklG1bs-5wA7EbyfNFg0',
    //     projectId: 'react-native-firebase-testing',
    //     messagingSenderId: '448618578101',
    //     iosBundleId: 'io.flutter.plugins.firebase.firestore.example',
    //     iosClientId:
    //         '448618578101-ja1be10uicsa2dvss16gh4hkqks0vq61.apps.googleusercontent.com',
    //     androidClientId:
    //         '448618578101-2baveavh8bvs2famsa5r8t77fe1nrcn6.apps.googleusercontent.com',
    //     storageBucket: 'react-native-firebase-testing.appspot.com',
    //     databaseURL: 'https://react-native-firebase-testing.firebaseio.com',
    //   );
    // } else {
    //   // Android
    return const FirebaseOptions(
      appId: '1:836034834437:android:c9a56559dfdf46a05cac6c',
      apiKey: 'AIzaSyCuu4tbv9CwwTudNOweMNstzZHIDBhgJxA',
      projectId: 'flutter-chat-3dc1f',
      messagingSenderId: '448618578101',
    );
    // }
  }
}
