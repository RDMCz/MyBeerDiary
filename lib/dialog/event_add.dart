import "package:flutter/material.dart";

class EventAddDialog extends StatelessWidget {
  const EventAddDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: .all(80),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      child: Padding(
        padding: .symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // = Header =
            Text(
              "Nová událost",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            SizedBox(height: 16),

            // = Form body =
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Název události",
              ),
            ),
            SizedBox(height: 8),

            // = Buttons =
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Zrušit"),
                ),
                const SizedBox(width: 8),
                TextButton(onPressed: () {}, child: const Text("OK")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
