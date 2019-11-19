import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:neutral_creep_dev/models/models.dart';

class SignUpProfileLogic {
  static void updateCustomer(
      {String name,
      String street,
      String blockNum,
      String unitLevel,
      String unitNum,
      String postalCode,
      String phoneNum,
      BuildContext context}) {
    Provider.of<Customer>(context).name = name;
    Map address = {
      "street": street,
      "unit": "$unitLevel-$unitNum",
      "postalCode": postalCode
    };
    Provider.of<Customer>(context).address = address;
    Provider.of<Customer>(context).contactNum = phoneNum;
  }
}
