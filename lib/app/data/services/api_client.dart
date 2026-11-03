import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_storage.dart';

class ApiException implements Exception {
  const ApiException(this.message, this.statusCode);
  final String message;
  final int statusCode;
  @override
  String toString() => message;
}

class ApiClient {
  ApiClient(this._storage, {String? baseUrl})
      : baseUrl = baseUrl ?? 'https://dummyjson.com';
  final TokenStorage _storage;
  final String baseUrl;

  Future<dynamic> request(String method, String path,
      {Map<String, dynamic>? body}) async {
    final headers = {'Content-Type': 'application/json'};
    final token = _storage.token;
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    final uri = Uri.parse('$baseUrl$path');
    final response = switch (method) {
      'GET' => await http.get(uri, headers: headers),
      'POST' => await http.post(uri, headers: headers, body: jsonEncode(body)),
      'PUT' => await http.put(uri, headers: headers, body: jsonEncode(body)),
      'DELETE' => await http.delete(uri, headers: headers),
      _ => throw const ApiException('Unsupported HTTP method', 0),
    };
    dynamic decoded;
    if (response.body.isNotEmpty) {
      try {
        decoded = jsonDecode(response.body);
      } on FormatException {
        throw ApiException('The server returned an invalid response.',
            response.statusCode);
      }
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message =
          decoded is Map<String, dynamic> ? decoded['message'] : null;
      throw ApiException(
          message as String? ?? 'Request failed (${response.statusCode}).',
          response.statusCode);
    }
    return decoded;
  }
}
