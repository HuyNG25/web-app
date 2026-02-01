import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window;

/// Token storage that works on both web and mobile platforms
class TokenStorage {
  static final TokenStorage _instance = TokenStorage._internal();
  factory TokenStorage() => _instance;
  TokenStorage._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static const String _tokenKey = 'jwt_token';

  /// Read token from storage
  Future<String?> readToken() async {
    if (kIsWeb) {
      // On web, use localStorage
      return html.window.localStorage[_tokenKey];
    } else {
      // On mobile, use secure storage
      return await _secureStorage.read(key: _tokenKey);
    }
  }

  /// Write token to storage
  Future<void> writeToken(String token) async {
    if (kIsWeb) {
      // On web, use localStorage
      html.window.localStorage[_tokenKey] = token;
    } else {
      // On mobile, use secure storage
      await _secureStorage.write(key: _tokenKey, value: token);
    }
  }

  /// Delete token from storage
  Future<void> deleteToken() async {
    if (kIsWeb) {
      // On web, remove from localStorage
      html.window.localStorage.remove(_tokenKey);
    } else {
      // On mobile, delete from secure storage
      await _secureStorage.delete(key: _tokenKey);
    }
  }

  /// Check if token exists
  Future<bool> hasToken() async {
    final token = await readToken();
    return token != null && token.isNotEmpty;
  }
}
