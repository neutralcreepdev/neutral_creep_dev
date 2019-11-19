import 'package:flutter/material.dart';

class AvaliableRewards extends StatelessWidget {
  final double height = 110;
  final int rewardAmount;
  final Function onTap;
  final bool isAvailable;

  const AvaliableRewards(
      {Key key, this.rewardAmount, this.onTap, this.isAvailable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: isAvailable ? onTap : null,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            height: height,
            child: Stack(children: <Widget>[
              Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                      height: height - 15,
                      width: MediaQuery.of(context).size.width - 45,
                      decoration: BoxDecoration(
                          color: isAvailable
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).primaryColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8)))),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                    height: height - 15,
                    width: MediaQuery.of(context).size.width - 45,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: isAvailable
                            ? Colors.white
                            : Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("$rewardAmount Creep dollars",
                            style: TextStyle(fontSize: 40)),
                        Text("${rewardAmount * 50} points is required",
                            style: TextStyle(fontSize: 20))
                      ],
                    )),
              )
            ])));
  }
}
