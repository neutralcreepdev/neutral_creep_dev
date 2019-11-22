import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neutral_creep_dev/models/models.dart';
import 'package:provider/provider.dart';
import 'components/top_up/components.dart';

class TopUpPage extends StatefulWidget {
  TopUpPage({Key key}) : super(key: key);

  @override
  _TopUpPageState createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  final _controller = TextEditingController();
  int cardIndex = 0;
  final List<Color> cardColors = [
    Colors.blue,
    Colors.grey,
    Colors.yellow,
    Colors.pinkAccent
  ];

  @override
  Widget build(BuildContext context) {
    int cardSize = Provider.of<Customer>(context).eWallet.creditCards.length;
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
        body: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height - 98,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).backgroundColor,
              child: Column(children: <Widget>[
                Flexible(
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Top up amount:"),
                              SizedBox(height: 20),
                              TextField(
                                controller: _controller,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 30),
                                decoration:
                                    InputDecoration(hintText: "Enter here"),
                              ),
                              SizedBox(height: 50),
                              creditCard(cardSize, context),
                            ]))),
                TopUpButton(onPressed: () => handleTopUpButtonTapped())
              ])),
        ));
  }

  void handleTopUpButtonTapped() {
    List<Map> creditCard = Provider.of<Customer>(context).eWallet.creditCards;
    String bankInfo = creditCard[cardIndex]["bankName"] +
        "|" +
        creditCard[cardIndex]["cardNum"];
    try {
      if (_controller.text.isNotEmpty) {
        double topUpAmount = double.parse(_controller.text);

        TopUpLogic.handleTopUpCreepDollars(
                context: context,
                bankInfo: bankInfo,
                customer: Provider.of<Customer>(context),
                topUpAmount: topUpAmount)
            .then((isSuccessful) {
          if (isSuccessful) {
            Navigator.pop(context);
            Provider.of<Customer>(context).eWallet.addCreepDollar(topUpAmount);
          } else {
            TopUpLogic.errorDialog(context);
          }
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Invalid Input");
      _controller.text = "";
    }
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
