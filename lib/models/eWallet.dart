class EWallet {
  double eCreadits;
  List<Map<String, dynamic>> creditCards = new List<Map<String, dynamic>>();
  int points;

  EWallet({this.eCreadits, this.creditCards, this.points});

  factory EWallet.fromMap(Map data) {
    List<Map<String, dynamic>> creditCards = new List<Map<String, dynamic>>();
    try {
      List<dynamic> cardData = data["creditCards"];
      for (int i = 0; i < cardData.length; i++) {
        Map<String, dynamic> temp = {
          "fullName": cardData[i]["fullName"],
          "cardNum": cardData[i]["cardNum"],
          "expiryMonth": cardData[i]["expiryMonth"],
          "expiryYear": cardData[i]["expiryYear"],
          "bankName": cardData[i]["bankName"]
        };
        creditCards.add(temp);
      }
    } catch (exception) {
      print("noCreditCard Found: ${creditCards.length}");
    }

    double val = data["eCredit"].toDouble();

    int val2 = data['points'];

    return EWallet(
        creditCards: creditCards, eCreadits: val ?? 0, points: val2 ?? 0);
  }

  @override
  String toString() {
    return "eCredits=$eCreadits, creditCards=$creditCards, points=$points";
  }

  void subtractPoints(int points) {
    this.points -= points;
  }

  void addPoints(int points) {
    this.points += points;
  }

  void add500() {
    eCreadits += 500.00;
  }

  void subtractECredit(double credit) {
    eCreadits -= credit;
  }

  void addCreepDollar(double amount) {
    eCreadits += amount;
  }

  void add(String x) {
    double addVal = double.parse(x);
    eCreadits += addVal;
  }
}

class CreditCard {
  String fullName, cardNum, bankName;
  String expiryMonth, expiryYear;

  CreditCard(
      {this.fullName,
      this.cardNum,
      this.bankName,
      this.expiryMonth,
      this.expiryYear});

  @override
  String toString() {
    return "fullName=$fullName, cardNum=$cardNum, bankName=$bankName, expiryDate=$expiryMonth/$expiryYear, ";
  }
}
