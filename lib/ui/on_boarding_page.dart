import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:neutral_creep_dev/ui/home_page.dart';

class OnBoardingPage extends StatefulWidget {
  OnBoardingPage({Key key}) : super(key: key);

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
                child: Column(children: <Widget>[
              header(),
              index < 2 ? emptyCart() : addedCart(),
            ])),
            navbar()
          ]),
      GestureDetector(
          child: getPage(),
          onTap: () {
            setState(() {
              index++;
              if (index == 4) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              }
            });
          })
    ]));
  }

  Container getPage() {
    switch (index) {
      case 0:
        return firstPage();
        break;
      case 1:
        return secondPage();
        break;
      case 2:
        return thirdPage();
        break;
      case 3:
        return forthPage();
        break;
      default:
        return Container();
    }
  }

  Container forthPage() {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black.withOpacity(0.9),
        child: Stack(children: <Widget>[
          Align(
              alignment: Alignment(0.9, 0.99),
              child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      color: Colors.white),
                  child: navbarButton("status", FontAwesomeIcons.box))),
          Align(
              alignment: Alignment(0.35, 0.85),
              child: Text(
                "View the status of all\nyour purchases here",
                style: TextStyle(color: Colors.white),
              ))
        ]));
  }

  Container thirdPage() {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black.withOpacity(0.9),
        child: Stack(children: <Widget>[
          Align(alignment: Alignment(1, -0.55), child: item()),
          Align(
              alignment: Alignment(0, -0.70),
              child: Text(
                "When an item is added it will appear here",
                style: TextStyle(color: Colors.white),
              ))
        ]));
  }

  Container secondPage() {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black.withOpacity(0.9),
        child: Stack(children: <Widget>[
          Align(
              alignment: Alignment(1, -0.85),
              child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      color: Colors.white),
                  child: Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset("assets/images/scan-rd-3.png",
                              fit: BoxFit.none),
                          SizedBox(height: 5),
                          Text("scan qr", style: TextStyle(fontSize: 10)),
                        ]),
                  ))),
          Align(
              alignment: Alignment(0.3, -0.80),
              child: Text(
                "Scan qr code to add\nan item in the cart",
                style: TextStyle(color: Colors.white),
              ))
        ]));
  }

  Container firstPage() {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black.withOpacity(0.9),
        child: Stack(children: <Widget>[
          Align(
              alignment: Alignment(-0.5, 0.99),
              child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      color: Colors.white),
                  child: navbarButton("wallet", FontAwesomeIcons.wallet))),
          Align(
              alignment: Alignment(0.5, 0.8),
              child: Text(
                "TOP UP AND MANAGE your\nCreep Dollars in the wallet",
                style: TextStyle(color: Colors.white),
              ))
        ]));
  }

  Flexible addedCart() {
    return Flexible(
        child: Container(
      child: item(),
    ));
  }

  Container item() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        height: 150,
        child: Stack(children: <Widget>[
          Align(
              alignment: Alignment.bottomRight,
              child: Container(
                  height: 135,
                  width: MediaQuery.of(context).size.width - 45,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8)))),
          Align(
              alignment: Alignment.topLeft,
              child: Container(
                  height: 135,
                  width: MediaQuery.of(context).size.width - 45,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(children: <Widget>[
                          SizedBox(
                              height: 100,
                              width: 100,
                              child: Image.asset(
                                "assets/images/apples-2.png",
                                fit: BoxFit.none,
                              )),
                          SizedBox(width: 20),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("banana", style: TextStyle(fontSize: 20)),
                                Text("Farm pte ltd",
                                    style: TextStyle(fontSize: 15)),
                                SizedBox(height: 5),
                                Text("Cost: \$2.40",
                                    style: TextStyle(fontSize: 20)),
                              ])
                        ]),
                        Row(children: <Widget>[
                          Text("QTY:", style: TextStyle(fontSize: 20)),
                          Column(children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.arrow_drop_up),
                                onPressed: () {}),
                            Text("1"),
                            IconButton(
                                icon: Icon(Icons.arrow_drop_down),
                                onPressed: () {})
                          ])
                        ])
                      ])))
        ]));
  }

  Flexible emptyCart() {
    return Flexible(
      child: Container(
          child:
              Center(child: Text("Nothing in cart\nScan to start purchasing"))),
    );
  }

  Container header() {
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
                          Text("\$0.00",
                              style: TextStyle(fontSize: 30, height: 0.5)),
                          Text("cd", style: TextStyle(fontSize: 12)),
                        ]),
                    SizedBox(height: 25),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text("total cart cost:                    ",
                              style: TextStyle(fontSize: 12)),
                          Text("\$0.00",
                              style: TextStyle(fontSize: 30, height: 0.5)),
                          Text("cd", style: TextStyle(fontSize: 12)),
                        ])
                  ])),
              Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    Image.asset("assets/images/scan-rd-3.png",
                        fit: BoxFit.none),
                    SizedBox(height: 5),
                    Text("scan qr", style: TextStyle(fontSize: 10)),
                  ]))
            ]));
  }

  Container navbar() {
    return Container(
        height: 70,
        width: double.infinity,
        color: Theme.of(context).splashColor,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              navbarButton("home", FontAwesomeIcons.shoppingCart),
              navbarButton("wallet", FontAwesomeIcons.wallet),
              navbarButton("rewards", FontAwesomeIcons.gift),
              navbarButton("profile", Icons.person),
              navbarButton("status", FontAwesomeIcons.box),
            ]));
  }

  Container navbarButton(String title, IconData icon) {
    return Container(
        height: 50,
        width: 50,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 22, color: Colors.black),
              SizedBox(height: 5),
              Text(title, style: TextStyle(fontSize: 10, color: Colors.black))
            ]));
  }
}
