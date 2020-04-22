import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDialogs {
  // displays permission dialogs to the user
  static Future permissionDialog({BuildContext context}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Notification Permission'),
          content: Text(
            'To continue, turn on device notification in Settings. This is require to notify you of new messages.',
            textAlign: TextAlign.justify,
            style: TextStyle(
              height: 1.3,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Okay',
                style: TextStyle(fontSize: 16.0),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  static showErroDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          contentPadding:
              EdgeInsets.only(left: 12.0, right: 12.0, top: 16.0, bottom: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          content: Text(
            message,
            style: GoogleFonts.raleway(
              fontSize: 18.0,
              height: 1.3,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Okay',
                style: TextStyle(fontSize: 16.0),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

// displays toast messages
  static void displayMessage({String message, Color color, Toast toast}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: toast ?? Toast.LENGTH_LONG,
      backgroundColor: color ?? Colors.black.withOpacity(0.7),
      textColor: Colors.white,
    );
  }

// show the snackbar to display message
  static void showSnackBar(final globalKey, final content) {
    globalKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          content,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
      ),
    );
  }

// show the dialog for circularprogress indicator
  static showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(30.0),
              height: 80.0,
              child: Card(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      strokeWidth: 3.0,
                    ),
                    SizedBox(
                      width: 24.0,
                    ),
                    Text(
                      "Creating Group...",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

// close the dialog for circularprogress indicator
  static closeProgressDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}
