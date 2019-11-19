import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import '../../../helpers/color_helper.dart';
import '../../../models/models.dart';
import '../../../services/dbService.dart';
import '../../paymentPage.dart';
import 'custom_picker.dart';

class MyDialog extends StatefulWidget {
  final String time;
  final DBService db;
  final Customer customer;
  final String dropDownMenuValue;
  final Transaction transaction;

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

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Enter Delivery Details", style: TextStyle(fontSize: 14)),
          SizedBox(height: 10),
          FlatButton(
            child: Text(time,
                style: TextStyle(fontSize: 25, color: heidelbergRed)),
            onPressed: () => handleTimeTapped(context, test, date),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                child: Text("Submit"),
                onPressed: () => handleSubmitButtonTapped(context),
              ),
            ),
          )
        ],
      ),
    );
  }

  void handleSubmitButtonTapped(BuildContext context) {
    if (deliveryTime == null) {
    } else {
      db.getEWalletData(customer.id).then((eWallet) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PaymentPage(
                  db: db,
                  transaction: transaction,
                  customer: customer,
                  collectionMethod: dropDownMenuValue,
                  eWallet: eWallet,
                  deliveryTime: deliveryTime,
                )));
      });
    }
  }

  void handleTimeTapped(BuildContext context, DateTime test, Map date) {
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
      String hrSec = time.substring(13, 18);
      date = {"day": day, "month": month, "year": year};
      deliveryTime = {"date": date, "time": hrSec};

      setState(() {});
    });
  }
}
