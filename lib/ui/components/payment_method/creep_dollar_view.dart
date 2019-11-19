import 'package:flutter/material.dart';

class CreepDollarView extends StatelessWidget {
  final Function onPressed;
  final double availableCD, cartCost;
  const CreepDollarView(
      {Key key, this.onPressed, this.availableCD, this.cartCost})
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
                Text("Avaliable Creep Dollars:",
                    style: TextStyle(fontSize: 15)),
                SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text("\$${availableCD.toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 60)),
                      Text("cd", style: TextStyle(fontSize: 30)),
                    ]),
                SizedBox(height: 30),
                Text("Total Cart Cost:", style: TextStyle(fontSize: 15)),
                SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text("\$${cartCost.toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 60)),
                      Text("cd", style: TextStyle(fontSize: 30)),
                    ]),
                SizedBox(height: 50),
                Text(
                  "using creep dollars will earn your points\nwhich can be used to redeem rewards",
                  style: TextStyle(
                      fontSize: 15, color: Colors.black.withOpacity(0.5)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            SizedBox(width: 50),
            Container(
                width: 210,
                height: 70,
                decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    border: Border.all(
                        color: Theme.of(context).accentColor, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Center(
                    child: Text("creep dollar",
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 30,
                            letterSpacing: 1.8,
                            fontFamily: "Air Americana"),
                        textAlign: TextAlign.left))),
            IconButton(
                icon: Icon(Icons.arrow_forward_ios), onPressed: onPressed)
          ]),
        ],
      ),
    );
  }
}
