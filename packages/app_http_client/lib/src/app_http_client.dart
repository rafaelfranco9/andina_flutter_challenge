abstract class AppHttpClient {
  /// get request
  Future<String?> get(String path);

  /// post request
  Future<void> post(String path, Map<String, dynamic> body);

  /// put request
  Future<void> put(String path, Map<String, dynamic> body);
}
