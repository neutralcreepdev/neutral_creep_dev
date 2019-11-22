import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final Function onPressed;
  const LoginButton({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        width: double.infinity,
        child: FlatButton(
            color: Theme.of(context).primaryColor,
            onPressed: onPressed,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            textColor: Colors.white,
            padding: EdgeInsets.all(0),
            child: Text(
              "Login",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            )));
  }
}
