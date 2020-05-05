import 'package:zion/service/chat_service.dart';
import 'package:zion/service/notification_service.dart';

class DependecyInjection {
  NotificationService service;

  ChatServcice chatServcice;

  DependecyInjection() {
    service = NotificationService();
    chatServcice = ChatServcice();
  }
}
