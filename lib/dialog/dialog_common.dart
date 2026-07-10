import "package:flutter/material.dart";

class DialogCommon {
  static const insetPadding = EdgeInsets.all(32);

  static const shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  );

  static const contentPadding = EdgeInsetsGeometry.symmetric(
    horizontal: 20,
    vertical: 12,
  );

  static const headerStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18.0,
  );
}
