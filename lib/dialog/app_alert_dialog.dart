// Helper widget to show a simple AlertDialog with text header, text body,
// and either two "yes/no" buttons or just a "dismiss" button

import "package:flutter/material.dart";

class AppAlertDialog extends StatelessWidget {
  final String titleText;
  final String bodyText;
  final String yesText;
  final String noText;
  final bool doShowNo;

  const AppAlertDialog({
    super.key,
    required this.titleText,
    required this.bodyText,
    required this.yesText,
    required this.noText,
    required this.doShowNo,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titleText),
      content: Text(bodyText),
      actions: [
        if (doShowNo)
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(noText),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(yesText),
        ),
      ],
    );
  }
}
