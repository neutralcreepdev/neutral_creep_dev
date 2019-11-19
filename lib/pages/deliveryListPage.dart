import 'package:flutter/material.dart';
import 'package:neutral_creep_dev/helpers/color_helper.dart';
import 'package:neutral_creep_dev/services/dbService.dart';
import 'package:neutral_creep_dev/models/customer.dart';
import 'deliveryConfirmationPage.dart';
import 'package:neutral_creep_dev/models/delivery.dart';

class deliveryPage extends StatefulWidget {
  Customer customer;
  final DBService db;

  deliveryPage({this.customer, this.db});

  @override
  _State createState() => _State(customer: customer, db: db);
}

class _State extends State<deliveryPage> {
  dynamic result = "";
  Customer customer;
  final DBService db;

  _State({this.customer, this.db});

  var delivery;
  Map data = {};

  Future<void> getData() async {
    var delivery = await db.getTransaction(customer.id);
    return delivery;
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          //Back button
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
          backgroundColor: alablaster,
          centerTitle: true,
          title: Text(
            "Delivery Info",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 30,
                letterSpacing: 3),
          ),
          elevation: 0.2,
        ),
        body: Center(
          child: Column(children: [
            Expanded(
              child: FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Text('loading');
                  return Container(
                    child: ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        String status =
                            snapshot.data.documents[index]['status'].toString();

                        String tid = snapshot
                            .data.documents[index]["transactionId"]
                            .toString();
                        String name =
                            snapshot.data.documents[index]["name"].toString();
                        Map address =
                            Map.from(snapshot.data.documents[index]['address']);

                        DateTime date = snapshot
                            .data.documents[index]["dateOfTransaction"]
                            .toDate();

                        List<dynamic> items = new List<dynamic>();
                        items = snapshot.data.documents[index]['items'];

                        double totalAmount = double.parse(snapshot
                            .data.documents[index]['totalAmount']
                            .toString());

                        String collectType = snapshot.data.documents[index]["collectType"];
                        Map timeArrival ={};
                        if(collectType=="Delivery"){
                          timeArrival = snapshot.data.documents[index]["timeArrival"];
                        }


                        Order order = new Order(
                            orderID: tid,
                            name: name,
                            address: address,
                            date: date,
                            customerId: customer.id,
                            items: items,
                            totalAmount: totalAmount,collectType: collectType,timeArrival: timeArrival);

                        return Card(
                          child: ListTile(
                            onTap: () async {
                              var d = (snapshot.data.documents[index]
                                      ['dateOfTransaction'])
                                  .toDate();
                              dynamic result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DeliveryConfirmation(
                                        order: order, date: d, id: tid)),
                              );
                              if (result['Result'] == true) {
                              //if (result == true) {
                                db.setHistory(order, customer.id, tid);
                                db.setDeliveryStatus(customer.id, tid);
                                setState(() {});
                              }
                            },
                            title: Text("$tid"),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ]),
        ));
  }
}
