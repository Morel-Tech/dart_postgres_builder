import 'dart:math';

const _chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

String generateRandomString(int length) {
  final rnd = Random();
  final randomString = StringBuffer();
  for (var i = 0; i < length; i++) {
    randomString.write(_chars[rnd.nextInt(_chars.length)]);
  }
  return randomString.toString();
}
