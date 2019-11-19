import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neutral_creep_dev/pages/paymentPage.dart';
import 'package:neutral_creep_dev/services/dbService.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../models/transaction.dart';
import '../models/customer.dart';

import '../helpers/color_helper.dart';

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

  final _formKey = GlobalKey<FormState>();
  String time = "Touch to select time";

  @override
  Widget build(BuildContext context) {
    final f = new DateFormat('yyyy-MM-dd hh:mm');
    return Scaffold(
      appBar: AppBar(
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
      ),
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
            Row(
              children: <Widget>[
                SizedBox(width: 10),
                Container(
                    width: MediaQuery.of(context).size.width / 8,
                    child: Text("No.",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20))),
                Container(
                  width: MediaQuery.of(context).size.width / 8 * 4 - 40,
                  child: Text("Item",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                SizedBox(width: 10),
                Container(
                  width: MediaQuery.of(context).size.width / 8 + 10,
                  child: Text("Qty",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                Container(
                  child: Text("Cost",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                )
              ],
            ),
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
                  return Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(width: 10),
                          Container(
                              width: MediaQuery.of(context).size.width / 8,
                              child: Text("${index + 1}",
                                  style: TextStyle(fontSize: 18))),
                          Container(
                            width:
                                MediaQuery.of(context).size.width / 8 * 4 - 30,
                            child: Text(
                                "${transaction.getCart().getGrocery(index).name}",
                                style: TextStyle(fontSize: 18)),
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: MediaQuery.of(context).size.width / 8 + 10,
                            child: Text(
                                "${transaction.getCart().getGrocery(index).quantity}",
                                style: TextStyle(fontSize: 18)),
                          ),
                          Container(
                            child: Text(
                                "${(transaction.getCart().getGrocery(index).cost * transaction.getCart().getGrocery(index).quantity).toStringAsFixed(2)}",
                                style: TextStyle(fontSize: 18)),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      index + 1 != transaction.getCart().getCartSize()
                          ? Container(
                              width: MediaQuery.of(context).size.width - 30,
                              height: 1,
                              color: Colors.grey,
                            )
                          : Container(),
                      SizedBox(height: 10)
                    ],
                  );
                },
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  Text(
                    "Collection Method",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 70,
                    width: MediaQuery.of(context).size.width - 100,
                    color: gainsboro,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton(
                        isExpanded: true,
                        value: _dropDownMenuValue,
                        items: [
                          DropdownMenuItem(
                            child: Text("Self-Collect"),
                            value: "1",
                          ),
                          customer.address != null
                              ? DropdownMenuItem(
                                  child: Text(
                                      "${customer.address["street"]}, ${customer.address["unit"]}, S${customer.address["postalCode"]}"),
                                  value: "2",
                                )
                              : null
                        ],
                        onChanged: (value) {
                          setState(() {
                            _dropDownMenuValue = value;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  ButtonTheme(
                    height: 60,
                    minWidth: 250,
                    child: RaisedButton(
                        color: heidelbergRed,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35)),
                        child: Text(
                          "MAKE PAYMENT",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        onPressed: () async {
                          final _timeController = TextEditingController();
                          final _dayController = TextEditingController();
                          final _monthController = TextEditingController();
                          final _yearController = TextEditingController();
                          if (_dropDownMenuValue == "2") {
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  //return AlertDialog(
                                  return MyDialog(
                                    time: time,
                                    transaction: transaction,
                                    customer: customer,
                                    db: db,
                                    dropDownMenuValue: _dropDownMenuValue,
                                  );
                                }
                                //}
                                );
                          } else
                            db.getEWalletData(customer.id).then((eWallet) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PaymentPage(
                                        transaction: transaction,
                                        customer: customer,
                                        collectionMethod: _dropDownMenuValue,
                                        eWallet: eWallet,
                                        deliveryTime: new Map(),
                                      )));
                            });
                        }),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyDialog extends StatefulWidget {
  String time;
  DBService db;
  Customer customer;
  String dropDownMenuValue;
  Transaction transaction;

  MyDialog(
      {this.time,
      this.customer,
      this.db,
      this.transaction,
      this.dropDownMenuValue});

  @override
  _MyDialogState createState() => new _MyDialogState(
      time: time,
      customer: customer,
      db: db,
      dropDownMenuValue: dropDownMenuValue,
      transaction: transaction);
}

class _MyDialogState extends State<MyDialog> {
  final f = new DateFormat('yyyy-MM-dd hh:mm');
  String time;
  DBService db;
  Customer customer;
  String dropDownMenuValue;
  Transaction transaction;

  _MyDialogState(
      {this.time,
      this.customer,
      this.db,
      this.transaction,
      this.dropDownMenuValue});

  Map deliveryTime;

  @override
  Widget build(BuildContext context) {
    Map date;

    DateTime now = DateTime.now();
    var test = now.add(new Duration(days: 1));
    DateTime nextTime =
        new DateTime(now.year, now.month, now.day, now.hour + 1, now.minute);
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Enter Delivery Details", style: TextStyle(fontSize: 14)),
          SizedBox(
            height: 10,
          ),
          FlatButton(
            child: Text(
              time,
              style: TextStyle(fontSize: 25, color: heidelbergRed),
            ),
            onPressed: () {
              DatePicker.showPicker(context,
                  showTitleActions: true,
                  pickerModel: CustomPicker(
                    currentTime: test,
                    minTime: DateTime(test.year, test.month, test.day),
                    maxTime: DateTime(2019, 12, 31),
                  ), onConfirm: (data) {
                time = DateFormat('yyyy-MM-dd – kk:mm').format(data);
                String year = time.substring(0, 4);
                String month = time.substring(5, 7);
                String day = time.substring(8, 10);
                String hrSec = time.substring(11, 16);
                date = {"day": day, "month": month, "year": year};
                deliveryTime = {"date": date, "time": hrSec};

                setState(() {});
              });
              /*await DatePicker.showDateTimePicker(context,
                  showTitleActions: true,
                  minTime: DateTime(test.year,test.month,test.day),
                  maxTime: DateTime(2019, 12, 31),
                  currentTime: test, onConfirm: (data) {
                time = data.toString();
                String year = time.substring(0, 4);
                String month = time.substring(5, 7);
                String day = time.substring(8, 10);
                String hrSec = time.substring(11, 18);
                date = {"day": day, "month": month, "year": year};
                deliveryTime = {"date": date, "time": hrSec};
                print(deliveryTime);

                setState(() {});
              });*/
            },
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                child: Text("Submit"),
                onPressed: () {
                  db.getEWalletData(customer.id).then((eWallet) {
                    print("hello$deliveryTime");
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PaymentPage(
                              transaction: transaction,
                              customer: customer,
                              collectionMethod: dropDownMenuValue,
                              eWallet: eWallet,
                              deliveryTime: deliveryTime,
                            )));
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CustomPicker extends DateTimePickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({
    DateTime currentTime,
    LocaleType locale,
    DateTime maxTime,
    DateTime minTime,
  }) : super(
            locale: locale,
            currentTime: currentTime,
            maxTime: maxTime,
            minTime: minTime);

  @override
  String middleStringAtIndex(int index) {
    if (index >= 9 && index < 20) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }
}
