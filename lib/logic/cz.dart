String beerDeclension(int nBeers) => switch (nBeers) {
  1 => "pivo",
  2 || 3 || 4 => "piva",
  _ => "piv",
};

String intToWeekdayStr(int num) => switch (num) {
  1 => "Po",
  2 => "Út",
  3 => "St",
  4 => "Čt",
  5 => "Pá",
  6 => "So",
  7 => "Ne",
  _ => "??",
};

String intToMonthStr(int num) => switch (num) {
  1 => "Led",
  2 => "Úno",
  3 => "Bře",
  4 => "Dub",
  5 => "Kvě",
  6 => "Čvn",
  7 => "Čvc",
  8 => "Srp",
  9 => "Zář",
  10 => "Říj",
  11 => "Lis",
  12 => "Pro",
  _ => "???",
};
