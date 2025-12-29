/// API URL constants for Smart Presence application
class ApiUrl {
  // Private constructor to prevent instantiation
  ApiUrl._();

  /// Base URL for the API
  /// Use your computer's local IP address when testing on physical device
  /// Find your IP: Run 'ipconfig' (Windows) or 'ifconfig' (Mac/Linux)
  static const String baseUrl = 'http://192.168.100.250:8000/api';
}
