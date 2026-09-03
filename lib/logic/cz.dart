String beerDeclension(int nBeers) => switch (nBeers) {
  1 => "pivo",
  2 || 3 || 4 => "piva",
  _ => "piv",
};
