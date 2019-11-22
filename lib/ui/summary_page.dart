import 'package:flutter/material.dart';
import 'package:neutral_creep_dev/ui/home_page.dart';
import 'package:provider/provider.dart';

import 'package:neutral_creep_dev/models/models.dart';
import 'components/summary/components.dart';

class SummaryPage extends StatefulWidget {
  final Map deliveryAndPaymentMethod;
  SummaryPage({Key key, this.deliveryAndPaymentMethod}) : super(key: key);

  @override
  _SummaryPageState createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
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
                      height: 100,
                      padding: EdgeInsets.fromLTRB(30, 30, 0, 0),
                      child: Text("Summary",
                          style: TextStyle(
                              fontSize: 60, color: Colors.blue[500]))),
                  Flexible(
                      child: SummaryDetails(
                    transaction: Provider.of<PurchaseTransaction>(context),
                    deliveryAndPaymentMethod: widget.deliveryAndPaymentMethod,
                    creditCard: getCreditCard(context),
                    address: Provider.of<Customer>(context).address,
                  )),
                  ConfirmPurchaseButton(
                      onPressed: () => handleConfirmPurchaseTapped(context))
                ])));
  }

  Future<void> handleConfirmPurchaseTapped(BuildContext context) async {
    print("\n\n\n\n\nhere");
    SummaryLogic.handleConfirmPurchase(context, widget.deliveryAndPaymentMethod)
        .then((isSuccessful) {
      if (isSuccessful) {
        Provider.of<PurchaseTransaction>(context).clearTransaction();
        Provider.of<Customer>(context).clearCart();
        Navigator.popUntil(context, ModalRoute.withName("home"));
      } else {
        SummaryLogic.errorDialog(context);
      }
    });
  }

  Map getCreditCard(BuildContext context) {
    if (widget.deliveryAndPaymentMethod["paymentMethod"] == "credit card") {
      int cardIndex = widget.deliveryAndPaymentMethod["cardIndex"];
      return Provider.of<Customer>(context).eWallet.creditCards[cardIndex];
    } else
      return null;
  }
}
