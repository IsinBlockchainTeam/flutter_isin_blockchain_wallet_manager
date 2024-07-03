class CounterUtils {
  static circularIncrement(int value, int max) {
    return (value + 1) % max;
  }
}
