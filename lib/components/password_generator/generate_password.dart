import 'dart:math' show Random;

String generatePassword(
  int length, {
  bool addLowercaseLetters = true,
  bool addUppercaseLetters = true,
  bool addNumber = true,
  bool addSpecial = true,
}) {
  final allowedChars = StringBuffer()
    ..write((addLowercaseLetters) ? "abcdefghijklmnopqrstuvwxyz" : null)
    ..write((addUppercaseLetters) ? "ABCDEFGHIJKLMNOPQRSTUVWXYZ" : null)
    ..write((addNumber) ? '0123456789' : null)
    ..write((addSpecial) ? r'@#%^*>\$@?/[]=+' : null);

  final charsString = allowedChars.toString();
  final random = Random.secure();
  return List<String>.generate(
          length, (index) => charsString[random.nextInt(allowedChars.length)])
      .join('');
}
