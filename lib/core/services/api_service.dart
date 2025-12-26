import 'dart:convert';
import 'package:http/http.dart' as http;

/// API Service for handling HTTP requests
class ApiService {
  // Private constructor to prevent instantiation
  ApiService._();

  /// Authentication token
  static String? _token;

  /// Set authentication token
  static void setToken(String? token) {
    _token = token;
  }

  /// Get authentication token
  static String? getToken() {
    return _token;
  }

  /// Clear authentication token
  static void clearToken() {
    _token = null;
  }

  /// Build headers for API requests
  static Map<String, String> _buildHeaders({
    Map<String, String>? additionalHeaders,
  }) {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    // Add authorization header if token is available
    if (_token != null && _token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_token';
    }

    // Add any additional headers
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  /// Perform GET request
  ///
  /// [url] - The endpoint URL
  /// [headers] - Optional additional headers
  ///
  /// Returns the response body as a Map
  /// Throws an exception if the request fails
  static Future<Map<String, dynamic>> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: _buildHeaders(additionalHeaders: headers),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('GET request failed: $e');
    }
  }

  /// Perform POST request
  ///
  /// [url] - The endpoint URL
  /// [body] - The request body as a Map
  /// [headers] - Optional additional headers
  ///
  /// Returns the response body as a Map
  /// Throws an exception if the request fails
  static Future<Map<String, dynamic>> post(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: _buildHeaders(additionalHeaders: headers),
        body: body != null ? jsonEncode(body) : null,
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('POST request failed: $e');
    }
  }

  /// Handle HTTP response
  ///
  /// Parses the response and handles different status codes
  /// Returns the decoded JSON response
  /// Throws an exception for error status codes
  static Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;

    // Try to decode the response body
    Map<String, dynamic> decodedBody;
    try {
      decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      // If JSON decode fails, return a generic error
      throw Exception('Failed to parse response: ${response.body}');
    }

    // Handle different status codes
    if (statusCode >= 200 && statusCode < 300) {
      // Success
      return decodedBody;
    } else if (statusCode == 401) {
      // Unauthorized
      throw Exception(
        'Unauthorized: ${decodedBody['message'] ?? 'Authentication failed'}',
      );
    } else if (statusCode == 403) {
      // Forbidden
      throw Exception(
        'Forbidden: ${decodedBody['message'] ?? 'Access denied'}',
      );
    } else if (statusCode == 404) {
      // Not found
      throw Exception(
        'Not found: ${decodedBody['message'] ?? 'Resource not found'}',
      );
    } else if (statusCode == 422) {
      // Validation error
      throw Exception(
        'Validation error: ${decodedBody['message'] ?? 'Invalid data'}',
      );
    } else if (statusCode >= 500) {
      // Server error
      throw Exception(
        'Server error: ${decodedBody['message'] ?? 'Internal server error'}',
      );
    } else {
      // Other errors
      throw Exception(
        'Request failed with status $statusCode: ${decodedBody['message'] ?? 'Unknown error'}',
      );
    }
  }
}
