import 'package:flutter/material.dart';

import '../../../services/authService.dart';
import '../../../services/dbService.dart';
import 'widgets/facebook_button.dart';
import 'widgets/googl_button.dart';

class LoginSignUpWithSocials extends StatelessWidget {
  final AuthService authService;
  final DBService dbService;

  LoginSignUpWithSocials({Key key, this.authService, this.dbService})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0, 0.9),
      child: Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        height: 100,
        width: 400,
        child: Column(
          children: <Widget>[
            Text(
              "connect with:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FacebookButton(authService: authService, dbService: dbService),
                GoogleButton(authService: authService, dbService: dbService)
              ],
            )
          ],
        ),
      ),
    );
  }
}
