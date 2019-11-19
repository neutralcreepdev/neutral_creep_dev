import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../services/dbService.dart';
import '../helpers/color_helper.dart';

class TransactionHistoryPage extends StatefulWidget {
  Customer customer;
  DBService db;

  TransactionHistoryPage({this.customer, this.db});

  @override
  _TransactionHistoryPageState createState() =>
      _TransactionHistoryPageState(customer: customer, db: db);
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  Customer customer;
  DBService db;

  _TransactionHistoryPageState({this.db, this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //Back button
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
          backgroundColor: alablaster,
          centerTitle: true,
          title: Text(
            "Transaction History",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 30,
                letterSpacing: 3),
          ),
          elevation: 0.2,
        ),
        body: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Text('loading');
              return Container(
                  height: 1000,
                  width: 500,
                  child: ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        String tid = snapshot
                            .data.documents[index]['transactionId']
                            .toString();
                        String date = snapshot
                            .data.documents[index]['dateOfTransaction']
                            .toDate()
                            .toString();
                        String totalAmount = snapshot
                            .data.documents[index]['totalAmount']
                            .toStringAsFixed(2);
                        String collectType = snapshot
                            .data.documents[index]['collectType']
                            .toString();
                        String paymentType = snapshot
                            .data.documents[index]['paymentType']
                            .toString();

                        var items = snapshot.data.documents[index]['items'];
                        return Card(
                          color: alablaster,
                          elevation: 0.2,
                          child: ListTile(
                              title: Text(
                                  "$tid - $collectType - ${date.substring(0, date.length - 7)} - \$$totalAmount"),
                              onLongPress: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                          content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                            Text(
                                              "Transaction history",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: heidelbergRed),
                                            ),
                                            Divider(
                                              height: 25,
                                              color: heidelbergRed,
                                            ),
                                            Text("Payment Type:",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: heidelbergRed,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text("$paymentType",
                                                style: TextStyle(fontSize: 20)),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text("Items:",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: heidelbergRed,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text("$items",
                                                style: TextStyle(fontSize: 20)),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text("Date of Transaction: ",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: heidelbergRed,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                              "${date.substring(0, date.length - 7)}",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text("Total Amount: ",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: heidelbergRed,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                              "\$$totalAmount",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ]));
                                    });
                              }),
                        );
                      }));
            }));
  }

  Future<void> getData() async {
    var history = await db.getTransactionHistory(customer.id);
    return history;
  }
}
