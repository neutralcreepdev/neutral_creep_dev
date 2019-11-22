import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neutral_creep_dev/models/models.dart';
import 'package:neutral_creep_dev/services/dbService.dart';
import 'package:provider/provider.dart';

import 'components/transfer/component.dart';

class TransferPage extends StatefulWidget {
  TransferPage({Key key}) : super(key: key);

  @override
  _TransferPageState createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).canvasColor,
            elevation: 0,
            shape: Border(
                bottom: BorderSide(
                    color: Theme.of(context).primaryColor, width: 0.2)),
            leading: IconButton(
                icon: Icon(Icons.arrow_back, size: 35, color: Colors.black),
                onPressed: () => Navigator.pop(context))),
        body: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height - 98,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).backgroundColor,
              child: Column(children: <Widget>[
                Flexible(
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Transfer amount:"),
                              SizedBox(height: 20),
                              TextField(
                                controller: _controller,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 30),
                                decoration:
                                    InputDecoration(hintText: "Enter here"),
                              ),
                              SizedBox(height: 50),
                            ]))),
                ScanQRButton(onPressed: () async {
                  try {
                    if (_controller.text.isNotEmpty) {
                      int amountNeeded = int.parse(_controller.text);
                      if (amountNeeded <=
                          Provider.of<Customer>(context).eWallet.eCreadits) {
                        try {
                          var friendID = await _scanQR();
                          Provider.of<Customer>(context)
                              .eWallet
                              .subtractECredit(amountNeeded.toDouble());
                          await DBService().transferCredit(
                              friendID.toString(),
                              Provider.of<Customer>(context),
                              double.parse(_controller.text));
                          Navigator.pop(context, true);
                        } catch (e) {
                          print("ERROR => $e");
                        }
                      } else {
                        Fluttertoast.showToast(msg: "Insufficient Funds");
                      }
                    }
                  } catch (_) {
                    Fluttertoast.showToast(msg: "Invalid Input");
                    _controller.text = "";
                  }
                })
              ])),
        ));
  }

  Future<String> _scanQR() async {
    String qrResult = await BarcodeScanner.scan();
    return qrResult.toString();
  }
}
