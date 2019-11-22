import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:neutral_creep_dev/models/models.dart';

class SignUpProfileLogic {
  static void updateCustomer(
      {String firstName,
      String lastName,
      String street,
      String blockNum,
      String unitLevel,
      String unitNum,
      String postalCode,
      String phoneNum,
      BuildContext context}) {
    Provider.of<Customer>(context).firstName = firstName;
    Provider.of<Customer>(context).lastName = lastName;
    Map address = {
      "street": "$blockNum $street",
      "unit": "$unitLevel-$unitNum",
      "postalCode": postalCode
    };
    Provider.of<Customer>(context).address = address;
    Provider.of<Customer>(context).contactNum = phoneNum;
  }
}
