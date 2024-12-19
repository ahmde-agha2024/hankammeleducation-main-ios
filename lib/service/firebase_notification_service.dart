import 'package:hive/hive.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotificationService {
  static final _box = Hive.box('notifications');

  static Future<void> storeNotificationToHive(RemoteMessage message) async {
    final notification = {
      'title': message.notification?.title ?? 'No Title',
      'body': message.notification?.body ?? 'No Body',
      'timestamp': DateTime.now().toIso8601String(),
    };
    await _box.add(notification);
  }

  static List<Map<dynamic, dynamic>> getNotifications() {

    return _box.values.cast<Map<dynamic, dynamic>>().toList();
  }

  static int getNotificationCount() {
    return _box.values.length;
  }
}
