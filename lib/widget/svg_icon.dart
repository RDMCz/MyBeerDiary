import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";

enum SvgIcons {
  beer("beer");

  final String filename;

  const SvgIcons(this.filename);
}

class SvgIcon extends StatelessWidget {
  final SvgIcons icon;

  const SvgIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "asset/icon/${icon.filename}.svg",
      colorFilter: ColorFilter.mode(
        Theme.of(context).iconTheme.color ?? Colors.black,
        BlendMode.srcIn,
      ),
    );
  }
}
