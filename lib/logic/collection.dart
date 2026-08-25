/// Returns list of [MapEntry] sorted by value for given [map]
List<MapEntry<K, V>> sortedMapByValue<K, V extends Comparable<Object>>(
  Map<K, V> map,
) => map.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
