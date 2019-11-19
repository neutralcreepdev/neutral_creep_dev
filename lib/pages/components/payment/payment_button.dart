import 'package:flutter/material.dart';

import '../../../helpers/color_helper.dart';

class PaymentButton extends StatelessWidget {
  final Function onPressed;
  final String title;
  const PaymentButton({Key key, this.onPressed, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
        height: 60,
        minWidth: 250,
        child: RaisedButton(
            color: heidelbergRed,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
            child: Text(title,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            onPressed: onPressed));
  }
}
