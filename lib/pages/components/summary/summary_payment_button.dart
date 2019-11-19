import 'package:flutter/material.dart';

import '../../../helpers/color_helper.dart';
import '../../../models/models.dart';
import '../../paymentPage.dart';
import '../../../services/dbService.dart';
import 'delivery_time_dialog.dart';

class SummaryPaymentButton extends StatelessWidget {
  final Customer customer;
  final PurchaseTransaction transaction;
  final DBService dbService;
  final String time;
  final String dropDownValue;
  final Function onChnage;

  const SummaryPaymentButton(
      {Key key,
      this.customer,
      this.transaction,
      this.dbService,
      this.time,
      this.dropDownValue,
      this.onChnage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  value: dropDownValue,
                  items: [
                    DropdownMenuItem(child: Text("Self-Collect"), value: "1"),
                    customer.address != null
                        ? DropdownMenuItem(
                            child: Text(
                                "${customer.address["street"]}, ${customer.address["unit"]}, S${customer.address["postalCode"]}"),
                            value: "2")
                        : null
                  ],
                  onChanged: onChnage),
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
                  if (dropDownValue == "2") {
                    await handleHasAddress(context);
                  } else
                    handleSelfCollect(context);
                }),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  void handleSelfCollect(BuildContext context) {
    dbService.getEWalletData(customer.id).then((eWallet) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PaymentPage(
                db: dbService,
                transaction: transaction,
                customer: customer,
                collectionMethod: dropDownValue,
                eWallet: eWallet,
                deliveryTime: new Map(),
              )));
    });
  }

  Future handleHasAddress(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return MyDialog(
              time: time,
              transaction: transaction,
              customer: customer,
              db: dbService,
              dropDownMenuValue: dropDownValue);
        });
  }
}
