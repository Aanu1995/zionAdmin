import 'package:flutter/material.dart';
import 'package:zion/user_inteface/components/empty_space.dart';
import 'package:zion/user_inteface/screens/settings/components/components.dart';

class CustomButtomSheets {
  //shows message when the device has no internet connection
  static showConnectionError(BuildContext context) {
    String text1 = "You seem to be offline! \n\n";
    String text2 =
        "Please check your Wifi network or Data service and try again. We love you!.";
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(
                top: 20.0, bottom: 10.0, left: 20.0, right: 20.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: text1,
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.0,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  TextSpan(
                    text: text2,
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      height: 1.2,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // bottom sheets to display options to get images to user
  static Future<int> imagePickerOptions(BuildContext context) async {
    int index;
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profile Photo',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                EmptySpace(multiple: 2.5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // remove button button
                    OptionAvartar(
                        text: "Remove photo",
                        icon: Icons.delete,
                        backgroundColor: Colors.orange[800],
                        onTap: () {
                          index = 1;
                          Navigator.pop(context);
                        }),
                    // pick from gallery button
                    OptionAvartar(
                        text: "Gallery",
                        icon: Icons.photo,
                        backgroundColor: Colors.purple,
                        onTap: () {
                          index = 2;
                          Navigator.pop(context);
                        }),
                    // use camera button
                    OptionAvartar(
                        text: "Camera",
                        icon: Icons.camera_alt,
                        backgroundColor: Colors.green,
                        onTap: () {
                          index = 3;
                          Navigator.pop(context);
                        })
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
    return index;
  }
}
