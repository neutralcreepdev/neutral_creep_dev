import 'package:flutter/material.dart';

class SelfCollectView extends StatelessWidget {
  final Function onPressed;
  const SelfCollectView({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: <Widget>[
      SizedBox(
          height: 150,
          width: 150,
          child: Image.asset("assets/images/bag.png", fit: BoxFit.contain)),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        SizedBox(width: 50),
        Container(
            width: 210,
            height: 70,
            decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                border:
                    Border.all(color: Theme.of(context).accentColor, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Center(
                child: Text("Self-collect",
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 30,
                        letterSpacing: 1.8,
                        fontFamily: "Air Americana"),
                    textAlign: TextAlign.left))),
        IconButton(icon: Icon(Icons.arrow_forward_ios), onPressed: onPressed)
      ]),
      Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.2),
          child: Text(
              "You will be notified when \nyour items are packed \nand ready for collection",
              style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 27,
                  letterSpacing: 1.62,
                  fontFamily: "Air Americana"),
              textAlign: TextAlign.center))
    ]));
  }
}
