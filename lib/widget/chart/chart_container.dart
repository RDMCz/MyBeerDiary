import "package:flutter/material.dart";

class ChartContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double height;

  const ChartContainer({
    super.key,
    required this.child,
    required this.padding,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Padding(padding: padding, child: child),
    );
  }
}
