import 'dart:math';

import 'package:flutter/foundation.dart' show describeEnum;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show LengthLimitingTextInputFormatter, TextInputType;
import 'package:password_manager/components/generators/passphrase_generator.dart';
import 'package:password_manager/components/generators/password_generator.dart';

enum GenerateType { password, passphrase }

extension EnumWithStringValue on Enum {
  String valueAsString() => describeEnum(this);
}

class Generate extends StatefulWidget {
  final GenerateType generateType;

  const Generate({Key? key, required this.generateType}) : super(key: key);

  @override
  State<Generate> createState() => _GenerateState();
}

class _GenerateState extends State<Generate> {
  late GenerateType generateType;

  late final PassphraseGenerator passphraseGenerator;
  late final PasswordGenerator passwordGenerator;
  late int length;
  late final TextEditingController lengthController;
  String generatedValue = "Generating... ";

  void _handleLengthChange(double value) {
    final newLength = value.toInt();
    if (newLength == length) return;

    setState(() => length = newLength);
    lengthController.text = length.toString();
  }

  Future<String> _generate() async {
    if (generateType == GenerateType.password) {
      return passwordGenerator.generate();
    }

    // Else the generateType is passphrase, so
    // Check if wordList is fetched
    if (passphraseGenerator.wordList.isNotEmpty) {
      return await passphraseGenerator.generate();
    }

    // Else try to fetch
    // If couldn't fetch, keep fetching
    if (!await passphraseGenerator.fetchWordList()) {
      await passphraseGenerator.keepFetchingWordList();
    }

    return await passphraseGenerator.generate();
  }

  void _regenerate() async {
    final value = await _generate();
    setState(() => generatedValue = value);
  }

  @override
  void initState() {
    super.initState();
    generateType = widget.generateType;
    passphraseGenerator = PassphraseGenerator(3);
    passwordGenerator = PasswordGenerator(12);

    () async {
      generatedValue = await _generate();
    }();

    length = generateType == GenerateType.password
        ? passwordGenerator.length
        : passphraseGenerator.wordCount;

    lengthController = TextEditingController(text: length.toString());
    lengthController.addListener(() {
      final newLength = int.tryParse(lengthController.text) ?? length;
      if (newLength > 7 && newLength < 51) {
        setState(() => length = newLength);
        passwordGenerator.length = newLength;
        _regenerate();
      }
    });
  }

  Widget renderPasswordGeneratorFields(Size size) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            const Text("Length"),
            Expanded(
              child: Slider(
                value: length.toDouble(),
                min: 8,
                max: 50,
                divisions: 50 - 8 - 1,
                onChanged: _handleLengthChange,
              ),
            ),
            SizedBox(
              width: size.width * 0.125,
              child: TextField(
                controller: lengthController,
                inputFormatters: [LengthLimitingTextInputFormatter(2)],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            const Expanded(child: Text('Include lowercase letters: ')),
            Switch(
              value: passwordGenerator.addLowercaseLetters,
              onChanged: (bool value) {
                passwordGenerator.addLowercaseLetters = value;
                _regenerate();
              },
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            const Expanded(child: Text('Include uppercase letters: ')),
            Switch(
              value: passwordGenerator.addUppercaseLetters,
              onChanged: (bool value) {
                passwordGenerator.addUppercaseLetters = value;
                _regenerate();
              },
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            const Expanded(
              child: Text('Minimum special characters: '),
            ),
            Text(passwordGenerator.minSpecialChars.toString()),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
              child: ElevatedButton(
                child: const Text('-'),
                onPressed: passwordGenerator.minSpecialChars > 0
                    ? () {
                        --passwordGenerator.minSpecialChars;
                        _regenerate();
                      }
                    : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
              child: ElevatedButton(
                child: const Text('+'),
                onPressed: passwordGenerator.minSpecialChars <
                        min(5, passwordGenerator.length / 2 - 1)
                    ? () {
                        ++passwordGenerator.minSpecialChars;
                        _regenerate();
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            const Expanded(
              child: Text('Minimum numbers: '),
            ),
            Text(passwordGenerator.minNumbers.toString()),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
              child: ElevatedButton(
                child: const Text('-'),
                onPressed: passwordGenerator.minNumbers > 0
                    ? () {
                        --passwordGenerator.minNumbers;
                        _regenerate();
                      }
                    : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
              child: ElevatedButton(
                child: const Text('+'),
                onPressed: passwordGenerator.minNumbers <
                        min(5, passwordGenerator.length / 2 - 1)
                    ? () {
                        ++passwordGenerator.minNumbers;
                        _regenerate();
                      }
                    : null,
              ),
            ),
          ],
        ),
      )
    ]);
  }

  Widget renderPassphraseGeneratorFields(Size size) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            const Expanded(
              child: Text('Word Count: '),
            ),
            Text(passphraseGenerator.wordCount.toString()),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
              child: ElevatedButton(
                child: const Text('-'),
                onPressed: passphraseGenerator.wordCount > 3
                    ? () {
                        --passphraseGenerator.wordCount;
                        _regenerate();
                      }
                    : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
              child: ElevatedButton(
                child: const Text('+'),
                onPressed: passphraseGenerator.wordCount < 16
                    ? () {
                        ++passphraseGenerator.wordCount;
                        _regenerate();
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            const Expanded(child: Text('Include numbers: ')),
            Switch(
              value: passphraseGenerator.includeNumbers,
              onChanged: (bool value) {
                passphraseGenerator.includeNumbers = value;
                _regenerate();
              },
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            const Expanded(child: Text('Capitalize each word: ')),
            Switch(
              value: passphraseGenerator.shouldCapitalize,
              onChanged: (bool value) {
                passphraseGenerator.shouldCapitalize = value;
                _regenerate();
              },
            ),
          ],
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Generate',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(child: Text(generatedValue)),
                  Row(
                    children: [
                      IconButton(
                          onPressed: _regenerate,
                          icon: const Icon(Icons.autorenew_outlined)),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.content_copy_outlined)),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<GenerateType>(
                  isExpanded: true,
                  items: const <DropdownMenuItem<GenerateType>>[
                    DropdownMenuItem(
                        value: GenerateType.password, child: Text("Password")),
                    DropdownMenuItem(
                        value: GenerateType.passphrase,
                        child: Text("Passphrase")),
                  ],
                  onChanged: (GenerateType? generateType) {
                    setState(() => this.generateType = generateType!);
                    _regenerate();
                  },
                  value: generateType,
                ),
              ),
            ),
            generateType == GenerateType.password
                ? renderPasswordGeneratorFields(size)
                : renderPassphraseGeneratorFields(size),
          ],
        ),
      ),
    );
  }
}
