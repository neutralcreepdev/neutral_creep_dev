import 'package:flutter/material.dart';

import '../../../models/models.dart';

class ItemDetails extends StatelessWidget {
  final PurchaseTransaction transaction;
  final int index;
  const ItemDetails({Key key, this.transaction, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(width: 10),
            Container(
                width: MediaQuery.of(context).size.width / 8,
                child: Text("${index + 1}", style: TextStyle(fontSize: 18))),
            Container(
              width: MediaQuery.of(context).size.width / 8 * 4 - 30,
              child: Text("${transaction.getCart().getGrocery(index).name}",
                  style: TextStyle(fontSize: 18)),
            ),
            SizedBox(width: 10),
            Container(
              width: MediaQuery.of(context).size.width / 8 + 10,
              child: Text("${transaction.getCart().getGrocery(index).quantity}",
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
  }
}
