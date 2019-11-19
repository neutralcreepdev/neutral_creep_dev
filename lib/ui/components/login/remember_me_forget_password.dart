import 'package:flutter/material.dart';

class RememberMeForgetPasswordFields extends StatelessWidget {
  final bool value;
  final Function rememberMeOnChanged;
  final Function fogetPasswordOnTap;
  const RememberMeForgetPasswordFields(
      {Key key, this.value, this.rememberMeOnChanged, this.fogetPasswordOnTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
          Row(children: <Widget>[
            Checkbox(value: value, onChanged: rememberMeOnChanged),
            Text("Remember Me", style: TextStyle(fontSize: 15))
          ]),
          GestureDetector(
              onTap: fogetPasswordOnTap,
              child: Text("Forget Password", style: TextStyle(fontSize: 15))),
        ]));
  }
}
