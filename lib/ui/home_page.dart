import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:neutral_creep_dev/ui/rewards_page.dart';
import 'package:neutral_creep_dev/ui/status_page.dart';

import 'components/home/components.dart';

import 'cart_page.dart';
import 'wallet_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[Flexible(child: getCurrentPage()), navbar()],
        ));
  }

  Widget getCurrentPage() {
    switch (index) {
      case 0:
        return CartPage();
        break;

      case 1:
        return WalletPage();
        break;

      case 2:
        return RewardsPage();
        break;

      case 3:
        return ProfilePage();
        break;

      case 4:
        return StatusPage();
        break;

      default:
        return Center(child: Text("ERROR"));
    }
  }

  Container navbar() {
    return Container(
        height: 70,
        width: double.infinity,
        color: Theme.of(context).splashColor,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              NavbarButton(
                  title: "home",
                  icon: FontAwesomeIcons.shoppingCart,
                  isSelected: index == 0 ? true : false,
                  onTap: () => setState(() => index = 0)),
              NavbarButton(
                  title: "wallet",
                  icon: FontAwesomeIcons.wallet,
                  isSelected: index == 1 ? true : false,
                  onTap: () => setState(() => index = 1)),
              NavbarButton(
                  title: "rewards",
                  icon: FontAwesomeIcons.gift,
                  isSelected: index == 2 ? true : false,
                  onTap: () => setState(() => index = 2)),
              NavbarButton(
                  title: "profile",
                  icon: Icons.person,
                  isSelected: index == 3 ? true : false,
                  onTap: () => setState(() => index = 3)),
              NavbarButton(
                  title: "status",
                  icon: FontAwesomeIcons.box,
                  isSelected: index == 4 ? true : false,
                  onTap: () => setState(() => index = 4)),
            ]));
  }
}
