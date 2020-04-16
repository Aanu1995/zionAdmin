import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class ExceptionUtils {
// shows appropriate message to the user if there is an exception during authentication
  static String authenticationException(Exception e) {
    if (e is PlatformException) {
      if (Platform.isAndroid) {
        switch (e.message) {
          case 'There is no user record corresponding to this identifier. The user may have been deleted.':
            return 'Incorrect Email or Password';
            break;
          case 'The password is invalid or the user does not have a password.':
            return 'Invalid password.';
            break;
          case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
            return 'No Internet Connection.';
            break;
          case 'The email address is already in use by another account.':
            return 'This email address has already been taken';
            break;
          default:
            return 'Unknown error occured. Please try again!';
        }
      } else if (Platform.isIOS) {
        switch (e.code) {
          case 'Error 17011':
            return "Incorrect Email or Password";
            break;
          case 'Error 17009':
            return "Invalid password.";
            break;
          case 'Error 17020':
            return "No Internet Connection";
            break;
          default:
            return 'Unknown error occured. Please try again!';
        }
      } else {
        return 'Unknown error occured. Please try again!';
      }
    } else {
      return 'Unknown error occured. Please try again!';
    }
  }
}
