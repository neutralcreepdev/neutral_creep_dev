import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:neutral_creep_dev/models/delivery.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'dart:async';

import '../helpers/color_helper.dart';
import '../models/customer.dart';
import '../services/authService.dart';
import '../services/dbService.dart';

import './profilePage.dart';
import './startPage.dart';
import './deliveryStatus.dart';

class DeliveryCheckPage extends StatefulWidget {
  final Customer customer;
  final AuthService auth;
  final DBService db;

  DeliveryCheckPage({this.customer, this.auth, this.db});

  _DeliveryCheckPageState createState() =>
      _DeliveryCheckPageState(customer: customer, auth: auth, db: db);
}

class _DeliveryCheckPageState extends State<DeliveryCheckPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Customer customer;
  final AuthService auth;
  final DBService db;
  QuerySnapshot addDoc;
  String result = "";
  Color bgColor = Colors.white;
  bool selected = false;
  var _dropDownValue = "1";

  //
  _DeliveryCheckPageState({this.customer, this.auth, this.db});

  final databaseReference = Firestore.instance;

  Future getDeliveries() async {
    //To change to own customerId
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore
        .collection('users')
        .document(customer.id)
        .collection('Delivery')
        .getDocuments();
    return qn;
  }

  Future getSelfCollect() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore
        .collection('users')
        .document(customer.id)
        .collection('Self-Collect')
        .getDocuments();
    return qn;
  }

  int filterItemCounts(int deliverySize, int selfCollectSize, int totalSize) {
    int temp = 0;
    if (_dropDownValue == "1")
      temp = totalSize;
    else if (_dropDownValue == "2")
      temp = deliverySize;
    else if (_dropDownValue == "3") temp = selfCollectSize;

    return temp;
  }

  _setCardColor(int index) {
    setState(() {
      _selectedIndex = index;
      _selected = true;
    });
  }

  Text filterText(Delivery totalList, Delivery deliveryList,
      Delivery selfCollectList, int index) {
    Text text;
    if (_dropDownValue == "1")
      text = new Text(totalList.getOrders(index).toString());
    else if (_dropDownValue == "2")
      text = new Text(deliveryList.getOrders(index).toString());
    else
      text = new Text(selfCollectList.getOrders(index).toString());

    return text;
  }

  int _selectedIndex = -1; //change to -1
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: alablaster,
        centerTitle: true,
        elevation: 0.2,
        iconTheme: IconThemeData(color: heidelbergRed, size: 30),
        title: Text(
          "Order Status",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30,
              letterSpacing: 3),
        ),
      ),
      // Body =================================================
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: whiteSmoke,
        child: Column(
          children: <Widget>[
            DropdownButton(
              isExpanded: true,
              value: _dropDownValue,
              items: [
                DropdownMenuItem(
                  child: Text("All"),
                  value: "1",
                ),
                DropdownMenuItem(
                  child: Text("Deliveries"),
                  value: "2",
                ),
                DropdownMenuItem(
                  child: Text("Self-Collect"),
                  value: "3",
                )
              ],
              onChanged: (value) {
                setState(() {
                  _dropDownValue = value;
                });
              },
            ),
            FutureBuilder(
                future: getDeliveries(),
                builder: (context, snapshot) {
                  return FutureBuilder(
                    future: getSelfCollect(),
                    builder: (context, snapshot2) {
                      Delivery _deliveryList = new Delivery();
                      Delivery _selfCollectList = new Delivery();
                      Delivery _totalList = new Delivery();

                      if (!snapshot.hasData) return Text('Loading...');
                      int deliverySize = snapshot.data.documents.length;
                      int selfCollectSize = snapshot2.data.documents.length;
                      int totalSize = deliverySize + selfCollectSize;

                      for (int i = 0; i < snapshot.data.documents.length; i++) {
                        String orderIDTemp =
                            snapshot.data.documents[i]['transactionId'];
                        Map addressTemp =
                            Map.from(snapshot.data.documents[i]['address']);
                        String nameTemp = snapshot.data.documents[i]['name'];
                        DateTime dateTemp = snapshot
                            .data.documents[i]['dateOfTransaction']
                            .toDate();
                        List<dynamic> items = new List<dynamic>();
                        items = snapshot.data.documents[i]['items'];

                        String statusTemp =
                            snapshot.data.documents[i]['status'];
                        double totalAmountTemp = double.parse(snapshot
                            .data.documents[i]['totalAmount']
                            .toString());
                        String collectTypeTemp =
                            snapshot.data.documents[i]['collectType'];
                        _deliveryList.addOrders(new Order(
                            orderID: orderIDTemp,
                            name: nameTemp,
                            address: addressTemp,
                            date: dateTemp,
                            items: items,
                            status: statusTemp,
                            collectType: collectTypeTemp,
                            totalAmount: totalAmountTemp));
                        _totalList.addOrders(new Order(
                            orderID: orderIDTemp,
                            name: nameTemp,
                            address: addressTemp,
                            date: dateTemp,
                            items: items,
                            status: statusTemp,
                            collectType: collectTypeTemp,
                            totalAmount: totalAmountTemp));
                      }

                      for (int i = 0;
                          i < snapshot2.data.documents.length;
                          i++) {
                        String orderIDTemp =
                            snapshot2.data.documents[i]['transactionId'];
                        Map addressTemp = {
                          "street": "",
                          "unit": "",
                          "postalCode": ""
                        };
                        // Map addressTemp =
                        //  Map.from(snapshot2.data.documents[i]['address']);
                        String nameTemp = snapshot2.data.documents[i]['name'];
                        DateTime dateTemp = snapshot2
                            .data.documents[i]['dateOfTransaction']
                            .toDate();
                        List<dynamic> items = new List<dynamic>();
                        items = snapshot2.data.documents[i]['items'];
                        String statusTemp =
                            snapshot2.data.documents[i]['status'];
                        double totalAmountTemp = double.parse(snapshot2
                            .data.documents[i]['totalAmount']
                            .toString());
                        String collectTypeTemp =
                            snapshot2.data.documents[i]['collectType'];
                        _totalList.addOrders(new Order(
                            orderID: orderIDTemp,
                            name: nameTemp,
                            address: addressTemp,
                            date: dateTemp,
                            items: items,
                            status: statusTemp,
                            collectType: collectTypeTemp,
                            totalAmount: totalAmountTemp));
                        _selfCollectList.addOrders(new Order(
                            orderID: orderIDTemp,
                            name: nameTemp,
                            address: addressTemp,
                            date: dateTemp,
                            items: items,
                            status: statusTemp,
                            collectType: collectTypeTemp,
                            totalAmount: totalAmountTemp));
                      }
                      return Container(
                          height: MediaQuery.of(context).size.height - 140,
                          width: MediaQuery.of(context).size.width,
                          color: whiteSmoke,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: ListView.builder(
                                  itemCount: filterItemCounts(
                                      deliverySize, selfCollectSize, totalSize),
                                  itemBuilder: (context, index) => Card(
                                    child: Container(
                                        color: _selectedIndex != null &&
                                                _selectedIndex == index
                                            ? Colors.red
                                            : Colors.white,
                                        child: ListTile(
                                            title: filterText(
                                                _totalList,
                                                _deliveryList,
                                                _selfCollectList,
                                                index),
                                            onTap: () => _setCardColor(index),
                                            onLongPress: () {

                                              if (_dropDownValue == "1") {
                                                print("${customer.id} and ${_totalList
                                                    .getOrders(
                                                    index).collectType}");
                                                Navigator.of(context).push(

                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DeliveryStatusPage(
                                                                order: _totalList
                                                                    .getOrders(
                                                                        index),
                                                                customer:
                                                                    customer)));
                                              } else if (_dropDownValue ==
                                                  "2") {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DeliveryStatusPage(
                                                                order: _deliveryList
                                                                    .getOrders(
                                                                        index),
                                                                customer:
                                                                    customer)));
                                              } else if (_dropDownValue ==
                                                  "3") {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DeliveryStatusPage(
                                                              order:
                                                                  _selfCollectList
                                                                      .getOrders(
                                                                          index),
                                                              customer:
                                                                  customer,
                                                            )));
                                              }
                                            })),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(height: 10),
                                    ButtonTheme(
                                      height: 60,
                                      minWidth: 250,
                                      child: Column(
                                        children: <Widget>[
                                          RaisedButton(
                                            color: _selected != false
                                                ? heidelbergRed
                                                : Colors.white12,
                                            onPressed: () {
                                              if (_selected == true) {
                                                //go to the next page

                                                //use theonLOngpress function here:
//                                                Navigator.of(context).push(
//                                                    MaterialPageRoute(
//                                                        builder: (context) =>
//                                                            DeliveryStatusPage(
//                                                                order: _deliveryList
//                                                                    .getOrders(
//                                                                        _selectedIndex))));
                                              }
                                            },
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(35)),
                                            child: Text(
                                              "CHECK ORDER",
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 30)
                            ],
                          ));
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }
}
