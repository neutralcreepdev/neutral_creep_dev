import '../../../models/customer.dart';

class SignUpLogic {
  static Customer confirmDetails(
      {String uid,
      String firstName,
      String lastName,
      DateTime dateOfBirth,
      String contactNum,
      String street,
      String unit,
      String postalCode}) {
    Customer customer;
    String day = dateOfBirth.toString().substring(8, 10);
    String month = dateOfBirth.toString().substring(5, 7);
    String year = dateOfBirth.toString().substring(0, 4);

    Map address = {"street": street, "unit": unit, "postalCode": postalCode};
    Map dob = {"day": day, "month": month, "year": year};

    customer = new Customer(
        id: uid, dob: dob, contactNum: contactNum, address: address);
    customer.createNewCustomer();

    return customer;
  }

  static bool validateForm(
      {String firstName,
      String lastName,
      DateTime dob,
      String contactNum,
      String street,
      String unit,
      String postalCode}) {
    if (!isFieldFilled(firstName)) {
      return false;
    } else if (!isFieldFilled(lastName)) {
      return false;
    } else if (!validateContactNumField(contactNum)) {
      return false;
    } else if (!validatePostalCodeField(postalCode)) {
      return false;
    } else if (!isFieldFilled(street)) {
      return false;
    } else if (!isFieldFilled(unit)) {
      return false;
    } else if (dob == null) {
      return false;
    }

    return true;
  }

  static String getPostalCodeError(String postalCode) {
    if (postalCode.isEmpty) {
      return "Please input your contact number!";
    } else if (postalCode.length != 6) {
      return "Please enter 6 digits for your postal code!";
    }

    return null;
  }

  static String getContactNumError(String contactNum) {
    if (contactNum.isEmpty) {
      return "Please input your contact number!";
    } else if (contactNum.length != 8) {
      return "Please enter 8 digits for your contact number!";
    }

    return null;
  }

  static bool validatePostalCodeField(String postalCode) {
    if (!isFieldFilled(postalCode)) {
      return false;
    } else if (postalCode.length != 6) {
      return false;
    }
    return true;
  }

  static bool validateContactNumField(String contactNum) {
    if (!isFieldFilled(contactNum)) {
      return false;
    } else if (contactNum.length != 8) {
      return false;
    }
    return true;
  }

  static bool isFieldFilled(String field) {
    if (field.isEmpty) {
      return false;
    } else
      return true;
  }
}
