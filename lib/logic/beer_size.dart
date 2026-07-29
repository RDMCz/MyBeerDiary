import "package:my_beer_diary/widget/svg_icon.dart";

enum BeerSize { small, large, custom }

int litresToDecilitres(double d) => (d * 10).round();

/// Expects double [d] between 0.1 and 1.0 representing litres and returns string name for that amount
String doubleToBeerSizeStr(double d) => switch (litresToDecilitres(d)) {
  1 => "Deci",
  2 => "2 deci",
  3 => "Malé",
  4 => "Čtyřka",
  5 => "Velké",
  6 => "6 deci",
  7 => "7 deci",
  8 => "8 deci",
  9 => "9 deci",
  10 => "Tuplák",
  _ => "???",
};

/// Expects double [d] between 0.1 and 1.0 representing litres and returns BeerSize enum value for that amount
BeerSize doubleToBeerSize(double d) => switch (litresToDecilitres(d)) {
  3 => BeerSize.small,
  5 => BeerSize.large,
  _ => BeerSize.custom,
};

/// Returns proper beer size icon to display on BeerConsumptionCard for given BeerSize enum value
SvgIcons beerSizeToIcon(BeerSize bs) => switch (bs) {
  BeerSize.small => SvgIcons.beerSizeSmall,
  BeerSize.large => SvgIcons.beerSizeLarge,
  BeerSize.custom => SvgIcons.beerSizeCustom,
};

/// Returns proper beer icon to display on BeerConsumptionCard for given BeerSize enum value and isDraft
SvgCardIcons beerSizeToCardIcon(BeerSize beerSize, bool isDraft) =>
    switch ((beerSize, isDraft)) {
      (_, false) => SvgCardIcons.beerCan,
      (BeerSize.small, true) => SvgCardIcons.beerSmall,
      _ => SvgCardIcons.beerLarge,
    };
