import 'package:flutter/material.dart';
import 'package:neutral_creep_dev/models/models.dart';
import 'package:provider/provider.dart';

import 'components/status/components.dart';

class StatusPage extends StatefulWidget {
  StatusPage({Key key}) : super(key: key);

  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  int selectorIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: <Widget>[
      StatusHeader(),
      SelectorRow(
          selectorIndex: selectorIndex,
          allOnPressed: () => setState(() => selectorIndex = 0),
          selfOnPressed: () => setState(() => selectorIndex = 1),
          deliveryOnPressed: () => setState(() => selectorIndex = 2)),
      Flexible(
          child: FutureBuilder(
              future: StatusLogic.getItems(context),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: Text("loading"));
                List<Map> orders = snapshot.data;

                return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      if (selectorIndex == 1) {
                        if (orders[index]["collectType"] == "Self-Collect")
                          return OrderItemCard(
                              order: orders[index],
                              onTap: () =>
                                  handleItemTapped(context, orders[index]));
                      }

                      if (selectorIndex == 2) {
                        if (orders[index]["collectType"] == "Delivery")
                          return OrderItemCard(
                              order: orders[index],
                              onTap: () =>
                                  handleItemTapped(context, orders[index]));
                      }

                      if (selectorIndex == 0)
                        return OrderItemCard(
                            order: orders[index],
                            onTap: () =>
                                handleItemTapped(context, orders[index]));

                      return Container();
                    });
              }))
    ]));
  }

  void handleItemTapped(BuildContext context, Map order) {
    StatusLogic.itemDialog(context, order, Provider.of<Customer>(context));
    setState(() {});
  }
}
