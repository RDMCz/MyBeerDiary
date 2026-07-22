import "package:flutter/material.dart";

class ColorPicker extends StatefulWidget {
  final List<Color> colors;
  final Color initialColor;
  final ValueChanged<Color> onColorChanged;

  const ColorPicker({
    super.key,
    required this.colors,
    required this.initialColor,
    required this.onColorChanged,
  });

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  Color? _currentColor;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.initialColor;
  }

  void _changeColor(Color color) {
    setState(() => _currentColor = color);
    widget.onColorChanged(color);
  }

  @override
  Widget build(BuildContext context) {
    const iconSpacing = 6.0;

    return Center(
      child: Wrap(
        spacing: iconSpacing,
        runSpacing: iconSpacing,
        children: [
          for (final color in widget.colors)
            GestureDetector(
              onTap: () => _changeColor(color),
              child: ColorContainer(
                color: color,
                isCurrentColor: color == _currentColor,
              ),
            ),
        ],
      ),
    );
  }
}

class ColorContainer extends StatelessWidget {
  final Color color;
  final bool isCurrentColor;

  const ColorContainer({
    super.key,
    required this.color,
    required this.isCurrentColor,
  });

  @override
  Widget build(BuildContext context) {
    final darkColor = Theme.of(context).colorScheme.inverseSurface;

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
