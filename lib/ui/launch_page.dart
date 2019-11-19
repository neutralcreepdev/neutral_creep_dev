import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:neutral_creep_dev/ui/login_page.dart';

class LaunchPage extends StatefulWidget {
  LaunchPage({Key key}) : super(key: key);

  @override
  _LaunchPageState createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  int _start = 3;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return Scaffold(
        body: Center(
            child: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Image.asset(
                  "assets/images/logo-neutralcreep2019-2.png",
                  fit: BoxFit.cover,
                ))));
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    new Timer.periodic(
        oneSec,
        (Timer timer) => setState(() {
              if (_start == 0) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        settings: RouteSettings(name: "login"),
                        builder: (context) => LoginPage()));
              }
              (_start < 1) ? timer.cancel() : _start = _start - 1;
            }));
  }
}
