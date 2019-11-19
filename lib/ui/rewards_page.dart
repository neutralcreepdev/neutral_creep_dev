import 'package:flutter/material.dart';
import 'package:neutral_creep_dev/models/models.dart';
import 'package:provider/provider.dart';
import 'components/rewards/components.dart';

class RewardsPage extends StatefulWidget {
  RewardsPage({Key key}) : super(key: key);

  @override
  _RewardsPageState createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 80),
            Container(
                height: 150,
                width: double.infinity,
                color: Theme.of(context).backgroundColor,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Avaliable creep dollars:",
                          style: TextStyle(fontSize: 15)),
                      SizedBox(height: 10),
                      Text("${Provider.of<Customer>(context).eWallet.points}",
                          style: TextStyle(
                              fontSize: 70,
                              color: Theme.of(context).primaryColor))
                    ])),
            SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text("rewards available:",
                    style: TextStyle(color: Colors.grey))),
            Flexible(
              child: Container(
                child: Column(children: <Widget>[
                  AvaliableRewards(
                      rewardAmount: 5,
                      isAvailable: isRewardAvailable(context, 5),
                      onTap: () => handleRedeemReward(context, (5).toDouble())),
                  AvaliableRewards(
                      rewardAmount: 10,
                      isAvailable: isRewardAvailable(context, 10),
                      onTap: () => handleRedeemReward(context, 10.0)),
                  AvaliableRewards(
                      rewardAmount: 15,
                      isAvailable: isRewardAvailable(context, 15),
                      onTap: () => handleRedeemReward(context, 15.0)),
                  AvaliableRewards(
                      rewardAmount: 20,
                      isAvailable: isRewardAvailable(context, 20),
                      onTap: () => handleRedeemReward(context, 20.0)),
                ]),
              ),
            )
          ]),
    );
  }

  void handleRedeemReward(BuildContext context, double reward) {
    RewardsLogic.handleRedeem(context, reward).then((isSucessful) {
      if (isSucessful) {
        setState(() {});
      } else {
        RewardsLogic.errorDialog(context);
      }
    });
  }

  bool isRewardAvailable(BuildContext context, int amount) {
    return Provider.of<Customer>(context).eWallet.points > (amount * 50);
  }
}
