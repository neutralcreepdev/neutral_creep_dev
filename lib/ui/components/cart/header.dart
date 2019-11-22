import 'package:flutter/material.dart';

class CartHeader extends StatelessWidget {
  final Function onTap;
  final double avaliableAmount, cartTotalCost;
  const CartHeader(
      {Key key, this.onTap, this.avaliableAmount, this.cartTotalCost})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
        height: 150,
        width: double.infinity,
        color: Theme.of(context).backgroundColor,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text("Avaliable Creep Dollars:     ",
                              style: TextStyle(fontSize: 12)),
                          Text("\$${avaliableAmount.toStringAsFixed(2)}",
                              style: TextStyle(fontSize: 30, height: 0.5)),
                          Text("CD", style: TextStyle(fontSize: 12)),
                        ]),
                    SizedBox(height: 25),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text("Total cart cost:                      ",
                              style: TextStyle(fontSize: 12)),
                          Text("\$${cartTotalCost.toStringAsFixed(2)}",
                              style: TextStyle(fontSize: 30, height: 0.5)),
                          Text("CD", style: TextStyle(fontSize: 12)),
                        ])
                  ])),
              Container(
                  child: GestureDetector(
                onTap: onTap,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset("assets/images/scan-rd-3.png",
                          fit: BoxFit.none),
                      SizedBox(height: 5),
                      Text("Scan QR",
                          style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context).primaryColor)),
                    ]),
              ))
            ]));
  }
}
