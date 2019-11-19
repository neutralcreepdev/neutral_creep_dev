import 'package:flutter/material.dart';
import 'package:neutral_creep_dev/pages/deliveryConfirmationPage.dart';

import './pages/startPage.dart';

import 'helpers/hash_helper.dart';

void main() {
  runApp(MaterialApp(
    title: "Neutal Creep",
    debugShowCheckedModeBanner: false,
    home: StartPage(),
    //home: hashcash(),
  ));
}
