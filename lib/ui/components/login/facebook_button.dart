import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FacebookLoginButton extends StatelessWidget {
  final Function onPressed;
  const FacebookLoginButton({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          height: 50,
          decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(10)),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(FontAwesomeIcons.facebookF,
                    size: 35, color: Theme.of(context).backgroundColor),
                Text("Log In With Facebook",
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).backgroundColor)),
                Container()
              ])),
    );
  }
}
