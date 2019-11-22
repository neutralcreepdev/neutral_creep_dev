import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:neutral_creep_dev/models/models.dart';
import 'package:neutral_creep_dev/ui/payment_method_page.dart';
import 'package:provider/provider.dart';

import 'components/delivery_method/components.dart';

class DeliveryMethodPage extends StatefulWidget {
  DeliveryMethodPage({Key key}) : super(key: key);

  @override
  _DeliveryMethodPageState createState() => _DeliveryMethodPageState();
}

class _DeliveryMethodPageState extends State<DeliveryMethodPage> {
  int pageIndex = 0;
  Map<String, dynamic> deliveryDate = Map<String, dynamic>();
  String deliveryTimeString;
  Map<String, dynamic> deliveryAndPaymentMethod = Map<String, dynamic>();

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
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).backgroundColor,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      height: 150,
                      padding: EdgeInsets.fromLTRB(30, 30, 0, 0),
                      child: Text("Collection\nMethod",
                          style: TextStyle(
                              fontSize: 50, color: Colors.blue[500]))),
                  Flexible(child: getDeliveryView(context)),
                  ProceedToPaymentButton(
                      onPressed: () => navToPaymentMethod(context))
                ])));
  }

  void navToPaymentMethod(BuildContext context) {
    if (pageIndex == 1 && deliveryTimeString == null) {
      Fluttertoast.showToast(msg: "No time picked");
    } else {
      pageIndex == 0
          ? deliveryAndPaymentMethod = {"deliveryMethod": "self"}
          : deliveryAndPaymentMethod = {
              "deliveryMethod": "deliver",
              "deliveryTime": deliveryDate
            };

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PaymentMethodPage(
                  deliveryAndPaymentMethod: deliveryAndPaymentMethod)));
    }
  }

  Widget getDeliveryView(BuildContext context) {
    if (pageIndex == 0)
      return SelfCollectView(onPressed: () => setState(() => pageIndex = 1));
    else
      return DeliveryView(
          onPressed: () => setState(() => pageIndex = 0),
          onTap: () => handleTimeTapped(context),
          address: Provider.of<Customer>(context).address,
          deliveryTime: deliveryTimeString);
  }

  Future<void> handleTimeTapped(BuildContext context) async {
    DateTime now = DateTime.now();
    var test = now.add(new Duration(days: 1));

    final DateTime currentTime = DateTime.now();

    DatePicker.showPicker(context,
        showTitleActions: true,
        pickerModel: CustomDatePicker(
            currentTime: test,
            minTime: DateTime(test.year, test.month, test.day),
            maxTime: DateTime(2020, 12, 31, 19)), onConfirm: (data) {
      var time = DateFormat('yyyy-MM-dd – kk:mm').format(data);
      String year = time.substring(0, 4);
      String month = time.substring(5, 7);
      String day = time.substring(8, 10);
      String hrSec = time.substring(13, 18);
      Map date = {"day": day, "month": month, "year": year};
      deliveryDate = {"date": date, "time": hrSec};
      setState(() => deliveryTimeString = "$day-$month-$year, $hrSec");
    });
  }
}
