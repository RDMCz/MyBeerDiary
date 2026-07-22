import "package:flutter/material.dart";
import "package:flutter_colorpicker/flutter_colorpicker.dart";
import "package:my_beer_diary/data.dart";

class ColorPickerBeer extends StatelessWidget {
  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;

  const ColorPickerBeer({
    super.key,
    required this.pickerColor,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    const iconSpacing = 6.0;

    return BlockPicker(
      pickerColor: pickerColor,
      onColorChanged: onColorChanged,
      availableColors: beerColors,
      layoutBuilder: (context, colors, child) {
        return Center(
          child: Wrap(
            spacing: iconSpacing,
            runSpacing: iconSpacing,
            children: [for (final color in colors) child(color)],
          ),
        );
      },
      itemBuilder: (color, isCurrentColor, changeColor) {
        return GestureDetector(
          onTap: changeColor,
          child: ColorContainer(color: color, isCurrentColor: isCurrentColor),
        );
      },
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
              color: useWhiteForeground(color) ? Colors.white : darkColor,
            ),
    );
  }
}
