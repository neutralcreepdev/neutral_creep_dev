import 'package:flutter/material.dart';

class TopUpButton extends StatelessWidget {
  final Function onPressed;
  const TopUpButton({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 70,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        width: double.infinity,
        color: Theme.of(context).canvasColor,
        child: FlatButton(
            color: Theme.of(context).primaryColor,
            disabledColor: Theme.of(context).cardColor,
            onPressed: onPressed,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            textColor: Colors.white,
            padding: EdgeInsets.all(0),
            child: Text(
              "top up",
              style: TextStyle(fontSize: 30, height: 1.7),
              textAlign: TextAlign.center,
            )));
  }
}
