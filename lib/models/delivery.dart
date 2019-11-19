import 'package:flutter/material.dart';

class Delivery {
  List<Order> orders = new List<Order>();

  void clear() {
    orders.clear();
  }

  int getOrdersSize() {
    return orders.length;
  }

  Order getOrders(int index) {
    return orders[index];
  }

  void addOrders(Order order) {
    orders.add(order);
  }

  @override
  String toString() {
    return "orders=$orders";
  }
}

class Order {
  String orderID, name, customerId, paymentType, status;
  Map address;
  DateTime date;
  List items;
  double totalAmount;
  String collectType;
  Map timeArrival;

  Order(
      {this.orderID,
      this.name,
      this.address,
      this.date,
      this.customerId,
      this.items,
      this.totalAmount,
      this.collectType,
      this.timeArrival,
      this.paymentType,
      this.status});

  @override
  String toString() {
    return "ORDER#$orderID\n"
        "NAME: $name\n"
        "LOCATION: ${address['street']}\n"
        "UNIT: ${address['unit']}\n"
        "POSTAL CODE: ${address['postalCode']}\n";
  }
}
