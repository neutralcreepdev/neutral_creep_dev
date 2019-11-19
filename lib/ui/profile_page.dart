import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:neutral_creep_dev/models/models.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'view_credit_card_page.dart';
import 'components/profile/components.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
                    icon: Icon(FontAwesomeIcons.qrcode,
                        size: 40, color: Colors.black),
                    onPressed: () {
                      qrDialog(context);
                    }),
                SizedBox(height: 5),
                Text("my code", style: TextStyle(fontSize: 15))
              ])),
      Flexible(child: profileData(context)),
      termsAndCondition(context),
    ]));
  }

  static void qrDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Container(
                  height: 350,
                  child: Column(children: <Widget>[
                    SizedBox(
                        height: 300,
                        width: 300,
                        child: QrImage(
                            data: Provider.of<Customer>(context).id,
                            foregroundColor: Colors.black)),
                    Text("Scan to transfer"),
                  ])),
              actions: <Widget>[
                new FlatButton(
                    child: new Text("done", style: TextStyle(fontSize: 20)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }

  Container termsAndCondition(BuildContext context) {
    return Container(
        height: 50,
        width: double.infinity,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text("view our "),
          Text("terms & condition",
              style: TextStyle(color: Theme.of(context).primaryColor))
        ]));
  }

  Container profileData(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        width: double.infinity,
        color: Theme.of(context).backgroundColor,
        child: Column(children: <Widget>[
          Row(children: <Widget>[
            Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.yellow),
                child: Center(
                  child: Text("G", style: TextStyle(fontSize: 50, height: 1.5)),
                )),
            SizedBox(width: 20),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                      "${Provider.of<Customer>(context).firstName} ${Provider.of<Customer>(context).lastName}",
                      style: TextStyle(fontSize: 30)),
                  Text("ID: ${Provider.of<Customer>(context).id}",
                      style: TextStyle(fontSize: 15)),
                ])
          ]),
          SizedBox(height: 10),
          ViewMyCreditCardButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewCreditCardPage()))),
          SizedBox(height: 30),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(width: MediaQuery.of(context).size.width),
                Text("address:", style: TextStyle(fontSize: 15)),
                Text("${Provider.of<Customer>(context).address["street"]}",
                    style: TextStyle(fontSize: 35)),
                Text(
                    "unit no.: ${Provider.of<Customer>(context).address["unit"]}",
                    style: TextStyle(fontSize: 20)),
                Text("S${Provider.of<Customer>(context).address["postalCode"]}",
                    style: TextStyle(fontSize: 20)),
              ]),
          SizedBox(height: 30),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(width: MediaQuery.of(context).size.width),
                Text("phone no.:", style: TextStyle(fontSize: 15)),
                Text("${Provider.of<Customer>(context).contactNum}",
                    style: TextStyle(fontSize: 35)),
              ])
        ]));
  }
}
