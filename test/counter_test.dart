import '../lib/test_files/counter.dart';
import 'package:test/test.dart';

void main() {
  test('Increment Counter', () {
    final counter = Counter();
    counter.increment();
    expect(counter.value, 1);
  });
}
