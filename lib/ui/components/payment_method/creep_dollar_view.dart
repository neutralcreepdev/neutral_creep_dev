import 'package:flutter/material.dart';

class CreepDollarView extends StatelessWidget {
  final Function onPressed;
  final double availableCD, cartCost;
  final bool canNav;
  const CreepDollarView(
      {Key key, this.onPressed, this.availableCD, this.cartCost, this.canNav})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(),
          Container(
            child: Column(
              children: <Widget>[
                Text("Balance:", style: TextStyle(fontSize: 15)),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text("\$${availableCD.toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 60)),
                      Text("CD", style: TextStyle(fontSize: 30)),
                    ]),
                SizedBox(height: 30),
                Text("Total:", style: TextStyle(fontSize: 15)),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text("\$${cartCost.toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 60)),
                      Text("CD", style: TextStyle(fontSize: 30)),
                    ]),
                SizedBox(height: 50),
                Text(
                  "*Using Creep Dollars will earn your points\nwhich can be used to redeem rewards",
                  style: TextStyle(
                      fontSize: 15, color: Colors.black.withOpacity(0.3)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            SizedBox(width: canNav ? 50 : 0),
            Container(
                width: 210,
                height: 70,
                decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    border: Border.all(
                        color: Theme.of(context).accentColor, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Center(
                    child: Text("Creep Dollar",
                        style: TextStyle(
                            color: Theme.of(context).accentColor, fontSize: 25),
                        textAlign: TextAlign.left))),
            canNav
                ? IconButton(
                    icon: Icon(Icons.arrow_forward_ios), onPressed: onPressed)
                : Container()
          ]),
        ],
      ),
    );
  }
}
