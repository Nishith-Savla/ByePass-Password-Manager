import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart'
    show DocumentSnapshot, Timestamp;
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart' show hashValues;

class PasswordEntry {
  PasswordEntry(this.name,
      {required this.email,
      required this.createdAt,
      required String password,
      required String url,
      required Uint8List key,
      this.referenceId}) {
    uri = Uri.parse(url);
    _iv = IV.fromLength(16);
    _password = Encrypter(AES(Key(key))).encrypt(password, iv: _iv);
  }

  String name;
  String email;
  late Encrypted _password;
  final Timestamp createdAt;
  late final IV _iv;
  late Uri uri;
  String? referenceId;

  factory PasswordEntry.fromSnapshot(DocumentSnapshot snapshot,
      {required Uint8List key}) {
    final newEntry = PasswordEntry.fromJson(
        snapshot.data() as Map<String, dynamic>,
        key: key);
    newEntry.referenceId = snapshot.reference.id;
    return newEntry;
  }

  factory PasswordEntry.fromJson(Map<String, dynamic> json,
          {required Uint8List key}) =>
      PasswordEntry(
        json['name'] as String,
        email: json['email'] as String,
        createdAt: json['createdAt'] as Timestamp,
        password: json['password'] as String,
        url: json['url'] as String,
        key: key,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'email': email,
        'createdAt': createdAt,
        'password': _password,
        'url': uri,
      };

  String getPassword(Uint8List key) {
    return Encrypter(AES(Key(key))).decrypt(_password, iv: _iv);
  }

  void setPassword(String password, Uint8List key) {
    _password = Encrypter(AES(Key(key))).encrypt(password, iv: _iv);
  }

  @override
  bool operator ==(Object other) {
    return other is PasswordEntry &&
        other.name == name &&
        other.createdAt == createdAt &&
        other.email == email &&
        other.uri == uri;
  }

  @override
  String toString() => "PasswordEntry<$name>";

  @override
  int get hashCode => hashValues(name, email, uri, createdAt);
}
