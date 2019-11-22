import 'package:flutter/material.dart';

class ProceedToSummaryButton extends StatelessWidget {
  final Function onPressed;
  const ProceedToSummaryButton({Key key, this.onPressed}) : super(key: key);

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
              "Proceed to summery",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            )));
  }
}
