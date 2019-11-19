import './transaction.dart';
import './user.dart';
import './eWallet.dart';
import './cart.dart';

class Customer extends User {
  EWallet eWallet;
  List<Transaction> transactions;
  Cart currentCart;

  Customer(
      {String id,
      String name,
      Map dob,
      String contactNum,
      Map address,
      this.eWallet,
      this.transactions,
      this.currentCart})
      : super(id, name, dob, contactNum, address);

  void updateCustomer(Customer customerData) {
    this.id = customerData.id;
    this.name = customerData.name;

    this.dob = customerData.dob;
    this.contactNum = customerData.contactNum;
    this.address = customerData.address;
    this.currentCart = Cart();
  }

  factory Customer.fromMap(Map data) {
    return Customer(
        id: data["id"] ?? "",
        name: data["name"] ?? "",
        contactNum: data["contactNum"] ?? "",
        address: {
          "street": data["address"]["street"] ?? "",
          "unit": data["address"]["unit"] ?? "",
          "postalCode": data["address"]["postalCode"] ?? ""
        },
        currentCart: new Cart());
  }

  void createNewCustomer() {
    this.currentCart = new Cart();
    List<Map<String, dynamic>> creditCards = new List<Map<String, dynamic>>();
    this.eWallet =
        new EWallet(eCreadits: 0, creditCards: creditCards, points: 0);
  }

  void clearCart() {
    currentCart.clear();
  }

  @override
  String toString() {
    return "${super.toString()}, eWallet=$eWallet, currentCart=$currentCart, transactionHistory=$transactions";
  }
}
