import 'package:flutter/material.dart';

class ExpiryDateTextField extends StatelessWidget {
  final TextEditingController monthController, yearController;
  final String errorText;
  const ExpiryDateTextField(
      {Key key, this.monthController, this.yearController, this.errorText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("expiry date:", style: Theme.of(context).textTheme.body1),
          Row(children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width / 3,
                child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        enabledBorder: checkError(),
                        contentPadding: const EdgeInsets.all(15.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        hintText: "mm"),
                    controller: monthController)),
            Text(" / ", style: TextStyle(fontSize: 50)),
            Container(
                width: MediaQuery.of(context).size.width / 3,
                child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        enabledBorder: checkError(),
                        contentPadding: const EdgeInsets.all(15.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        hintText: "yyyy"),
                    controller: yearController)),
          ]),
          SizedBox(height: 5),
          Row(children: <Widget>[
            SizedBox(width: 15),
            Text(errorText ?? "",
                style: TextStyle(fontSize: 12, color: Colors.red[700])),
          ])
        ]);
  }

  OutlineInputBorder checkError() {
    if (errorText != null) {
      return OutlineInputBorder(borderSide: BorderSide(color: Colors.red[700]));
    } else
      return null;
  }
}
