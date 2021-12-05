import 'dart:math' show Random;

class PasswordGenerator {
  PasswordGenerator(
    this.length, {
    this.addLowercaseLetters = true,
    this.addUppercaseLetters = true,
    this.minNumbers = 1,
    this.minSpecialChars = 1,
  }) : _random = Random.secure();

  int length;
  bool addLowercaseLetters;
  bool addUppercaseLetters;
  int minNumbers;
  int minSpecialChars;
  final Random _random;

  String generate() {
    const lowercaseLetters = "abcdefghijklmnopqrstuvwxyz";
    const uppercaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    const numbers = '0123456789';
    const specialChars = r'!@#$%^&*()-+=';

    final generated = <String>[];

    final allowedChars = StringBuffer();
    if (addLowercaseLetters) {
      generated.add(lowercaseLetters[_random.nextInt(lowercaseLetters.length)]);
      allowedChars.write(lowercaseLetters);
    }
    if (addUppercaseLetters) {
      generated.add(uppercaseLetters[_random.nextInt(uppercaseLetters.length)]);
      allowedChars.write(uppercaseLetters);
    }

    if (minNumbers > 0) {
      allowedChars.write(numbers);
      for (int i = 0; i < minNumbers; ++i) {
        generated.add(numbers[_random.nextInt(numbers.length)]);
      }
    }

    if (minSpecialChars > 0) {
      allowedChars.write(specialChars);
      for (int i = 0; i < minSpecialChars; ++i) {
        generated.add(specialChars[_random.nextInt(specialChars.length)]);
      }
    }

    final charsString = allowedChars.toString();

    for (int i = generated.length; i < length; ++i) {
      generated.add(charsString[_random.nextInt(charsString.length)]);
    }

    generated.shuffle(_random);

    return generated.join();
  }
}
