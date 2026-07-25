import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/data.dart";
import "package:my_beer_diary/logic/alcohol.dart";
import "package:my_beer_diary/logic/decimal_input_formatter.dart";
import "package:my_beer_diary/widget/checkbox.dart";
import "package:my_beer_diary/widget/color_picker.dart";
import "package:my_beer_diary/widget/svg_icon.dart";

class BeerForm extends StatefulWidget {
  final TextEditingController beerDescTEC;
  final TextEditingController epmTEC;
  final TextEditingController abvTEC;
  final Color initialColor;
  final ValueChanged<Color> onColorChanged;

  const BeerForm({
    super.key,
    required this.beerDescTEC,
    required this.epmTEC,
    required this.abvTEC,
    required this.initialColor,
    required this.onColorChanged,
  });

  @override
  State<BeerForm> createState() => _BeerFormState();
}

class _BeerFormState extends State<BeerForm> {
  bool isAbvGuess = false;

  @override
  Widget build(BuildContext context) {
    final iconColorEnabled = Theme.of(context).colorScheme.inverseSurface;
    final iconColorDisabled = Theme.of(context).colorScheme.secondary;

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
                inputFormatters: [DecimalInputFormatter()],
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
                enabled: !isAbvGuess,
                inputFormatters: [DecimalInputFormatter()],
              ),
            ),
          ],
        ),
        SizedBox(height: DialogCommon.bodyMarginBottom),

        LabeledCheckbox(
          label: "Odhadnout procenta alkoholu ze stupňovistosti",
          padding: EdgeInsets.all(0),
          value: isAbvGuess,
          onChanged: (bool newValue) {
            setState(() {
              isAbvGuess = newValue;
            });
          },
        ),
        SizedBox(height: DialogCommon.bodyMarginBottom),

        // - color
        ColorPicker(
          colors: beerColors,
          initialColor: widget.initialColor,
          onColorChanged: widget.onColorChanged,
        ),        
      ],
    );
  }
}
