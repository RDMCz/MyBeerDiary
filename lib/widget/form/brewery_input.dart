import "package:flutter/material.dart";
import "package:my_beer_diary/data.dart";
import "package:my_beer_diary/model/beer.dart";
import "package:my_beer_diary/widget/svg_icon.dart";
import "package:provider/provider.dart";

class BreweryInput extends StatefulWidget {
  final TextEditingController textEditController;

  const BreweryInput({super.key, required this.textEditController});

  @override
  State<BreweryInput> createState() => _BreweryInputState();
}

class _BreweryInputState extends State<BreweryInput> {
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dbBreweryNames = context.read<BeerNotifier>().uniqueBreweryNames;
    final allBreweryNames = dbBreweryNames.union(breweryNames);

    return Autocomplete(
      textEditingController: widget.textEditController,
      focusNode: focusNode,
      optionsBuilder: (TextEditingValue value) {
        // Ignore when input empty or 1 character long
        if (value.text.length < 2) {
          return Iterable<String>.empty();
        }
        // Return list of brewery names that contain input, case insensitive
        return allBreweryNames.where((String option) {
          return option.toLowerCase().contains(value.text.toLowerCase());
        });
      },
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) =>
              TextFormField(
                controller: textEditingController,
                focusNode: focusNode,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Název pivovaru",
                  suffixIcon: SuffixSvgIcon(icon: SvgIcons.brewery),
                ),
              ),
    );
  }
}
