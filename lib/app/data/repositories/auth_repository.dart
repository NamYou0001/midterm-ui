import '../models/models.dart';
import '../services/api_client.dart';
import '../services/token_storage.dart';

class AuthRepository {
  AuthRepository(this._client, this._storage);
  final ApiClient _client;
  final TokenStorage _storage;

  Future<User> login(String username, String password) async {
    final data = await _client.request('POST', '/auth/login', body: {
      'username': username,
      'password': password,
      'expiresInMins': 60,
    }) as Map<String, dynamic>;
    await _storage.save(
        data['accessToken'] as String? ?? data['token'] as String? ?? '');
    return User.fromJson(data);
  }

  Future<void> logout() => _storage.clear();
}
