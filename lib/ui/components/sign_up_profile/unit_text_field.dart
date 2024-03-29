import 'package:flutter/material.dart';

class UnitNumTextField extends StatelessWidget {
  final String title, levelError, unitError;
  final double width;
  final TextEditingController levelController, unitController;
  const UnitNumTextField({
    Key key,
    this.title,
    this.width,
    this.levelController,
    this.unitController,
    this.levelError,
    this.unitError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width - 20,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("$title:", style: TextStyle(fontSize: 15)),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      width: (width - 10) / 5 * 2,
                      child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 15),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              hintText: "level",
                              errorText: levelError),
                          controller: levelController)),
                  Container(height: 3, width: 10, color: Colors.black),
                  Container(
                      width: (width - 10) / 5 * 2,
                      child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 15),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              hintText: "unit",
                              errorText: unitError),
                          controller: unitController)),
                ])
          ]),
    );
  }
}
