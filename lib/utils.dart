import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Uint8List generateKey(String password, String pepper, Timestamp createdAt) {
  final key = utf8.encode(password + pepper + createdAt.toString());
  final hmacSha512256 = Hmac(sha512256, key);
  final ekey =
      Key(hmacSha512256.convert(utf8.encode(password)).bytes as Uint8List)
          .bytes;
  return ekey;
}

// Local storage

const _storage = FlutterSecureStorage();

Future<String?> readFromStorage(String key) async =>
    await _storage.read(key: key, aOptions: _getAndroidOptions());

Future<void> writeToStorage(String key, String value) async => await _storage
    .write(key: key, value: value, aOptions: _getAndroidOptions());

AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );

// Master password

Future<String> getMasterPassword() async =>
    await readFromStorage('byepass') ?? '';

Future<void> setMasterPassword(String password) async =>
    await writeToStorage('byepass', password);

String get pepper => dotenv.env['PEPPER']!;
