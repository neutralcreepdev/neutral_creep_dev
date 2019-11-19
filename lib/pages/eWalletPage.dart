import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../helpers/color_helper.dart';

import '../models/customer.dart';
import '../services/dbService.dart';

import './topUpPage.dart';
import './transferPage.dart';

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

    bool typeBool = false;
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
                          color: whiteSmoke,
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
                          color: whiteSmoke,
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => new TransferPage(
                                  customer: customer,
                                  db: db,
                                )));
                      },
                    ),
                  ),
                ],
              ),
            ),

            // transaction history container ==========================================
            SizedBox(height: 50),
            Text("E-Credit Transaction History",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 300,
              width: MediaQuery.of(context).size.width - 60,
              decoration: BoxDecoration(
                  color: alablaster,
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: FutureBuilder(
                      future: getData(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return Text('loading');
                        return Container(
                          child: ListView.builder(
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, index) {
                              String type = snapshot
                                  .data.documents[index]['type']
                                  .toString();

                              String date = snapshot
                                  .data.documents[index]['dateOfTopUp']
                                  .toDate()
                                  .toString();

                              String topUpAmount = snapshot
                                  .data.documents[index]['topUpAmount']
                                  .toStringAsFixed(2);

                              String bankName;
                              String cardNum;
                              String recepient;
                              String sender;

                              if (type == "topUp") {
                                type = "TopUp";
                                String bankInfo = snapshot
                                    .data.documents[index]['bankInfo']
                                    .toString();
                                var bankDetails = bankInfo.split("|");
                                bankName = bankDetails[0];
                                cardNum = bankDetails[1].substring(
                                    bankDetails[1].length - 4,
                                    bankDetails[1].length);
                              } else if (type == "transfer") {
                                type = "Transfer";
                                bankName = "";
                                cardNum = "";

                                sender =snapshot
                                    .data.documents[index]['from']
                                    .toString();
                                recepient = snapshot
                                    .data.documents[index]['to']
                                    .toString();
                              }
                              return Card(
                                color: alablaster,
                                elevation: 0.2,
                                child: ListTile(
                                  title: typeBool
                                      ? Text("$type: \$$topUpAmount")
                                      : Text("$type: \$$topUpAmount"),
                                  onLongPress: () {
                                    if(type=="TopUp")
                                      typeBool=false;
                                    else if(type=="Transfer")
                                      typeBool = true;

                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          print("type: $typeBool");
                                          return typeBool
                                              ? AlertDialog(
                                                  content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          "E-Credit Info",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  heidelbergRed),
                                                        ),
                                                        Divider(
                                                          height: 25,
                                                          color: heidelbergRed,
                                                        ),
                                                        Text("Transfer Amount: ",
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color:
                                                                    heidelbergRed,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text("\$$topUpAmount",
                                                            style: TextStyle(
                                                                fontSize: 20)),
                                                        SizedBox(
                                                          height: 15,
                                                        ),
                                                        Text(
                                                            "From: ",
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color:
                                                                    heidelbergRed,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                                "$sender",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20)),
                                                        SizedBox(
                                                          height: 15,
                                                        ),
                                                        Text(
                                                            "To: ",
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color:
                                                                heidelbergRed,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                        Text(
                                                            "$recepient",
                                                            style: TextStyle(
                                                                fontSize:
                                                                20)),
                                                        SizedBox(
                                                          height: 15,
                                                        ),
                                                        Text(
                                                            "Date of Transaction: ",
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color:
                                                                    heidelbergRed,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                          "${date.substring(0, date.length - 7)}",
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        ),
                                                      ]),
                                                )
                                              : AlertDialog(
                                                  content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          "E-Credit Info",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  heidelbergRed),
                                                        ),
                                                        Divider(
                                                          height: 25,
                                                          color: heidelbergRed,
                                                        ),
                                                        Text("Top Up Amount: ",
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color:
                                                                    heidelbergRed,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text("\$$topUpAmount",
                                                            style: TextStyle(
                                                                fontSize: 20)),
                                                        SizedBox(
                                                          height: 15,
                                                        ),
                                                        Text(
                                                            "Credit Card Used: ",
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color:
                                                                    heidelbergRed,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                                "$bankName\nXXXX XXXX XXXX $cardNum",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20)),
                                                        SizedBox(
                                                          height: 15,
                                                        ),
                                                        Text(
                                                            "Date of Transaction: ",
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color:
                                                                    heidelbergRed,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                          "${date.substring(0, date.length - 7)}",
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        ),
                                                      ]),
                                                );
                                        });
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> getData() async {
    var history = await db.getTopUpHistory(customer.id);
    return history;
  }
}
