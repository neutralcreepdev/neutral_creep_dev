import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../services/dbService.dart';
import '../helpers/color_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RedeemPage extends StatefulWidget {
  Customer customer;
  final DBService db;

  RedeemPage({this.customer, this.db});

  @override
  _RedeemPageState createState() =>
      _RedeemPageState(db: db, customer: customer);
}

class _RedeemPageState extends State<RedeemPage> {
  final Customer customer;
  DBService db;
  bool check5 = false;
  bool check10 = false;
  bool check15 = false;
  bool check20 = false;

  _RedeemPageState({this.customer, this.db});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (customer.eWallet.points > 150) check5 = true;
    if (customer.eWallet.points > 285) check10 = true;
    if (customer.eWallet.points > 420) check15 = true;
    if (customer.eWallet.points > 520) check20 = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: alablaster,
        centerTitle: true,
        elevation: 0.2,
        iconTheme: IconThemeData(color: heidelbergRed, size: 30),
        title: Text(
          "Redemption",
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: heidelbergRed),
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Amount of Points:",
                      style: TextStyle(fontSize: 27, color: whiteSmoke),
                      textAlign: TextAlign.center,
                    ),
                    Text("${widget.customer.eWallet.points}",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: whiteSmoke)),
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text(
                  "Rewards Available: ",
                  style: TextStyle(fontSize: 27, color: whiteSmoke),
                ),
              ),
              decoration: BoxDecoration(color: Colors.black),
            ),
            check5
                ? GestureDetector(
                    onTap: () async {
                      await _showDialog(5, customer);
                      setState(() {
                        if (customer.eWallet.points > 150)
                          check5 = true;
                        else
                          check5 = false;
                        if (customer.eWallet.points > 285)
                          check10 = true;
                        else
                          check10 = false;
                        if (customer.eWallet.points > 420)
                          check15 = true;
                        else
                          check15 = false;
                        if (customer.eWallet.points > 520)
                          check20 = true;
                        else
                          check20 = false;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.black,
                                  offset: new Offset(1.5, 2.8),
                                  blurRadius: 0,
                                )
                              ],
                              color: heidelbergRed,
                              borderRadius: new BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(9, 0, 0, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("5 CreepDollar",
                                    style: TextStyle(
                                      color: whiteSmoke,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Text("Points required: 150",
                                    style: TextStyle(
                                      color: whiteSmoke,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),
                          )),
                    ))
                : Container(),
            check10
                ? GestureDetector(
                    onTap: () async {
                      await _showDialog(10, customer);
                      setState(() {
                        if (customer.eWallet.points > 150)
                          check5 = true;
                        else
                          check5 = false;
                        if (customer.eWallet.points > 285)
                          check10 = true;
                        else
                          check10 = false;
                        if (customer.eWallet.points > 420)
                          check15 = true;
                        else
                          check15 = false;
                        if (customer.eWallet.points > 520)
                          check20 = true;
                        else
                          check20 = false;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.black,
                                  offset: new Offset(1.5, 2.8),
                                  blurRadius: 0,
                                )
                              ],
                              color: heidelbergRed,
                              borderRadius: new BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(9, 0, 0, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("10 CreepDollar",
                                    style: TextStyle(
                                      color: whiteSmoke,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Text("Points required: 285",
                                    style: TextStyle(
                                      color: whiteSmoke,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),
                          )),
                    ))
                : Container(),
            check15
                ? GestureDetector(
                    onTap: () async {
                      await _showDialog(15, customer);
                      setState(() {
                        if (customer.eWallet.points > 150)
                          check5 = true;
                        else
                          check5 = false;
                        if (customer.eWallet.points > 285)
                          check10 = true;
                        else
                          check10 = false;
                        if (customer.eWallet.points > 420)
                          check15 = true;
                        else
                          check15 = false;
                        if (customer.eWallet.points > 520)
                          check20 = true;
                        else
                          check20 = false;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.black,
                                  offset: new Offset(1.5, 2.8),
                                  blurRadius: 0,
                                )
                              ],
                              color: heidelbergRed,
                              borderRadius: new BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(9, 0, 0, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("15 CreepDollar",
                                    style: TextStyle(
                                      color: whiteSmoke,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Text("Points required: 420",
                                    style: TextStyle(
                                      color: whiteSmoke,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),
                          )),
                    ))
                : Container(),
            check20
                ? GestureDetector(
                    onTap: () async {
                      await _showDialog(20, customer);
                      setState(() {
                        if (customer.eWallet.points > 150)
                          check5 = true;
                        else
                          check5 = false;
                        if (customer.eWallet.points > 285)
                          check10 = true;
                        else
                          check10 = false;
                        if (customer.eWallet.points > 420)
                          check15 = true;
                        else
                          check15 = false;
                        if (customer.eWallet.points > 520)
                          check20 = true;
                        else
                          check20 = false;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.black,
                                  offset: new Offset(1.5, 2.8),
                                  blurRadius: 0,
                                )
                              ],
                              color: heidelbergRed,
                              borderRadius: new BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(9, 0, 0, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("20 CreepDollar",
                                    style: TextStyle(
                                      color: whiteSmoke,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Text("Points required: 520",
                                    style: TextStyle(
                                      color: whiteSmoke,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),
                          )),
                    ))
                : Container(),
          ],
        ),
      ),
    );
  }

  Future<void> _showDialog(int val, Customer customer) async {
    int pointsNeeded = 0;
    if (val == 5)
      pointsNeeded = 150;
    else if (val == 10)
      pointsNeeded = 285;
    else if (val == 15)
      pointsNeeded = 420;
    else if (val == 20) pointsNeeded = 520;

    // flutter defined function
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        int remaining = customer.eWallet.points - pointsNeeded;
        return AlertDialog(
          title: new Text("Redemption Confirmation"),
          content: Container(
            height: 250,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Text("Are you sure you want to redeem the following?"),
                SizedBox(
                  height: 30,
                ),
                Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(border: Border.all(width: 1.0)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("$val Creep-Dollars"),
                          Text("\nPoints Remaining After Redemption:"),
                          Row(
                            children: <Widget>[
                              Text("${customer.eWallet.points} - ",
                                  style: TextStyle(fontSize: 20)),
                              Text(
                                "$pointsNeeded",
                                style: TextStyle(
                                    color: heidelbergRed, fontSize: 20),
                              ),
                              Text(
                                " = ",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text("$remaining",
                                  style: TextStyle(
                                      color: heidelbergRed, fontSize: 20)),
                            ],
                          ),
                          Text("\nCreep Dollar Value After Redemption:"),
                          Row(
                            children: <Widget>[
                              Text("\$${customer.eWallet.eCreadits.toStringAsFixed(2)} + ",
                                  style: TextStyle(fontSize: 20)),
                              Text(
                                "\$${val.toStringAsFixed(2)}",
                                style: TextStyle(
                                    color: heidelbergRed, fontSize: 20),
                              ),
                              Text(
                                " = ",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text("\$${(customer.eWallet.eCreadits-val).toStringAsFixed(2)}",
                                  style: TextStyle(
                                      color: heidelbergRed, fontSize: 20)),
                            ],
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: new Text("Yes"),
              onPressed: () async {
                customer.eWallet.points = remaining;
                customer.eWallet.eCreadits += val.toDouble();
                await db.redeem(customer, pointsNeeded, val.toDouble());
                Navigator.of(context).pop();
                Fluttertoast.showToast(msg: "Successfully redeemed!\nPoints remaining: ${customer.eWallet.points}\nNew Balance: ${customer.eWallet.eCreadits.toStringAsFixed(2)}");
              },
            ),
          ],
        );
      },
    );
  }
}
