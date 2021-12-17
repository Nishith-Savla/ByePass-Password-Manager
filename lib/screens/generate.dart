import 'dart:math';

import 'package:flutter/foundation.dart' show describeEnum;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _GreyBackground extends StatelessWidget {
  final Widget child;
  final double verticalPadding;
  final double horizontalPadding;
  final double verticalMargin;
  final double horizontalMargin;

  const _GreyBackground(
      {Key? key,
      required this.child,
      this.horizontalMargin = 0.0,
      this.verticalPadding = 3.0,
      this.horizontalPadding = 10.0,
      this.verticalMargin = 5.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25.0),
      ),
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      margin: EdgeInsets.symmetric(
        vertical: verticalMargin,
        horizontal: horizontalMargin,
      ),
      child: child,
    );
  }
}

class _GenerateState extends State<Generate> {
  late GenerateType generateType;
  late final PassphraseGenerator passphraseGenerator;
  late final PasswordGenerator passwordGenerator;
  late int length;
  String generatedValue = "Generating... ";

  void _copyToClipBoard(String value) {
    Clipboard.setData(ClipboardData(
      text: value,
    )).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "password has been copied to your clipboard",
          ),
        ),
      );
    });
  }

  void _onLengthChange(double value) {
    final newLength = value.toInt();
    if (newLength == length) return;

    setState(() => length = newLength);

    if (newLength < length && generateType == GenerateType.password) {
      passwordGenerator.minSpecialChars = min(5, (length / 2 - 1).round());
      passwordGenerator.minNumbers = min(5, (length / 2 - 1).round());
    }
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
      final _generated = await _generate();
      setState(() => generatedValue = _generated);
    }();

    length = generateType == GenerateType.password
        ? passwordGenerator.length
        : passphraseGenerator.wordCount;
  }

  bool canDecrementSpecialChar() => passwordGenerator.minSpecialChars > 0;

  void onSpecialCharDecrement() {
    --passwordGenerator.minSpecialChars;
    _regenerate();
  }

  bool canIncrementSpecialChar() =>
      passwordGenerator.minSpecialChars <
      min(5, passwordGenerator.length / 2 - 1);

  void onSpecialCharIncrement() {
    ++passwordGenerator.minSpecialChars;
    _regenerate();
  }

  bool canDecrementNumber() => passwordGenerator.minNumbers > 0;

  void onNumberDecrement() {
    if (passwordGenerator.minNumbers > 0) {
      --passwordGenerator.minNumbers;
      _regenerate();
    }
  }

  bool canIncrementNumber() =>
      passwordGenerator.minNumbers < min(5, passwordGenerator.length / 2 - 1);

  void onNumberIncrement() {
    if (passwordGenerator.minNumbers <
        min(5, passwordGenerator.length / 2 - 1)) {
      ++passwordGenerator.minNumbers;
      _regenerate();
    }
  }

  Widget _renderNumericRow({
    required String title,
    required String number,
    required bool Function() canDecrement,
    required bool Function() canIncrement,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return _GreyBackground(
      verticalPadding: 10.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
          Row(
            children: [
              SizedBox(
                height: 35.0,
                width: 35.0,
                child: ElevatedButton(
                  onPressed: canDecrement() ? onDecrement : null,
                  child: const Text(
                    '-',
                    style: TextStyle(fontSize: 18.0),
                    textAlign: TextAlign.center,
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: Text(
                  number.padLeft(2, '0'),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
              ),
              SizedBox(
                height: 35.0,
                width: 35.0,
                child: ElevatedButton(
                  onPressed: canIncrement() ? onIncrement : null,
                  child: const Text(
                    '+',
                    style: TextStyle(fontSize: 18.0),
                    textAlign: TextAlign.center,
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _renderSwitch(
      {required String title,
      required bool value,
      required Function(bool onChangeValue) onChanged}) {
    return _GreyBackground(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget renderPasswordGeneratorFields() {
    return Column(
      children: [
        // Slider component-
        Container(
          padding: const EdgeInsets.only(top: 10.0),
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'LENGTH: $length',
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              _GreyBackground(
                verticalMargin: 15.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text('8'),
                      flex: 5,
                    ),
                    Expanded(
                      child: Slider(
                        label: length.toString(),
                        value: length.toDouble(),
                        min: 8,
                        max: 50,
                        divisions: 50 - 8 - 1,
                        onChanged: _onLengthChange,
                      ),
                      flex: 150,
                    ),
                    const Expanded(
                      child: Text('50'),
                      flex: 10,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),

        Divider(
          color: Colors.grey.shade400,
        ),

        // All settings components-
        Container(
          margin: const EdgeInsets.symmetric(vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 15.0),
                child: const Text(
                  'SETTINGS',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),

              // Include lower case switch component-
              _renderSwitch(
                title: 'Include lowercase letters',
                value: passwordGenerator.addLowercaseLetters,
                onChanged: (bool value) {
                  passwordGenerator.addLowercaseLetters = value;
                  _regenerate();
                },
              ),

              // Include upper case switch component-
              _renderSwitch(
                title: 'Include uppercase letters',
                value: passwordGenerator.addUppercaseLetters,
                onChanged: (bool value) {
                  passwordGenerator.addUppercaseLetters = value;
                  _regenerate();
                },
              ),

              // Minimum no. of special characters component-
              _renderNumericRow(
                title: 'Special characters',
                number: passwordGenerator.minSpecialChars.toString(),
                canDecrement: canDecrementSpecialChar,
                canIncrement: canIncrementSpecialChar,
                onDecrement: onSpecialCharDecrement,
                onIncrement: onSpecialCharIncrement,
              ),

              // Minimum no. of numbers component-
              _renderNumericRow(
                title: 'Minimum numbers',
                number: passwordGenerator.minNumbers.toString(),
                canDecrement: canDecrementNumber,
                canIncrement: canIncrementNumber,
                onDecrement: onNumberDecrement,
                onIncrement: onNumberIncrement,
              )
            ],
          ),
        ),
      ],
    );
  }

  bool canIncrementWordCount() => passphraseGenerator.wordCount < 16;

  bool canDecrementWordCount() => passphraseGenerator.wordCount > 3;

  void onWordCountIncrement() {
    ++passphraseGenerator.wordCount;
    _regenerate();
  }

  void onWordCountDecrement() {
    --passphraseGenerator.wordCount;
    _regenerate();
  }

  Widget renderPassphraseGeneratorFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 15.0),
          child: const Text(
            'SETTINGS',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
        _renderNumericRow(
          title: 'Word Count',
          number: passphraseGenerator.wordCount.toString(),
          canDecrement: canDecrementWordCount,
          canIncrement: canIncrementWordCount,
          onDecrement: onWordCountDecrement,
          onIncrement: onWordCountIncrement,
        ),
        _renderSwitch(
          title: 'Include numbers',
          value: passphraseGenerator.includeNumbers,
          onChanged: (bool value) {
            passphraseGenerator.includeNumbers = value;
            _regenerate();
          },
        ),
        _renderSwitch(
          title: 'Capitalize',
          value: passphraseGenerator.shouldCapitalize,
          onChanged: (bool value) {
            passphraseGenerator.shouldCapitalize = value;
            _regenerate();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Generate',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _regenerate,
            icon: const Icon(
              Icons.autorenew_outlined,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 20.0,
          ),
          child: Column(
            children: [
              // 1st-
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'CLICK TO COPY PASSWORD',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: _GreyBackground(
                      verticalPadding: 15.0,
                      child: Text(
                        generatedValue,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ),
                    onTap: () => _copyToClipBoard(generatedValue),
                  ),
                ],
              ),

              Container(
                margin: const EdgeInsets.symmetric(vertical: 15.0),
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
              generateType == GenerateType.password
                  ? renderPasswordGeneratorFields()
                  : renderPassphraseGeneratorFields(),
            ],
          ),
        ),
      ),
    );
  }
}
