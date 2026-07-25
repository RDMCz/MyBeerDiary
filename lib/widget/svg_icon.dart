import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:my_beer_diary/logic/color.dart";

enum SvgIcons {
  abv("abv"),
  beer("beer"),
  brewery("brewery"),
  epm("epm"),
  event("event"),
  leadsto("leadsto"),
  oneoff("oneoff"),
  beerSizeSmall("beer_size_small"),
  beerSizeLarge("beer_size_large"),
  beerSizeCustom("beer_size_custom");

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

// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

enum SvgCardIcons {
  beerSmall("_card_beer_small"),
  beerLarge("_card_beer_large"),
  beerCan("_card_beer_can");

  final String filename;

  const SvgCardIcons(this.filename);
}

class AppColorMapper extends ColorMapper {
  final String color;

  const AppColorMapper({required this.color});

  @override
  Color substitute(
    String? id,
    String elementName,
    String attributeName,
    Color color,
  ) {
    if (color == const Color(0xffffda71)) {
      return hexStringToColor(this.color);
    }
    return color;
  }
}

class SvgCardIcon extends StatelessWidget {
  final SvgCardIcons icon;
  final String color;

  const SvgCardIcon({super.key, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.3775,
      child: SvgPicture.asset(
        "asset/icon/${icon.filename}.svg",
        colorMapper: AppColorMapper(color: color),
      ),
    );
  }
}
