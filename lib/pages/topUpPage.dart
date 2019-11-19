import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../services/dbService.dart';

import '../helpers/color_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TopUpPage extends StatefulWidget {
  final Customer customer;
  final DBService db;

  TopUpPage({this.customer,this.db});

  _TopUpPageState createState() => _TopUpPageState(customer: customer,db:db);
}

class _TopUpPageState extends State<TopUpPage> {
  final Customer customer;
  final DBService db;

  _TopUpPageState({this.customer,this.db});

  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double currVal = customer.eWallet.eCreadits;
    String bankInfo = "";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: alablaster,
        centerTitle: true,
        elevation: 0.2,
        iconTheme: IconThemeData(color: heidelbergRed, size: 30),
        title: Text(
          "Top-Up",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30,
              letterSpacing: 3),
        ),
      ),
      backgroundColor: whiteSmoke,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 70),
            Text(
              "CREEP-DOLLARS Balance:\n\$${currVal.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 75),
            Text("Enter top-up amount"),
            Container(
              width: MediaQuery.of(context).size.width - 100,
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 50),
            Text("credit Card:"),
            Container(
              height: 300,
              width: MediaQuery.of(context).size.width - 70,
              decoration: BoxDecoration(
                  color: alablaster,
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: ListView.builder(
                  itemCount: customer.eWallet.creditCards.length,
                  itemBuilder: (context, index) {
                    Color mainColor = alablaster;
                    return Card(
                        elevation: 0.2,
                        color: mainColor,
                        child: ListTile(
                          title: Text(
                            "Bank Card num: ${customer.eWallet.creditCards[index]["cardNum"]}\n${customer.eWallet.creditCards[index]["cardNum"]}",
                          ),
                          onTap: () {
                            bankInfo=customer.eWallet.creditCards[index]["bankName"]+"|"+customer.eWallet.creditCards[index]["cardNum"];
                          },
                        ));
                  }),
            ),
            SizedBox(height: 30),
            ButtonTheme(
              height: 60,
              minWidth: 300,
              child: RaisedButton(
                color: heidelbergRed,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35)),
                child: Text(
                  "Confirm",
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                onPressed: () {
                  String addVal = _textController.text;
                  customer.eWallet.add(addVal);
                  print('eCredits: ${customer.eWallet.eCreadits}');
                  Fluttertoast.showToast(msg: bankInfo);
                  db.updateECredit(customer,double.parse(addVal),bankInfo);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
