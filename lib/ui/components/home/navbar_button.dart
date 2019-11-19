import 'package:flutter/material.dart';

class NavbarButton extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  final String title;
  final bool isSelected;
  const NavbarButton(
      {Key key, this.onTap, this.icon, this.isSelected, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            height: 50,
            width: 50,
            decoration: isSelected
                ? BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(8))
                : BoxDecoration(),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(icon,
                      size: 22,
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.black),
                  SizedBox(height: 5),
                  Text(title,
                      style: TextStyle(
                          fontSize: 10,
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.black))
                ])));
  }
}
