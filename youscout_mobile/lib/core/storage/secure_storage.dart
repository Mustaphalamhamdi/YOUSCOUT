import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// JWT persistence wrapper.
// Uses Keychain on iOS, EncryptedSharedPreferences on Android.
class SecureStorage {
  static const _tokenKey = 'jwt_token';
  static const _userIdKey = 'user_id';

  final FlutterSecureStorage _storage;

  const SecureStorage(this._storage);

  Future<void> saveToken(String token) => _storage.write(key: _tokenKey, value: token);
  Future<String?> readToken() => _storage.read(key: _tokenKey);
  Future<void> deleteToken() => _storage.delete(key: _tokenKey);

  Future<void> saveUserId(String userId) => _storage.write(key: _userIdKey, value: userId);
  Future<String?> readUserId() => _storage.read(key: _userIdKey);

  Future<void> clearAll() => _storage.deleteAll();
}
