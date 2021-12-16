import 'dart:convert' show utf8;
import 'dart:typed_data' show Uint8List;

import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:crypto/crypto.dart' show Hmac, sha512256;
import 'package:encrypt/encrypt.dart' show Key;
import 'package:flutter/material.dart'
    show BuildContext, ScaffoldMessenger, SnackBar, Text;
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    show AndroidOptions, FlutterSecureStorage;

Uint8List generateKey(String password, String pepper, Timestamp createdAt) {
  final key = utf8.encode(password + pepper + createdAt.toString());
  final hmacSha512256 = Hmac(sha512256, key);
  return Key(hmacSha512256.convert(utf8.encode(password)).bytes as Uint8List)
      .bytes;
}

void copyToClipboard({
  required BuildContext context,
  required String name,
  required String data,
}) {
  Clipboard.setData(ClipboardData(text: data)).then((_) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$name has been copied to clipboard")),
    );
  });
}

// Local storage

const _storage = FlutterSecureStorage();

Future<String?> readFromStorage(String key) async =>
    await _storage.read(key: key, aOptions: _getAndroidOptions());

Future<void> writeToStorage(String key, String value) async => await _storage
    .write(key: key, value: value, aOptions: _getAndroidOptions());

AndroidOptions _getAndroidOptions() =>
    const AndroidOptions(encryptedSharedPreferences: true);

// Master password

Future<String> getMasterPassword() async =>
    await readFromStorage('byepass') ?? '';

Future<void> setMasterPassword(String password) async =>
    await writeToStorage('byepass', password);

String get pepper => dotenv.env['PEPPER']!;
