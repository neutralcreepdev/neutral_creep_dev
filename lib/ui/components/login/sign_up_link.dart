import 'package:flutter/material.dart';

class SignUpLink extends StatelessWidget {
  final Function onTap;
  const SignUpLink({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
              Text("Don't Have an account? ", style: TextStyle(fontSize: 20)),
              Text(" SIGN UP NOW!",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 20))
            ])));
  }
}
