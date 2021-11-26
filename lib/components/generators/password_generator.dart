import 'dart:math' show Random;

class PasswordGenerator {
  PasswordGenerator(
    this.length, {
    this.addLowercaseLetters = true,
    this.addUppercaseLetters = true,
    this.addNumber = true,
    this.addSpecial = true,
  });

  final int length;
  final bool addLowercaseLetters;
  final bool addUppercaseLetters;
  final bool addNumber;
  final bool addSpecial;

  String generate() {
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
}
