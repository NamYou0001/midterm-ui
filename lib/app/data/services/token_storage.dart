import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  TokenStorage(this._preferences);
  static const _tokenKey = 'jwt_token';
  final SharedPreferences _preferences;

  String? get token => _preferences.getString(_tokenKey);
  Future<void> save(String token) => _preferences.setString(_tokenKey, token);
  Future<void> clear() => _preferences.remove(_tokenKey);
}
