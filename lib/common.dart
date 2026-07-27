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

class CardCommon {
  static const normalPadding = EdgeInsets.all(6.0);

  static const miniPadding = EdgeInsets.symmetric(
    horizontal: 8.0,
    vertical: 4.0,
  );
}

class CardListCommon {
  //static const listPadding = EdgeInsets.symmetric(horizontal: 12.0);
  static const _listPaddingHorizontal = 12.0;
  static const listPadding = EdgeInsets.only(
    // Space after all cards so user can scroll little further and see the whole card (otherwise FAB would cover it)
    bottom: 72.0,
    left: _listPaddingHorizontal,
    right: _listPaddingHorizontal,
  );

  static const itemPadding = EdgeInsets.only(bottom: 6.0);

  // Used in SizedBox after all cards so user can scroll little further and see the whole card (otherwise FAB would cover it)
  static const extraBottomSpace = 72.0;
}
