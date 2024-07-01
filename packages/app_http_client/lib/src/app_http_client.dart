abstract class AppHttpClient {
  /// get request
  Future<String?> get(String path);

  /// post request
  Future<void> post(String path, dynamic body);

  /// put request
  Future<void> put(String path, dynamic body);
}
