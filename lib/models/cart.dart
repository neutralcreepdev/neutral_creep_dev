import 'package:flutter/material.dart';

class Cart {
  List<Grocery> groceries = new List<Grocery>();

  void clear() {
    groceries.clear();
  }

  double getGrandTotal() {
    return getTotalCost() + getGST();
  }

  double getGST() {
    return getTotalCost() * 0.07;
  }

  double getTotalCost() {
    double cost = 0;
    for (Grocery item in groceries) {
      cost += item.quantity * item.cost;
    }

    return cost;
  }

  int getCartSize() {
    return groceries.length;
  }

  void removeGrocery(int index) {
    groceries.removeAt(index);
  }

  void addGrocery(Grocery item) {
    groceries.add(item);
  }

  Grocery getGrocery(int index) {
    return groceries[index];
  }

  bool repeatCheck(Grocery item) {
    if (groceries.length != 0)
      for (int i = 0; i < groceries.length; i++) {
        if (item.id == groceries[i].id) {
          groceries[i].quantity++;
          return true;
        }
      }
    return false;
  }

  @override
  String toString() {
    return "groceries=$groceries";
  }
}

class Grocery {
  String name, id, supplier, description, imageURL;
  double cost;
  int quantity;
  Image image;

  void downloadImage() {}

  Grocery(
      {this.id,
      this.name,
      this.description,
      this.supplier,
      this.cost,
      this.imageURL}) {
    quantity = 0;

    if (imageURL != null) {
      _setImageWithURL();
    }
  }

  bool setGroceryWithStringInput(String data) {
    var dataArray = data.split(":");

    if (dataArray.length < 6) {
      return false;
    }

    this.id = dataArray[0] ?? "No ID";
    this.name = dataArray[1] ?? "No Name";
    this.description = dataArray[2] ?? "No Description";
    this.supplier = dataArray[3] ?? "No Supplier";
    this.cost = double.parse(dataArray[4]) ?? 0;

    if (dataArray[5].contains("http")) {
      String imageURLTemp = "${dataArray[5]}:${dataArray[6]}";

      this.imageURL = imageURLTemp ?? null;

      if (imageURL != null) {
        _setImageWithURL();
      }
    } else {
      this.imageURL = null;
      this.image = null;
    }

    print("\n\n\n\n\n$dataArray\n\n\n\n\n\n");

    return true;
  }

  double getTotalCost() {
    return cost * quantity;
  }

  void _setImageWithURL() {
    this.image = Image.network(imageURL);
  }

  void setImage(Image image) {
    this.image = image;
  }

  @override
  String toString() {
    return "id=$id, name=$name, description=$description, supplier=$supplier, cost=$cost, quantity=$quantity";
  }
}
