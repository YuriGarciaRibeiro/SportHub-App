abstract class SecureStore {
  Future<void> setString(String key, String value);
  Future<String?> getString(String key);

  Future<void> setJson(String key, Map<String, Object?> value);
  Future<Map<String, dynamic>?> getJson(String key);

  Future<void> setWithTTL(String key, String value, Duration ttl);
  Future<String?> getWithTTL(String key);

  Future<bool> contains(String key);
  Future<void> delete(String key);
  Future<void> clear();
  SecureStore namespace(String prefix);
}
