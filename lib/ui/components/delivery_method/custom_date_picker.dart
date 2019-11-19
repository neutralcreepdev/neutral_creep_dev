import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CustomDatePicker extends DateTimePickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomDatePicker({
    DateTime currentTime,
    LocaleType locale,
    DateTime maxTime,
    DateTime minTime,
  }) : super(
            locale: locale,
            currentTime: currentTime,
            maxTime: maxTime,
            minTime: minTime);

  @override
  String middleStringAtIndex(int index) {
    if (index >= 9 && index < 20) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }
}
