package com.annulus.zion;

import com.onesignal.NotificationExtenderService;
import com.onesignal.OSNotificationDisplayedResult;
import com.onesignal.OSNotificationReceivedResult;


public class BackgroundNotification extends NotificationExtenderService {
   @Override
   protected boolean onNotificationProcessing(OSNotificationReceivedResult receivedResult) {
      // Read properties from result.
     
      // Return true to stop the notification from displaying.
      return false;
   }
}
