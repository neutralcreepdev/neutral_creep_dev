import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../helpers/color_helper.dart';

import '../models/customer.dart';
import '../services/dbService.dart';

import './topUpPage.dart';

class EWalletPage extends StatefulWidget {
  final Customer customer;
  final DBService db;

  EWalletPage({this.customer, this.db});

  _EWalletPageState createState() =>
      _EWalletPageState(customer: customer, db: db);
}

class _EWalletPageState extends State<EWalletPage> {
  final Customer customer;
  final DBService db;

  _EWalletPageState({this.customer, this.db});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: alablaster,
        centerTitle: true,
        elevation: 0.2,
        iconTheme: IconThemeData(color: heidelbergRed, size: 30),
        title: Text(
          "E-Wallet",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30,
              letterSpacing: 3),
        ),
      ),
      body: Container(
        color: whiteSmoke,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            // current amount text ==========================================
            SizedBox(height: 30),
            Text(
              "CREEP-DOLLARS:\n\$${customer.eWallet.eCreadits.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            // buttons container ==========================================
            SizedBox(height: 30),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width / 3,
                    height: 100,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: RaisedButton(
                      color: heidelbergRed,
                      child: Text(
                        "TOP-UP",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      onPressed: () {
                        if (customer.eWallet.creditCards.length == 0) {
                          Fluttertoast.showToast(
                              msg:
                                  "Error: Please Add a Credit Card before proceeding!");
                        } else
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => new TopUpPage(
                                    customer: customer,
                                    db: db,
                                  )));
                      },
                    ),
                  ),
                  SizedBox(width: 50),
                  ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width / 3,
                    height: 100,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: RaisedButton(
                      color: heidelbergRed,
                      child: Text(
                        "TRANSFER",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),

            // transaction history container ==========================================
            SizedBox(height: 50),
            Container(
              child: Column(
                children: <Widget>[
                  Text("Transaction History",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                  // Container(
                  //   height: MediaQuery.of(context).size.height / 2,
                  //   width: MediaQuery.of(context).size.width - 70,
                  //   color: Colors.blue,
                  //   child: Column(
                  //     children: <Widget>[
                  //       Container(
                  //         child: Row(
                  //           children: <Widget>[Text("id")],
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
