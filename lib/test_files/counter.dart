class Counter {
  int value = 0;

  void increment() {
    value++;
    print('$value');
  }

  void decrement() => value--;
}
