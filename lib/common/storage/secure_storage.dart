import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService{

    static const _storage = FlutterSecureStorage();

    static Future<String?> read(String key) async {
        return await _storage.read(key:key);
    }

    static Future<void> write(String key, String value) async {
        await _storage.write(key:key, value: value);
    }

    static Future<void> delete(String key) async {
        await _storage.delete(key:key);
    }
}