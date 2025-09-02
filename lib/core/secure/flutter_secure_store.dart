// lib/core/secure/flutter_secure_store.dart
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'secure_store.dart';

class FlutterSecureStore implements SecureStore {
  FlutterSecureStore(this._inner, {String? namespace})
      : _ns = (namespace != null && namespace.isNotEmpty) ? '$namespace:' : '';

  final FlutterSecureStorage _inner;
  final String _ns;

  String _k(String key) => '$_ns$key';

  @override
  Future<void> setString(String key, String value) =>
      _inner.write(key: _k(key), value: value);

  @override 
  Future<String?> getString(String key) => _inner.read(key: _k(key));

  @override
  Future<void> setJson(String key, Map<String, Object?> value) =>
      _inner.write(key: _k(key), value: jsonEncode(value));

  @override
  Future<Map<String, dynamic>?> getJson(String key) async {
    final s = await _inner.read(key: _k(key));
    if (s == null) return null;
    try { return jsonDecode(s) as Map<String, dynamic>; } catch (_) { return null; }
  }

  @override
  Future<void> setWithTTL(String key, String value, Duration ttl) async {
    final expMs = DateTime.now().millisecondsSinceEpoch + ttl.inMilliseconds;
    final envelope = {'v': value, 'exp': expMs};
    await _inner.write(key: _k(key), value: jsonEncode(envelope));
  }

  @override
  Future<String?> getWithTTL(String key) async {
    final s = await _inner.read(key: _k(key));
    if (s == null) return null;
    try {
      final m = jsonDecode(s) as Map<String, dynamic>;
      final exp = (m['exp'] as num?)?.toInt();
      if (exp != null && DateTime.now().millisecondsSinceEpoch > exp) {
        await _inner.delete(key: _k(key)); // expirou => limpa
        return null;
      }
      return (m['v'] as String?);
    } catch (_) {
      // não estava no formato TTL, retorna cru
      return s;
    }
  }

  @override
  Future<bool> contains(String key) => _inner.containsKey(key: _k(key));

  @override
  Future<void> delete(String key) => _inner.delete(key: _k(key));

  @override
  Future<void> clear() async {
    // Limpa só o namespace atual
    final all = await _inner.readAll();
    final keys = all.keys.where((k) => k.startsWith(_ns)).toList();
    for (final k in keys) {
      await _inner.delete(key: k);
    }
  }

  @override
  SecureStore namespace(String prefix) =>
      FlutterSecureStore(_inner, namespace: '$_ns$prefix');
}
