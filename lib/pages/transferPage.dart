import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neutral_creep_dev/pages/homePage.dart';

import '../models/customer.dart';
import '../services/dbService.dart';

import '../helpers/color_helper.dart';

class TransferPage extends StatefulWidget {
  Customer customer;
  DBService db;

  TransferPage({this.customer, this.db});

  @override
  _TransferPageState createState() =>
      _TransferPageState(db: db, customer: customer);
}

class _TransferPageState extends State<TransferPage> {
  Customer customer;
  DBService db;
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _TransferPageState({this.customer, this.db});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: alablaster,
        centerTitle: true,
        elevation: 0.2,
        iconTheme: IconThemeData(color: heidelbergRed, size: 30),
        title: Text(
          "Transfer",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30,
              letterSpacing: 3),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Enter Amount to transfer:",
                  style: TextStyle(
                      color: heidelbergRed,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 75,
                ),
                Container(
                  width: 250,
                  child: TextFormField(
                    validator: (val) {
                      if (val.isEmpty)
                        return "Please enter amount to transfer";
                      else if (int.parse(val) <= 0)
                        return "Please enter correct amount to transfer!";
                      return null;
                    },
                    controller: _textController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.attach_money,
                        color: heidelbergRed,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: heidelbergRed, width: 0.0),
                      ),
                    ),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 75,
                ),
                ButtonTheme(
                  minWidth: 250,
                  height: 85,
                  child: FlatButton(
                    child: Text(
                      "Scan Friend's code",
                      style: TextStyle(color: whiteSmoke, fontSize: 25),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        try {
                          var friendID = await _scanQR();
                          await db.transferCredit(friendID.toString(), customer,
                              double.parse(_textController.text.toString()));

                          //Goes back to front page
                          Navigator.pop(context);
                        } catch (e) {
                          print("hzp");
                        }
                      }
                    },
                    color: heidelbergRed,
                  ),
                )
              ]),
        ),
      ),
    );
  }

  Future<String> _scanQR() async {
    String qrResult = await BarcodeScanner.scan();
    return qrResult.toString();
  }
}
