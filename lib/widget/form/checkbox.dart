import "package:flutter/material.dart";

class LabeledCheckbox extends StatelessWidget {
  final bool isEnabled;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const LabeledCheckbox({
    super.key,
    required this.isEnabled,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isEnabled) {
          onChanged(!value);
        }
      },
      child: Row(
        children: [
          // Checkbox is only visual, InkWell handles the onTap
          IgnorePointer(
            child: Checkbox(
              value: value,
              // Null makes checkbox look disabled
              onChanged: !isEnabled ? null : (_) {},
            ),
          ),
          Expanded(child: Text(label)),
        ],
      ),
    );
  }
}
