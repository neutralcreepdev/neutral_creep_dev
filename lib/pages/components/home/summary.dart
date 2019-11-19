import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../helpers/color_helper.dart';
import '../../../models/models.dart';
import '../../../services/dbService.dart';
import '../../profilePage.dart';
import '../../summaryPage.dart';

class CartSummary extends StatelessWidget {
  final Customer customer;
  final DBService dbService;
  const CartSummary({Key key, this.customer, this.dbService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Text(
            "Total Cost: \$${customer.currentCart.getTotalCost().toStringAsFixed(2)}",
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
          ),
          Text(
            "GST 7%: \$${(customer.currentCart.getTotalCost() * 0.07).toStringAsFixed(2)}",
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
          ),
          Text(
            "Grand Total: \$${(customer.currentCart.getTotalCost() * 1.07).toStringAsFixed(2)}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(height: 10),
          ButtonTheme(
            height: 60,
            minWidth: 250,
            child: RaisedButton(
              color: heidelbergRed,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35)),
              child: Text(
                "SUMMARY",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              onPressed: () => handleSummaryButtonTapped(context),
            ),
          ),
        ],
      ),
    );
  }

  void handleSummaryButtonTapped(BuildContext context) {
    PurchaseTransaction transaction =
        new PurchaseTransaction(cart: customer.currentCart);

    if (customer.eWallet.creditCards.length == 0 ||
        customer.eWallet.eCreadits < 0) {
      Fluttertoast.showToast(
          msg: "Please add a credit Card or top up CreepDollars");
      dbService.getCard(customer).then((bankName) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                ProfilePage(customer: customer, db: dbService)));
      });
    } else {
      dbService.getTransactionId(customer.id).then((transactionId) {
        transaction.setId(transactionId.toString().padLeft(8, "0"));
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SummaryPage(
                transaction: transaction, customer: customer, db: dbService)));
      });
    }
  }
}
