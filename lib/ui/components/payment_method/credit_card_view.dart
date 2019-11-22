import 'package:flutter/material.dart';
import 'package:swipedetector/swipedetector.dart';

class CreditCardView extends StatelessWidget {
  final Function onPressed, onSwipeLeft, onSwipeRight;
  final List<Map> creditCards;
  final int cardIndex;
  final Color cardColor, nextCardColor;
  final bool canNav;

  const CreditCardView(
      {Key key,
      this.onPressed,
      this.creditCards,
      this.cardIndex,
      this.onSwipeLeft,
      this.onSwipeRight,
      this.cardColor,
      this.nextCardColor,
      this.canNav})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(),
          Column(children: <Widget>[
            getCreditCardView(context),
            SizedBox(height: 10),
            creditCards.length > 1
                ? Text("swipe left to change card",
                    style: TextStyle(fontSize: 15))
                : Container()
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            canNav
                ? IconButton(
                    icon: Icon(Icons.arrow_back_ios), onPressed: onPressed)
                : Container(),
            Container(
                width: 210,
                height: 70,
                decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    border: Border.all(
                        color: Theme.of(context).accentColor, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Center(
                    child: Text("Credit card",
                        style: TextStyle(
                            color: Theme.of(context).accentColor, fontSize: 30),
                        textAlign: TextAlign.left))),
            SizedBox(width: canNav ? 50 : 0)
          ]),
        ],
      ),
    );
  }

  Widget getCreditCardView(BuildContext context) {
    final double cardHeight = 200;
    final double cardWidth = 320;

    return Container(
        height: cardHeight,
        width: cardWidth,
        child: Stack(children: <Widget>[
          Align(
              alignment: Alignment.topRight,
              child: Container(
                  height: cardHeight - 5,
                  width: cardWidth - 5,
                  decoration: BoxDecoration(
                      color: nextCardColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 1)))),
          SwipeDetector(
              onSwipeLeft: onSwipeLeft,
              onSwipeRight: onSwipeRight,
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    height: cardHeight - 5,
                    width: cardWidth - 5,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 1)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          SizedBox(
                              height: 50,
                              width: 50,
                              child: Image.asset("assets/images/chip.png")),
                          SizedBox(height: 10),
                          Text(
                              "XXXX XXXX XXXX ${creditCards[cardIndex]["cardNum"].toString().substring(12)}",
                              style: TextStyle(
                                  fontSize: 20, fontFamily: "Space Mono")),
                          SizedBox(height: 10),
                          Row(children: <Widget>[
                            Text("expiry date: ",
                                style: TextStyle(
                                    fontSize: 15, fontFamily: "Space Mono")),
                            Text(
                                "${creditCards[cardIndex]["expiryMonth"]} / ${creditCards[0]["expiryYear"]}",
                                style: TextStyle(
                                    fontSize: 15, fontFamily: "Space Mono"))
                          ]),
                          Text("${creditCards[cardIndex]["fullName"]}",
                              style: TextStyle(
                                  fontSize: 20, fontFamily: "Space Mono"))
                        ]),
                  )))
        ]));
  }
}
