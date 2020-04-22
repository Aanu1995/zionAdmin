import 'dart:convert';
import 'dart:math';

class HelperUtils {
  static String createRandomString([int length = 64]) {
    final Random _random = Random.secure();
    var values = List<int>.generate(length, (i) => _random.nextInt(256));
    return base64Url.encode(values);
  }
}
