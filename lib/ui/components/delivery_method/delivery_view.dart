import 'package:flutter/material.dart';

class DeliveryView extends StatelessWidget {
  final Function onPressed, onTap;
  final Map address;
  final String deliveryTime;
  const DeliveryView(
      {Key key, this.onPressed, this.onTap, this.address, this.deliveryTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(children: <Widget>[
          SizedBox(
              height: 150,
              width: 150,
              child: Image.asset("assets/images/DeliveryTruck.png",
                  fit: BoxFit.contain)),
          navigateToSelfCollectButton(context),
          SizedBox(height: 40),
          changeDeliveryTime(context),
          SizedBox(height: 20),
          deliveryAddress(context),
        ]));
  }

  Row deliveryAddress(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Icon(Icons.home, size: 60),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            text(context, "delivery to", 12),
            text(context, "${address["street"]}", 25),
            text(context, "Unit No: ${address["unit"]}", 15),
            text(context, "Postal Code: ${address["postalCode"]}", 15),
          ],
        ),
      ],
    );
  }

  Text text(BuildContext context, String title, double size) {
    return Text(title,
        style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: size,
            letterSpacing: 1.62,
            fontFamily: "Air Americana"));
  }

  String getDeliveryTime() {
    if (deliveryTime == null) {
      return "No Delivery Time";
    } else {
      return deliveryTime;
    }
  }

  Row changeDeliveryTime(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      Icon(Icons.access_time, size: 60),
      SizedBox(width: 10),
      GestureDetector(
          onTap: onTap,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                text(context, getDeliveryTime(), 30),
                Text("Tap To Change",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 15,
                        letterSpacing: 1.62,
                        fontFamily: "Air Americana"))
              ]))
    ]);
  }

  Row navigateToSelfCollectButton(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: onPressed),
      Container(
          width: 210,
          height: 70,
          decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              border:
                  Border.all(color: Theme.of(context).accentColor, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Center(
              child: Text("Delivery",
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 30,
                      letterSpacing: 1.8,
                      fontFamily: "Air Americana"),
                  textAlign: TextAlign.left))),
      SizedBox(width: 50)
    ]);
  }
}
