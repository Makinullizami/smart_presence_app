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

  /// Perform Multipart POST request
  static Future<Map<String, dynamic>> postMultipart(
    String url, {
    required Map<String, String> fields,
    required String fileField,
    required dynamic
    file, // File (dart:io), String (path), or List<int> (bytes)
    String? filename, // Required if file is List<int>
    Map<String, String>? headers,
  }) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));

      // Add headers
      final authHeaders = _buildHeaders(additionalHeaders: headers);
      if (authHeaders.containsKey('Content-Type')) {
        authHeaders.remove('Content-Type'); // Let MultipartRequest handle it
      }
      request.headers.addAll(authHeaders);

      // Add fields
      fields.forEach((key, value) {
        request.fields[key] = value;
      });

      // Add file
      if (file != null) {
        http.MultipartFile multipartFile;

        if (file is List<int>) {
          // Handle bytes (Web or Memory)
          multipartFile = http.MultipartFile.fromBytes(
            fileField,
            file,
            filename: filename ?? 'upload.jpg',
          );
        } else if (file is String) {
          // Handle path string
          multipartFile = await http.MultipartFile.fromPath(fileField, file);
        } else {
          // Handle File object (dynamic check for dart:io File)
          // We use dynamic to avoid importing dart:io directly if possible in core,
          // but since we can't easily check 'is File' without import, assume it has .path
          // For Web safety, we should really be passing bytes or XFile from the UI layer.
          // However, to fix the immediate crash:
          try {
            // Try assuming it's a File object with a path property
            final path = (file as dynamic).path;
            multipartFile = await http.MultipartFile.fromPath(fileField, path);
          } catch (_) {
            // Fallback or error if not file-like
            throw Exception('Unsupported file format for upload');
          }
        }

        request.files.add(multipartFile);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Multipart POST request failed: $e');
    }
  }

  /// Perform PUT request
  ///
  /// [url] - The endpoint URL
  /// [body] - The request body as a Map
  /// [headers] - Optional additional headers
  ///
  /// Returns the response body as a Map
  /// Throws an exception if the request fails
  static Future<Map<String, dynamic>> put(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: _buildHeaders(additionalHeaders: headers),
        body: body != null ? jsonEncode(body) : null,
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('PUT request failed: $e');
    }
  }

  /// Perform DELETE request
  ///
  /// [url] - The endpoint URL
  /// [headers] - Optional additional headers
  ///
  /// Returns the response body as a Map
  /// Throws an exception if the request fails
  static Future<Map<String, dynamic>> delete(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: _buildHeaders(additionalHeaders: headers),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('DELETE request failed: $e');
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
