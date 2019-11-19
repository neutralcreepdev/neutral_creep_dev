import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:neutral_creep_dev/models/models.dart';
import 'package:provider/provider.dart';
import 'top_up_page.dart';
import 'top_up_transfer_history_page.dart';
import 'transfer_page.dart';

class WalletPage extends StatefulWidget {
  WalletPage({Key key}) : super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: <Widget>[
      Container(
          height: 150,
          width: double.infinity,
          padding: EdgeInsets.only(right: 30, top: 30),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.history, size: 40, color: Colors.black),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TopUpTransferHistoryPage()))),
                Text("history", style: TextStyle(fontSize: 15))
              ])),
      Container(
          height: 150,
          width: double.infinity,
          color: Theme.of(context).backgroundColor,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Avaliable creep dollars:",
                    style: TextStyle(fontSize: 15)),
                SizedBox(height: 10),
                Text(
                    "\$${Provider.of<Customer>(context).eWallet.eCreadits.toStringAsFixed(2)}",
                    style: TextStyle(
                        fontSize: 70, color: Theme.of(context).primaryColor))
              ])),
      SizedBox(height: 30),
      Container(
          height: 150,
          width: double.infinity,
          color: Theme.of(context).backgroundColor,
          child: Row(
            children: <Widget>[transferButton(context), topUpButton(context)],
          ))
    ]));
  }

  InkWell topUpButton(BuildContext context) {
    return InkWell(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => TopUpPage())),
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    width: 1, color: Theme.of(context).primaryColor)),
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(FontAwesomeIcons.dollarSign,
                      size: 30, color: Theme.of(context).primaryColor),
                  SizedBox(height: 20),
                  Text("top up")
                ])));
  }

  InkWell transferButton(BuildContext context) {
    return InkWell(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => TransferPage())),
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    width: 1, color: Theme.of(context).primaryColor)),
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(FontAwesomeIcons.exchangeAlt,
                      size: 30, color: Theme.of(context).primaryColor),
                  SizedBox(height: 20),
                  Text("Transfer")
                ])));
  }
}
