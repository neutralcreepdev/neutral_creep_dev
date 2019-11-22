import 'package:flutter/material.dart';

class ProceedToCheckoutButton extends StatelessWidget {
  final Function onPressed;
  const ProceedToCheckoutButton({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 70,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        width: double.infinity,
        child: FlatButton(
            color: Theme.of(context).primaryColor,
            disabledColor: Theme.of(context).cardColor,
            onPressed: onPressed,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            textColor: Colors.white,
            child: Text(
              "Proceed to checkout",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            )));
  }
}
