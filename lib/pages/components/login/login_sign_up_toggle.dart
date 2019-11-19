import 'package:flutter/material.dart';

import '../../../helpers/color_helper.dart';

class LoginSignUpToggle extends StatelessWidget {
  final bool isSignUp;
  final Function loginOnPress;
  final Function signUpOnPress;
  const LoginSignUpToggle(
      {Key key, this.isSignUp, this.loginOnPress, this.signUpOnPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              child: Text(
                "LOGIN",
                style: TextStyle(
                    color: isSignUp
                        ? heidelbergRed.withOpacity(0.5)
                        : heidelbergRed,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: loginOnPress,
            ),
            SizedBox(
              width: 10,
            ),
            FlatButton(
              child: Text(
                "SIGN UP",
                style: TextStyle(
                    color: isSignUp
                        ? heidelbergRed
                        : heidelbergRed.withOpacity(0.5),
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: signUpOnPress,
            ),
          ],
        ),
      ),
    );
  }
}
