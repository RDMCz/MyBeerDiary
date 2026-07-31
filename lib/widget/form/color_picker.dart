import "package:flutter/material.dart";

class ColorPicker extends StatelessWidget {
  final bool isEnabled;
  final List<Color> colors;
  final Color selectedColor;
  final ValueChanged<Color> onColorChanged;

  const ColorPicker({
    super.key,
    required this.isEnabled,
    required this.colors,
    required this.selectedColor,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    const iconSpacing = 6.0;

    return Center(
      child: Wrap(
        spacing: iconSpacing,
        runSpacing: iconSpacing,
        children: [
          for (final color in colors)
            GestureDetector(
              onTap: !isEnabled ? null : () => onColorChanged(color),
              child: ColorContainer(
                isEnabled: isEnabled,
                color: color,
                isCurrentColor: color == selectedColor,
              ),
            ),
        ],
      ),
    );
  }
}

/// Displays a specific color ([color]) as a box with an optional checkmark ([isCurrentColor])
class ColorContainer extends StatelessWidget {
  final bool isEnabled;
  final Color color;
  final bool isCurrentColor;

  const ColorContainer({
    super.key,
    required this.isEnabled,
    required this.color,
    required this.isCurrentColor,
  });

  @override
  Widget build(BuildContext context) {
    final darkColor = isEnabled
        ? Theme.of(context).colorScheme.inverseSurface
        : Theme.of(context).colorScheme.outlineVariant;

    const iconSize = 40.0;
    const iconBorderWidth = 1.309;
    const iconBorderRadius = 10.0;
    const shadowOffset = 0.75;

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(iconBorderRadius),
        border: Border.all(color: darkColor, width: iconBorderWidth),
      ),
      width: iconSize,
      height: iconSize,
      child: !isCurrentColor
          ? null
          : Icon(
              Icons.done,
              color: darkColor,
              size: 24,
              // White shadow around dark checkmark so it's visible on all backgrounds
              shadows: [
                Shadow(color: Colors.white, offset: Offset(shadowOffset, 0)),
                Shadow(color: Colors.white, offset: Offset(-shadowOffset, 0)),
                Shadow(color: Colors.white, offset: Offset(0, shadowOffset)),
                Shadow(color: Colors.white, offset: Offset(0, -shadowOffset)),
              ],
            ),
    );
  }
}
