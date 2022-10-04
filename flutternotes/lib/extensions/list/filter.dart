//extension to help us filter a stream of list of sth, should that sth pass the filter test then it will be included in the stream
extension Filter<T> on Stream<List<T>> {
  Stream<List<T>> filter(bool Function(T) where) =>
      map((items) => items.where(where).toList());
}
