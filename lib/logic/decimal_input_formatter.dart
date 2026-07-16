import "package:flutter/services.dart";

class DecimalInputFormatter extends TextInputFormatter {
  final RegExp _pattern;

  DecimalInputFormatter({int nDigitsBeforeDot = 2, int nDigitsAfterDot = 2})
    : _pattern = RegExp(
        r"^\d{0," +
            nDigitsBeforeDot.toString() +
            r"}(\.\d{0," +
            nDigitsAfterDot.toString() +
            r"})?$",
      );

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty || _pattern.hasMatch(newValue.text)) {
      return newValue;
    }

    return oldValue;
  }
}
