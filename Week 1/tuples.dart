// tuples store different types of data
void main() {
  var record = ('first', a: 2, b: true, 'last');
  print(record); // Prints (first, a: 2, b: true, last)
  print(record.$1); // Prints 'first'
  print(record.a); // Prints 2
  print(record.b); // Prints true
  print(record.$2); // Prints 'last'

  (int, int) swap((int, int) record) {
  var (a, b) = record;
  return (b, a);
}

  var record1 = (1, 2);
  print(swap(record1)); // Prints (2, 1)
}