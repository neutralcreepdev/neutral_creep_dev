import 'package:flutter/material.dart';
import 'package:neutral_creep_dev/models/models.dart';
import 'package:provider/provider.dart';
import 'components/checkout/components.dart';
import 'delivery_method_page.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({Key key}) : super(key: key);

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
                      child: Text("Checkout",
                          style: TextStyle(
                              fontSize: 50, color: Colors.blue[500]))),
                  Flexible(
                      child: ItemList(
                          transaction:
                              Provider.of<PurchaseTransaction>(context))),
                  CostSummary(
                      transaction: Provider.of<PurchaseTransaction>(context)),
                  SizedBox(height: 5),
                  ProceedToDelieveryButton(onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DeliveryMethodPage()));
                  })
                ])));
  }
}
