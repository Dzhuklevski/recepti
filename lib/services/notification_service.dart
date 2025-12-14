import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final _messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    await _messaging.requestPermission();

    FirebaseMessaging.onMessage.listen((message) {
      // foreground handling (acceptable for lab)
      print(message.notification?.title);
    });
  }
}
