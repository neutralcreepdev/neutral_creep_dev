import 'dart:ui' as prefix0;

import 'package:flutter/material.dart';

import '../models/customer.dart';
import '../helpers/color_helper.dart';

class PaymentMadePage extends StatelessWidget {
  final Customer customer;
  final String paymentType;
  final String cardNo;
  final int pointsEarned;
  bool show = false;

  PaymentMadePage(
      {this.customer, this.paymentType, this.cardNo, this.pointsEarned});

  @override
  Widget build(BuildContext context) {
    if (paymentType == "CreepDollars") show = true;
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
      body: WillPopScope(
        onWillPop: () async => false,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: whiteSmoke,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Purchase Confirmed",
                style: TextStyle(
                    fontWeight: prefix0.FontWeight.bold, fontSize: 28),
              ),
              SizedBox(height: 5),
              show
                  ? Text(
                      "Credits Remaining: \$${customer.eWallet.eCreadits.toStringAsFixed(2)}",
                      style: TextStyle(
                          fontWeight: prefix0.FontWeight.bold, fontSize: 28),
                    )
                  : Column(children: [
                      Text("\nCredit Card No. ",
                          style: TextStyle(fontSize: 25)),
                      Text(
                        "[XXXX XXXX XXXX XXXX ${cardNo.substring(cardNo.length - 4, cardNo.length)}]",
                        style: TextStyle(fontSize: 25),
                      )
                    ]),
              pointsEarned != 0
                  ? Text(
                      "Points Earned: $pointsEarned",
                      style: TextStyle(
                          fontWeight: prefix0.FontWeight.bold, fontSize: 28),
                    )
                  : Container(),
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
                      Navigator.pop(context);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
