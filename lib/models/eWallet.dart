class EWallet {
  double eCreadits;
  List<Map<String,dynamic>> creditCards;

  EWallet({this.eCreadits, this.creditCards});

  factory EWallet.fromMap(Map data) {
    List<Map<String, dynamic>> creditCards = new List<Map<String, dynamic>>();
    try {
      List<dynamic> cardData = data["creditCards"];
      for (int i = 0; i < cardData.length; i++) {
        /*Map expiryDate = {
        "month": cardData[i]["expiryDate"]["month"],
        "year": cardData[i]["expiryDate"]["year"]
      };*/

        Map<String, dynamic> temp = {
          "fullName": cardData[i]["fullName"],
          "cardNum": cardData[i]["cardNum"],
          "expiryMonth": cardData[i]["expiryMonth"],
          "expiryYear": cardData[i]["expiryYear"],
          "bankName": cardData[i]["bankName"]};
        creditCards.add(temp);
      }
    }catch(exception){
      print("noCreditCard Found: ${creditCards.length}");
    }

    double val = data["eCredit"].toDouble();

    return EWallet(creditCards: creditCards, eCreadits: val ?? 0);
  }

  @override
  String toString() {
    return "eCredits=$eCreadits, creditCards=$creditCards";
  }

  void add500(){
    eCreadits+=500.00;
  }

  void add(String x){
    double addVal = double.parse(x);
    eCreadits+=addVal;
  }
}


class CreditCard {
  String fullName, cardNum, bankName;
  String expiryMonth, expiryYear;

  CreditCard({this.fullName, this.cardNum, this.bankName, this.expiryMonth,this.expiryYear});

  @override
  String toString() {
    return "fullName=$fullName, cardNum=$cardNum, bankName=$bankName, expiryDate=$expiryMonth/$expiryYear, ";
  }
}
