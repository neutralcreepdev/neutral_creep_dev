import 'package:flutter/material.dart';

import '../../../models/models.dart';

class ItemCard extends StatelessWidget {
  final Customer customer;
  final int index;
  final Function upArrowOnTap, downArrowOnTap;
  const ItemCard(
      {Key key,
      this.customer,
      this.index,
      this.upArrowOnTap,
      this.downArrowOnTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              itemImage(),
              SizedBox(width: 10),
              itemInfo(context)
            ],
          ),
          itemQuntity()
        ],
      ),
    );
  }

  Container itemImage() {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Stack(
        children: <Widget>[
          Center(
              child: Text(
            "Image not found",
            style: TextStyle(fontSize: 10),
          )),
          customer.currentCart.getGrocery(index).image != null
              ? customer.currentCart.getGrocery(index).image
              : Container(),
        ],
      ),
    );
  }

  Column itemQuntity() {
    return Column(
      children: <Widget>[
        FlatButton(child: Icon(Icons.arrow_drop_up), onPressed: upArrowOnTap),
        Text("${customer.currentCart.getGrocery(index).quantity}"),
        FlatButton(
            child: (customer.currentCart.getGrocery(index).quantity > 1)
                ? Icon(Icons.arrow_drop_down)
                : Icon(Icons.clear),
            onPressed: downArrowOnTap),
      ],
    );
  }

  Container itemInfo(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 210,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("${customer.currentCart.getGrocery(index).name}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          Text(
            "${customer.currentCart.getGrocery(index).description}",
            style: TextStyle(fontSize: 11),
            maxLines: 2,
          ),
          SizedBox(height: 10),
          Text(
              "\$${customer.currentCart.getGrocery(index).cost.toStringAsFixed(2)}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
        ],
      ),
    );
  }
}
