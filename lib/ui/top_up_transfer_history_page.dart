import 'package:flutter/material.dart';
import 'package:neutral_creep_dev/models/models.dart';
import 'package:provider/provider.dart';
import 'components/top_up_transfer_history/components.dart';

class TopUpTransferHistoryPage extends StatefulWidget {
  TopUpTransferHistoryPage({Key key}) : super(key: key);

  @override
  _TopUpTransferHistoryPageState createState() =>
      _TopUpTransferHistoryPageState();
}

class _TopUpTransferHistoryPageState extends State<TopUpTransferHistoryPage> {
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
                  height: 150,
                  padding: EdgeInsets.fromLTRB(30, 30, 0, 0),
                  child: Text("History",
                      style: TextStyle(fontSize: 60, color: Colors.blue[500]))),
              Container(
                  height: MediaQuery.of(context).size.height - 150 - 98,
                  child: FutureBuilder(
                    future: TopUpTransferHistoryLogic.getHistory(
                        Provider.of<Customer>(context)),
                    builder: (context, snapshot) {
                      List<Map> data = snapshot.data;

                      if (data != null) {
                        if (data.length < 1)
                          return Center(
                              child:
                                  Text("Waiting for first wallet transaction"));
                        if (data != null) {
                          return ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return HistoryList(
                                    history: data[index],
                                    onTap: () =>
                                        TopUpTransferHistoryLogic.historyDialog(
                                            context, data[index]));
                              });
                        }
                      }

                      return Center(child: Text("Loading"));
                    },
                  ))
            ])));
  }
}
