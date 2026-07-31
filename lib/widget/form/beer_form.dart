import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/data.dart";
import "package:my_beer_diary/logic/alcohol.dart";
import "package:my_beer_diary/logic/decimal_input_formatter.dart";
import "package:my_beer_diary/widget/form/checkbox.dart";
import "package:my_beer_diary/widget/form/color_picker.dart";
import "package:my_beer_diary/widget/svg_icon.dart";

class BeerForm extends StatefulWidget {
  final bool isEnabled;
  final TextEditingController beerDescTEC;
  final TextEditingController epmTEC;
  final TextEditingController abvTEC;
  final Color beerColor;
  final ValueChanged<Color> onColorChanged;
  final bool isAbvGuess;
  final ValueChanged<bool> onIsAbvGuessChanged;

  const BeerForm({
    super.key,
    required this.isEnabled,
    required this.beerDescTEC,
    required this.epmTEC,
    required this.abvTEC,
    required this.beerColor,
    required this.onColorChanged,
    required this.isAbvGuess,
    required this.onIsAbvGuessChanged,
  });

  @override
  State<BeerForm> createState() => _BeerFormState();
}

class _BeerFormState extends State<BeerForm> {
  @override
  Widget build(BuildContext context) {
    final iconColorEnabled = Theme.of(context).colorScheme.inverseSurface;
    final iconColorDisabled = Theme.of(context).colorScheme.secondary;

    final isAbvGuess = widget.isAbvGuess;

    // Get ABV from EPM if checkbox checked
    if (isAbvGuess) {
      widget.abvTEC.text = epmToAbvDialog(widget.epmTEC.text);
    }

    return Column(
      children: [
        // - description
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Název/styl/popis piva",
            suffixIcon: SuffixSvgIcon(icon: SvgIcons.beer),
          ),
          controller: widget.beerDescTEC,
          enabled: widget.isEnabled,
        ),
        SizedBox(height: DialogCommon.bodyMarginBottom),
        Row(
          children: [
            // - epm
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Stupňovitost",
                  suffixIcon: SuffixSvgIcon(icon: SvgIcons.epm),
                ),
                controller: widget.epmTEC,
                enabled: widget.isEnabled,
                inputFormatters: [DecimalInputFormatter()],
                keyboardType: TextInputType.number,
              ),
            ),
            // ⇝
            SvgIcon(
              icon: SvgIcons.leadsto,
              color: isAbvGuess ? iconColorEnabled : iconColorDisabled,
              size: 36,
            ),
            // - abv
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Alkohol",
                  suffixIcon: SuffixSvgIcon(
                    icon: SvgIcons.abv,
                    color: !isAbvGuess ? iconColorEnabled : iconColorDisabled,
                  ),
                ),
                controller: widget.abvTEC,
                enabled: widget.isEnabled && !isAbvGuess,
                inputFormatters: [DecimalInputFormatter()],
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        SizedBox(height: DialogCommon.bodyMarginBottom),

        LabeledCheckbox(
          isEnabled: widget.isEnabled,
          label: "Odhadnout procenta alkoholu ze stupňovistosti",
          padding: EdgeInsets.all(0),
          value: isAbvGuess,
          onChanged: widget.onIsAbvGuessChanged,
        ),
        SizedBox(height: DialogCommon.bodyMarginBottom),

        // - color
        ColorPicker(
          isEnabled: widget.isEnabled,
          colors: beerColors,
          selectedColor: widget.beerColor,
          onColorChanged: widget.onColorChanged,
        ),
      ],
    );
  }
}
