import 'package:flutter/material.dart';
import 'package:swipedetector/swipedetector.dart';

class CreditCardView extends StatelessWidget {
  final double cardHeight = 200;
  final double cardWidth = 320;
  final Function onSwipeLeft, onSwipeRight;
  final List<Map> creditCards;
  final int cardIndex;
  final Color cardColor, nextCardColor;
  const CreditCardView(
      {Key key,
      this.onSwipeLeft,
      this.onSwipeRight,
      this.creditCards,
      this.cardIndex,
      this.cardColor,
      this.nextCardColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                          SizedBox(height: 20),
                          Text(
                              "XXXX XXXX XXXX ${creditCards[cardIndex]["cardNum"].toString().substring(12)}",
                              style: TextStyle(fontSize: 25)),
                          SizedBox(height: 10),
                          Row(children: <Widget>[
                            Text("expiry date:   ",
                                style: TextStyle(fontSize: 15)),
                            Text(
                                "${creditCards[cardIndex]["expiryMonth"]} / ${creditCards[0]["expiryYear"]}",
                                style: TextStyle(fontSize: 20))
                          ]),
                          Text("${creditCards[cardIndex]["fullName"]}",
                              style: TextStyle(fontSize: 20))
                        ]),
                  )))
        ]));
  }
}
