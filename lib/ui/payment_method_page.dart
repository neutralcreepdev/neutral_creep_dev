import 'package:flutter/material.dart';
import 'package:neutral_creep_dev/models/models.dart';
import 'package:provider/provider.dart';
import 'components/payment_method/components.dart';
import 'summary_page.dart';

class PaymentMethodPage extends StatefulWidget {
  final Map deliveryAndPaymentMethod;
  PaymentMethodPage({Key key, this.deliveryAndPaymentMethod}) : super(key: key);

  @override
  _PaymentMethodPageState createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  int pageIndex = 0;
  int cardIndex = 0;
  final List<Color> cardColors = [
    Colors.blue,
    Colors.grey,
    Colors.yellow,
    Colors.pinkAccent
  ];

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
                      child: Text("payment\nmethod",
                          style: TextStyle(
                              fontSize: 60, color: Colors.blue[500]))),
                  Flexible(child: getPaymentView()),
                  ProceedToSummaryButton(
                      onPressed: () => handleProceedButtonTapped(context))
                ])));
  }

  void handleProceedButtonTapped(BuildContext context) {
    if (pageIndex == 0)
      widget.deliveryAndPaymentMethod["paymentMethod"] = "creep dollar";
    else {
      widget.deliveryAndPaymentMethod["paymentMethod"] = "credit card";
      widget.deliveryAndPaymentMethod["cardIndex"] = cardIndex;
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SummaryPage(
                deliveryAndPaymentMethod: widget.deliveryAndPaymentMethod)));
  }

  Widget getPaymentView() {
    if (pageIndex == 0) {
      return CreepDollarView(
          availableCD: Provider.of<Customer>(context).eWallet.eCreadits,
          cartCost:
              Provider.of<PurchaseTransaction>(context).cart.getGrandTotal(),
          onPressed:
              Provider.of<Customer>(context).eWallet.creditCards.length != 0
                  ? () => setState(() => pageIndex = 1)
                  : null);
    } else {
      int size = Provider.of<Customer>(context).eWallet.creditCards.length;
      return CreditCardView(
          cardIndex: cardIndex,
          cardColor: cardColors[cardIndex % 4],
          nextCardColor: cardColors[getNextCardIndex(size)],
          creditCards: Provider.of<Customer>(context).eWallet.creditCards,
          onSwipeLeft: size > 1 ? () => handleSwipLeft(size) : null,
          onSwipeRight: size > 1 ? () => handleSwipRight(size) : null,
          onPressed: Provider.of<Customer>(context).eWallet.eCreadits > 0
              ? () => setState(() => pageIndex = 0)
              : null);
    }
  }

  int getNextCardIndex(int size) {
    if (cardIndex == (size - 1)) {
      return 0;
    } else
      return (cardIndex + 1) % 4;
  }

  void handleSwipRight(int size) {
    setState(() {
      if (cardIndex == 0) {
        cardIndex = size - 1;
      } else
        cardIndex--;
    });
  }

  void handleSwipLeft(int size) {
    setState(() {
      if (cardIndex == (size - 1)) {
        cardIndex = 0;
      } else
        cardIndex++;
    });
  }
}
