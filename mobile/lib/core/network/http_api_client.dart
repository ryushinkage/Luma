import 'dart:convert';
import 'dart:io';

import 'api_client.dart';

class HttpApiClient implements ApiClient {
  HttpApiClient({
    required String baseUrl,
    Future<String?> Function()? accessTokenReader,
    HttpClient? httpClient,
  })  : _baseUri = Uri.parse(baseUrl),
        _accessTokenReader = accessTokenReader,
        _httpClient = httpClient ?? HttpClient();

  final Uri _baseUri;
  final Future<String?> Function()? _accessTokenReader;
  final HttpClient _httpClient;

  @override
  Future<Map<String, Object?>> getJson(String endpoint) {
    return _sendJson('GET', endpoint);
  }

  @override
  Future<Map<String, Object?>> postJson(
    String endpoint, {
    Map<String, Object?> body = const {},
  }) {
    return _sendJson('POST', endpoint, body: body);
  }

  @override
  Future<Map<String, Object?>> putJson(
    String endpoint, {
    Map<String, Object?> body = const {},
  }) {
    return _sendJson('PUT', endpoint, body: body);
  }

  Future<Map<String, Object?>> _sendJson(
    String method,
    String endpoint, {
    Map<String, Object?> body = const {},
  }) async {
    try {
      final request = await _httpClient.openUrl(method, _resolve(endpoint));
      request.headers.set(HttpHeaders.acceptHeader, ContentType.json.mimeType);
      request.headers.set(
        HttpHeaders.contentTypeHeader,
        ContentType.json.mimeType,
      );

      final accessToken = await _accessTokenReader?.call();
      if (accessToken != null && accessToken.isNotEmpty) {
        request.headers.set(
          HttpHeaders.authorizationHeader,
          'Bearer $accessToken',
        );
      }

      if (method != 'GET') {
        request.write(jsonEncode(body));
      }

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiRequestFailure(
          'HTTP ${response.statusCode}: ${_errorMessage(responseBody)}',
        );
      }

      if (responseBody.trim().isEmpty) {
        return {};
      }

      final Object? decoded;
      try {
        decoded = jsonDecode(responseBody);
      } on FormatException {
        return {'rawResponse': responseBody};
      }

      if (decoded is! Map) {
        return {'rawResponse': decoded};
      }

      return Map<String, Object?>.from(decoded);
    } on ApiRequestFailure {
      rethrow;
    } on Exception catch (error) {
      throw ApiRequestFailure('Network request failed: $error');
    }
  }

  Uri _resolve(String endpoint) {
    final normalizedEndpoint = endpoint.startsWith('/')
        ? endpoint.substring(1)
        : endpoint;

    return _baseUri.resolve(normalizedEndpoint);
  }

  String _errorMessage(String responseBody) {
    if (responseBody.trim().isEmpty) {
      return 'empty response';
    }

    try {
      final decoded = jsonDecode(responseBody);
      if (decoded is Map<String, Object?>) {
        final message = decoded['message'] ?? decoded['error'];
        if (message is String && message.isNotEmpty) {
          return message;
        }
      }
    } on FormatException {
      return responseBody;
    }

    return responseBody;
  }
}
