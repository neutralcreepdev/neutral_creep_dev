import 'package:flutter/material.dart';
import 'package:neutral_creep_dev/models/models.dart';

class ItemList extends StatelessWidget {
  final PurchaseTransaction transaction;
  const ItemList({Key key, this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Order ID: ${transaction.id}",
                style: TextStyle(
                    fontSize: 20, decoration: TextDecoration.underline)),
            SizedBox(height: 30),
            header(context),
            Divider(height: 2, color: Theme.of(context).accentColor),
            itemList(),
          ]),
    );
  }

  Expanded itemList() {
    return Expanded(
        child: ListView.builder(
            itemCount: transaction.cart.getCartSize(),
            itemBuilder: (context, index) {
              Grocery grocery = transaction.cart.getGrocery(index);
              return Column(children: <Widget>[
                Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(children: <Widget>[
                      SizedBox(width: 10),
                      Container(
                          width: MediaQuery.of(context).size.width / 8,
                          child: Text("${index + 1}",
                              style: TextStyle(fontSize: 15))),
                      Container(
                          width: MediaQuery.of(context).size.width / 8 * 4 - 50,
                          child: Text("${grocery.name}",
                              style: TextStyle(fontSize: 15))),
                      SizedBox(width: 10),
                      Container(
                          width: MediaQuery.of(context).size.width / 8 - 5,
                          child: Text("${grocery.quantity}",
                              style: TextStyle(fontSize: 15))),
                      Container(
                          child: Text(
                              "\$${grocery.getTotalCost().toStringAsFixed(2)}",
                              style: TextStyle(fontSize: 15)))
                    ]))
              ]);
            }));
  }

  Row header(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(width: 10),
        Container(
            width: MediaQuery.of(context).size.width / 8,
            child: Text("No.", style: TextStyle(fontSize: 20))),
        Container(
          width: MediaQuery.of(context).size.width / 8 * 4 - 60,
          child: Text("Item", style: TextStyle(fontSize: 20)),
        ),
        SizedBox(width: 10),
        Container(
          width: MediaQuery.of(context).size.width / 8 + 5,
          child: Text("Qty", style: TextStyle(fontSize: 20)),
        ),
        Container(
          child: Text("Cost", style: TextStyle(fontSize: 20)),
        )
      ],
    );
  }
}
