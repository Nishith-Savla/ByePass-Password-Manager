import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:encrypt/encrypt.dart';

class PasswordEntry {
  PasswordEntry(
      {required this.name,
      required this.email,
      required this.createdAt,
      required String password,
      required String url,
      required String key}) {
    uri = Uri.parse(url);
    _iv = IV.fromLength(16);
    _password = Encrypter(AES(Key.fromUtf8(key))).encrypt(password, iv: _iv);
  }

  String name;
  String email;
  late Encrypted _password;
  final Timestamp createdAt;
  late final IV _iv;
  late Uri uri;

  String getPassword(String key) {
    return Encrypter(AES(Key.fromUtf8(key))).decrypt(_password, iv: _iv);
  }

  void setPassword(String password, String key) {
    _password = Encrypter(AES(Key.fromUtf8(key))).encrypt(password, iv: _iv);
  }
}
