/// Expects double [d] between 0.1 and 1.0 representing decilitres and returns string name for that amount
String doubleToBeerSizeStr(double d) => switch ((d * 10).round()) {
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
