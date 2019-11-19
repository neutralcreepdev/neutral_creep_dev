import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class DOBButton extends StatelessWidget {
  final Function onPressed;
  final DateTime dob;
  DOBButton({Key key, this.onPressed, this.dob}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(5.0),
            side: BorderSide(color: Colors.grey)),
        onPressed: onPressed,
        child: (dob.toString() == "null")
            ? Text('Select Your Date of Birth', style: TextStyle(fontSize: 18))
            : Text('${dob.toString().substring(0, 10)}',
                style: TextStyle(fontSize: 18, color: Colors.blue)));
  }
}
