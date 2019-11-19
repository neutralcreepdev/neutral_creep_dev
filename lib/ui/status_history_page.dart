import 'package:flutter/material.dart';
import 'package:neutral_creep_dev/models/models.dart';
import 'package:provider/provider.dart';

import 'components/status_history/components.dart';

class StatusHistoryPage extends StatefulWidget {
  StatusHistoryPage({Key key}) : super(key: key);

  @override
  _StatusHistoryPageState createState() => _StatusHistoryPageState();
}

class _StatusHistoryPageState extends State<StatusHistoryPage> {
  int selectorIndex = 0;
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
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).backgroundColor,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
              Container(
                  height: 120,
                  padding: EdgeInsets.fromLTRB(30, 30, 0, 0),
                  child: Text("History",
                      style: TextStyle(fontSize: 70, color: Colors.blue[500]))),
              SelectorRow(
                  selectorIndex: selectorIndex,
                  allOnPressed: () => setState(() => selectorIndex = 0),
                  selfOnPressed: () => setState(() => selectorIndex = 1),
                  deliveryOnPressed: () => setState(() => selectorIndex = 2)),
              Flexible(
                  child: FutureBuilder(
                      future: StatusHistoryLogic.getItems(context),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Center(child: Text("loading"));
                        List<Map> orders = snapshot.data;

                        return ListView.builder(
                            itemCount: orders.length,
                            itemBuilder: (context, index) {
                              if (selectorIndex == 1) {
                                if (orders[index]["collectType"] ==
                                    "Self-Collect")
                                  return OrderItemCard(
                                      order: orders[index],
                                      onTap: () => handleItemTapped(
                                          context, orders[index]));
                              }

                              if (selectorIndex == 2) {
                                if (orders[index]["collectType"] == "Delivery")
                                  return OrderItemCard(
                                      order: orders[index],
                                      onTap: () => handleItemTapped(
                                          context, orders[index]));
                              }

                              if (selectorIndex == 0)
                                return OrderItemCard(
                                    order: orders[index],
                                    onTap: () => handleItemTapped(
                                        context, orders[index]));

                              return Container();
                            });
                      }))
            ])));
  }

  void handleItemTapped(BuildContext context, Map order) {
    StatusHistoryLogic.itemDialog(
        context, order, Provider.of<Customer>(context));
    setState(() {});
  }
}
