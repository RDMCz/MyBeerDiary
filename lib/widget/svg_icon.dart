import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";

enum SvgIcons {
  beer("beer"),
  event("event"),
  oneoff("oneoff"),
  brewery("brewery"),
  epm("epm"),
  abv("abv");

  final String filename;

  const SvgIcons(this.filename);
}

class SvgIcon extends StatelessWidget {
  final SvgIcons icon;
  final Color? color;
  final double size;

  const SvgIcon({super.key, required this.icon, this.color, this.size = 24.0});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "asset/icon/${icon.filename}.svg",
      colorFilter: ColorFilter.mode(
        color ?? Theme.of(context).colorScheme.inverseSurface,
        BlendMode.srcIn,
      ),
      width: size,
      height: size,
    );
  }
}

class SuffixSvgIcon extends StatelessWidget {
  final SvgIcons icon;
  final Color? color;

  const SuffixSvgIcon({super.key, required this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(9.5),
      child: SvgIcon(icon: icon, color: color),
    );
  }
}
