import 'dart:ui' as prefix0;

import 'package:flutter/material.dart';

import '../models/eWallet.dart';

import '../helpers/color_helper.dart';

class PaymentMadePage extends StatelessWidget {
  final EWallet eWallet;

  PaymentMadePage({this.eWallet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: alablaster,
        centerTitle: true,
        title: Text(
          "Payment",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30,
              letterSpacing: 3),
        ),
        elevation: 0.2,
        leading: Container(),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: whiteSmoke,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Purchase Confirmed",
              style:
                  TextStyle(fontWeight: prefix0.FontWeight.bold, fontSize: 28),
            ),
            SizedBox(height: 5),
            Text(
              "Credits Remaining: \$${eWallet.eCreadits.toStringAsFixed(2)}",
              style:
                  TextStyle(fontWeight: prefix0.FontWeight.bold, fontSize: 28),
            ),
            SizedBox(height: 30),
            ButtonTheme(
              height: 60,
              minWidth: 250,
              child: RaisedButton(
                  color: heidelbergRed,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35)),
                  child: Text(
                    "HOME",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
