import "package:flutter/material.dart";

class DropdownMenuSmall<T> extends StatelessWidget {
  final bool enabled;
  final List<DropdownMenuEntry<T>> dropdownMenuEntries;
  final T? initialSelection;
  final Function(T)? onSelected;
  final double? width;

  const DropdownMenuSmall({
    super.key,
    required this.enabled,
    required this.dropdownMenuEntries,
    required this.initialSelection,
    required this.onSelected,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    const trailingIconOffset = Offset(0, -4);

    return DropdownMenu<T>(
      enabled: enabled,
      dropdownMenuEntries: dropdownMenuEntries,
      initialSelection: initialSelection,
      selectOnly: true,
      inputDecorationTheme: InputDecorationTheme(
        constraints: BoxConstraints.tight(const Size.fromHeight(40.0)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      trailingIcon: Transform.translate(
        offset: trailingIconOffset,
        child: const Icon(Icons.arrow_drop_down),
      ),
      selectedTrailingIcon: Transform.translate(
        offset: trailingIconOffset,
        child: const Icon(Icons.arrow_drop_up),
      ),
      menuHeight: 300.0,
      width: width,
      onSelected: (T? value) {
        if (value != null) {
          onSelected?.call(value);
        }
      },
    );
  }
}
