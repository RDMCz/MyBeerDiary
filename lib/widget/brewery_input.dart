import "package:flutter/material.dart";
import "package:my_beer_diary/data.dart";
import "package:my_beer_diary/widget/svg_icon.dart";

class BreweryInput extends StatefulWidget {
  final ValueChanged<String> onTextChanged;
  final String? initialValue;

  const BreweryInput({
    super.key,
    required this.onTextChanged,
    this.initialValue,
  });

  @override
  State<BreweryInput> createState() => _BreweryInputState();
}

class _BreweryInputState extends State<BreweryInput> {
  @override
  Widget build(BuildContext context) {
    return Autocomplete(
      initialValue: TextEditingValue(text: widget.initialValue ?? ""),
      optionsBuilder: (TextEditingValue value) {
        // Ignore when input empty or 1 character long
        if (value.text.length < 2) {
          return Iterable<String>.empty();
        }
        // Return list of brewery names that contain input, case insensitive
        return breweryNames.where((String option) {
          return option.toLowerCase().contains(value.text.toLowerCase());
        });
      },
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
            textEditingController.addListener(() {
              widget.onTextChanged(textEditingController.text);
            });
            return TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Název pivovaru",
                suffixIcon: SuffixSvgIcon(icon: SvgIcons.brewery),
              ),
            );
          },
    );
  }
}
