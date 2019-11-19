import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neutral_creep_dev/services/dbService.dart';
import 'package:neutral_creep_dev/ui/checkout_page.dart';
import 'package:provider/provider.dart';

import 'components/cart/components.dart';
import '../models/models.dart';

class CartPage extends StatefulWidget {
  CartPage({Key key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String result = "";

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: <Widget>[
      CartHeader(
          avaliableAmount: Provider.of<Customer>(context).eWallet.eCreadits,
          cartTotalCost:
              Provider.of<Customer>(context).currentCart.getTotalCost(),
          onTap: () => _scanQR(context)),
      Flexible(child: getCartItems()),
      ProceedToCheckoutButton(
          onPressed:
              Provider.of<Customer>(context).currentCart.getCartSize() > 0
                  ? () => handleSummaryButtonTapped(
                      context, Provider.of<Customer>(context))
                  : null)
    ]));
  }

  void handleSummaryButtonTapped(BuildContext context, Customer customer) {
    Provider.of<PurchaseTransaction>(context).setCart(customer.currentCart);

    if (customer.eWallet.creditCards.length == 0 &&
        customer.eWallet.eCreadits < 0) {
      Fluttertoast.showToast(
          msg: "Please add a credit Card or top up CreepDollars");
    } else {
      DBService().getTransactionId(customer.id).then((transactionId) {
        Provider.of<PurchaseTransaction>(context)
            .setId(transactionId.toString().padLeft(8, "0"));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CheckoutPage()));
      });
    }
  }

  Widget getCartItems() {
    if (Provider.of<Customer>(context).currentCart.getCartSize() == 0) {
      return Center(
          child: Text("Nothing in cart\nScan to start purchasing",
              textAlign: TextAlign.center));
    } else
      return cartItemList(Provider.of<Customer>(context).currentCart);
  }

  Container cartItemList(Cart cart) {
    return Container(
        padding: EdgeInsets.only(top: 10),
        child: ListView.builder(
            itemCount: cart.getCartSize(),
            itemBuilder: (context, index) {
              final Grocery grocery = cart.getGrocery(index);

              return Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  height: 150,
                  child: Stack(children: <Widget>[
                    cardBackground(context),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          height: 135,
                          width: MediaQuery.of(context).size.width - 45,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: ItemDetails(
                            grocery: grocery,
                            upOnPressed: () => _increaseQty(index),
                            downOnPressed: () => _decreaseQty(index),
                            removeOnTap: () => _removeItem(index),
                          ),
                        ))
                  ]));
            }));
  }

  void _removeItem(int index) {
    setState(
        () => Provider.of<Customer>(context).currentCart.removeGrocery(index));
  }

  void _decreaseQty(int index) {
    setState(() => Provider.of<Customer>(context)
        .currentCart
        .getGrocery(index)
        .quantity--);
  }

  void _increaseQty(int index) {
    setState(() => Provider.of<Customer>(context)
        .currentCart
        .getGrocery(index)
        .quantity++);
  }

  Align cardBackground(BuildContext context) {
    return Align(
        alignment: Alignment.bottomRight,
        child: Container(
            height: 135,
            width: MediaQuery.of(context).size.width - 45,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(8))));
  }

  Future _scanQR(BuildContext context) async {
    try {
      String qrResult = await BarcodeScanner.scan();

      setState(() {
        result = qrResult;
        Grocery temp = new Grocery();
        if (temp.setGroceryWithStringInput(result)) {
          if (!Provider.of<Customer>(context).currentCart.repeatCheck(temp)) {
            temp.quantity = 1;
            Provider.of<Customer>(context).currentCart.addGrocery(temp);
          }
        }
      });
    } on FormatException {
      setState(() =>
          result = "You pressed the back button before scanning anything");
    } catch (ex) {
      setState(() => result = "Unknown Error $ex");
    }
  }
}
