import 'package:zion/service/chat_service.dart';
import 'package:zion/service/notification_service.dart';
import 'package:zion/service/user_profile_service.dart';

class DependecyInjection {
  NotificationService service;
  UserProfileService userProfileService;

  ChatServcice chatServcice;

  DependecyInjection() {
    service = NotificationService();
    userProfileService = UserProfileService();
    chatServcice = ChatServcice();
  }
}
