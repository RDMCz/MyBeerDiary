import "package:flutter/material.dart";

class DialogCommon {
  static const insetPadding = EdgeInsets.all(32.0);

  static const shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  );

  static const contentPadding = EdgeInsetsGeometry.symmetric(
    horizontal: 20.0,
    vertical: 14.0,
  );

  static const headerStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
  );

  //

  static const headerMarginBottom = 16.0;
  static const bodyMarginBottom = 12.0;
  static const buttonSpace = 8.0;
}

class CardListCommon {
  static const listPadding = EdgeInsets.symmetric(horizontal: 12.0);
  static const itemPadding = EdgeInsets.only(bottom: 6.0);

  // Used in SizedBox after all cards so user can scroll little further and see the whole card (otherwise FAB would cover it)
  static const extraBottomSpace = 72.0;
}
