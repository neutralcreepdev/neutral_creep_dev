import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neutral_creep_dev/services/dbService.dart';

import '../models/transaction.dart';
import '../models/customer.dart';

import '../helpers/color_helper.dart';
import 'components/summary/components.dart';

class SummaryPage extends StatefulWidget {
  final PurchaseTransaction transaction;
  final Customer customer;
  final DBService db;

  SummaryPage({this.transaction, this.customer, this.db});

  _SummaryPageState createState() =>
      _SummaryPageState(transaction: transaction, customer: customer, db: db);
}

class _SummaryPageState extends State<SummaryPage> {
  final PurchaseTransaction transaction;
  final Customer customer;
  final DBService db;

  _SummaryPageState({this.transaction, this.customer, this.db});

  var _dropDownMenuValue = "1";
  String time = "Touch to select time";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: summaryAppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: whiteSmoke,
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Text(
              "Order #${transaction.id}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 10),
            ItemListHeader(),
            SizedBox(height: 5),
            Container(
              width: MediaQuery.of(context).size.width - 10,
              height: 1,
              color: Colors.black,
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: transaction.getCart().getCartSize(),
                itemBuilder: (context, index) {
                  return ItemDetails(transaction: transaction, index: index);
                },
              ),
            ),
            SummaryPaymentButton(
              customer: customer,
              transaction: transaction,
              dbService: db,
              time: time,
              dropDownValue: _dropDownMenuValue,
              onChnage: (value) {
                setState(() {
                  _dropDownMenuValue = value;
                });
              },
            )
          ],
        ),
      ),
    );
  }

  AppBar summaryAppBar() {
    return AppBar(
      backgroundColor: alablaster,
      iconTheme: IconThemeData(color: heidelbergRed, size: 30),
      centerTitle: true,
      title: Text(
        "Summary",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 30,
            letterSpacing: 3),
      ),
      elevation: 0.2,
    );
  }
}
