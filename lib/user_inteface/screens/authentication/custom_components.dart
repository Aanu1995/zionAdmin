import 'package:flutter/material.dart';
import 'package:zion/user_inteface/utils/color_utils.dart';

class AuthenticationButton extends StatelessWidget {
  final String text;
  final String authenticatingText;
  final bool isAuthenticating;
  final void Function() onPressed;
  AuthenticationButton(
      {this.text,
      this.isAuthenticating = false,
      this.authenticatingText,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isAuthenticating,
      child: MaterialButton(
        color: isAuthenticating
            ? ColorUtils.primaryColor.withOpacity(0.5)
            : ColorUtils.primaryColor,
        height: 54.0,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        minWidth: double.maxFinite,
        child: !isAuthenticating
            ? Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  letterSpacing: 1.5,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    authenticatingText,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.5,
                        letterSpacing: 1.5),
                  ),
                  SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  )
                ],
              ),
        onPressed: onPressed,
      ),
    );
  }
}
