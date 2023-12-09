extension MapExtension<K, V> on Map<K, V> {
  Iterable<(K, V)> get records => entries.map((e) => (e.key, e.value));

  int lastIndexWhereOrValue(
      bool Function(MapEntry<K, V> element) test, {
        int defaultValue = 0,
      }) {
    final index = entries.toList().lastIndexWhere(test);
    return index > -1 ? index : defaultValue;
  }
}
