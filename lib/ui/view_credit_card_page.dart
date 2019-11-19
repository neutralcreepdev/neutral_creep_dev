import 'package:flutter/material.dart';
import 'package:neutral_creep_dev/models/models.dart';
import 'package:provider/provider.dart';
import 'add_credit_card_page.dart';
import 'components/credit_card/component.dart';

class ViewCreditCardPage extends StatefulWidget {
  ViewCreditCardPage({Key key}) : super(key: key);

  @override
  _ViewCreditCardPageState createState() => _ViewCreditCardPageState();
}

class _ViewCreditCardPageState extends State<ViewCreditCardPage> {
  int cardIndex = 0;
  final List<Color> cardColors = [
    Colors.blue,
    Colors.grey,
    Colors.yellow,
    Colors.pinkAccent
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).canvasColor,
            elevation: 0,
            shape: Border(
                bottom: BorderSide(
                    color: Theme.of(context).primaryColor, width: 0.2)),
            leading: IconButton(
                icon: Icon(Icons.arrow_back, size: 35, color: Colors.black),
                onPressed: () => Navigator.pop(context))),
        body: Column(
          children: <Widget>[
            Flexible(
              child: Container(
                  color: Theme.of(context).backgroundColor,
                  child: getCardView(context)),
            ),
            AddNewCreditCardButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddNewCreditCardPage()))),
          ],
        ));
  }

  Column creditCardView(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: <
        Widget>[
      SizedBox(width: MediaQuery.of(context).size.width),
      Text("swipe to view your other cards", style: TextStyle(fontSize: 15)),
      creditCard(
          Provider.of<Customer>(context).eWallet.creditCards.length, context),
    ]);
  }

  Widget getCardView(BuildContext context) {
    if (Provider.of<Customer>(context).eWallet.creditCards.length < 1) {
      return noCreditCardView();
    } else {
      return creditCardView(context);
    }
  }

  Center noCreditCardView() {
    return Center(child: Text("You have no credit card added"));
  }

  CreditCardView creditCard(int cardSize, BuildContext context) {
    return CreditCardView(
        cardIndex: cardIndex,
        cardColor: cardColors[cardIndex % 4],
        nextCardColor: cardColors[getNextCardIndex(cardSize)],
        creditCards: Provider.of<Customer>(context).eWallet.creditCards,
        onSwipeLeft: cardSize > 1 ? () => handleSwipLeft(cardSize) : null,
        onSwipeRight: cardSize > 1 ? () => handleSwipRight(cardSize) : null);
  }

  int getNextCardIndex(int size) {
    if (cardIndex == (size - 1)) {
      return 0;
    } else
      return (cardIndex + 1) % 4;
  }

  void handleSwipRight(int size) {
    setState(() {
      if (cardIndex == 0) {
        cardIndex = size - 1;
      } else
        cardIndex--;
    });
  }

  void handleSwipLeft(int size) {
    setState(() {
      if (cardIndex == (size - 1)) {
        cardIndex = 0;
      } else
        cardIndex++;
    });
  }
}
