import 'package:flutter/material.dart';

import 'pages/deliveryCheck.dart';
import 'pages/deliveryConfirmationPage.dart';
import 'pages/deliveryStatus.dart';
import 'pages/eWalletPage.dart';
import 'pages/homePage.dart';
import 'pages/loginSignupPage.dart';
import 'pages/paymentMadePage.dart';
import 'pages/paymentPage.dart';
import 'pages/profilePage.dart';
import 'pages/signUpPage.dart';
import 'pages/startPage.dart';
import 'pages/summaryPage.dart';
import 'pages/topUpPage.dart';
import 'pages/transactionHistory.dart';
import 'pages/transferPage.dart';



import 'helpers/hash_helper.dart';

void main() {
  runApp(MaterialApp(
    //initialRoute: '/',
    title: "Neutal Creep",
    debugShowCheckedModeBanner: false,
    /*routes: {
      '/': (context) => StartPage(),
      '/home': (context) => HomePage(),
      '/payment': (context) => PaymentPage(),
      '/paymentMade': (context) => PaymentMadePage(),
      '/deliveryCheck': (context) => DeliveryCheckPage(),
      '/deliveryStatus': (context) => DeliveryStatusPage(),
      '/profile': (context) => ProfilePage(),
      '/signUp': (context) => SignUpPage(),
      '/eWallet': (context) => EWalletPage(),
      '/transfer': (context) => TransferPage(),
      '/topUp': (context) => TopUpPage(),
      '/summary': (context) => SummaryPage(),
      '/deliveryConfirmation': (context) => DeliveryConfirmation(),
      '/logInSignUp': (context) => LoginSignUpPage(),
    },*/
    home: StartPage(),
    //home: hashcash(),
  ));
}
