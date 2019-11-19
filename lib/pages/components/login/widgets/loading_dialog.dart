import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingDialog extends StatelessWidget {
  final bool isLoading;
  const LoadingDialog({Key key, this.isLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        child: isLoading
            ? SpinKitRotatingCircle(color: Colors.white, size: 50.0)
            : Text("lame"));
  }
}
