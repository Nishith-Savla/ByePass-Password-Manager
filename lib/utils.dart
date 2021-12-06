import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

Uint8List generateKey(password, pepper, createdAt) {
  final key = utf8.encode(password + pepper + createdAt.toString());
  final hmacSha512256 = Hmac(sha512256, key);
  final ekey =
      Key(hmacSha512256.convert(utf8.encode(password)).bytes as Uint8List)
          .bytes;
  return ekey;
}
