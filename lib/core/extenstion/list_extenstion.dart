extension ListConverter on List {
  List<E> fromList<E>(E Function(Map<String, dynamic>) fromMap) {
    final List<E> list = [];

    for (var i in this) {
      list.add(fromMap(i));
    }
    return list;
  }
}
