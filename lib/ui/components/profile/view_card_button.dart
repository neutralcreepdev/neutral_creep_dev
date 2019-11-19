import 'package:flutter/material.dart';

class ViewMyCreditCardButton extends StatelessWidget {
  final Function onPressed;
  const ViewMyCreditCardButton({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 70,
        padding: EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        child: FlatButton(
            color: Theme.of(context).primaryColor,
            disabledColor: Theme.of(context).cardColor,
            onPressed: onPressed,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            textColor: Colors.white,
            padding: EdgeInsets.all(0),
            child: Text(
              "View my credit cards",
              style: TextStyle(
                  fontSize: 30, fontFamily: "Air Americana", height: 1.7),
              textAlign: TextAlign.center,
            )));
  }
}
