import '../../common/storage/secure_storage.dart';
import '../../common/storage/wallet_storage_manager.dart';
import '../../utils/secure_storage_keys.dart';
import '../utils/wallet_address_utils.dart';

class WalletService extends WalletStorageManager {
  // TODO: Think how to validate the private key
  @override
  Future<String?> readPrivateKey() async {
    return SecureStorageService.read(SecureStorageKeys.eoaPrivateKey);
  }

  @override
  Future<void> setPrivateKey(String privateKey) async {
    return SecureStorageService.write(
        SecureStorageKeys.eoaPrivateKey, privateKey);
  }

  @override
  Future<void> delete() async {
    return SecureStorageService.delete(SecureStorageKeys.eoaPrivateKey);
  }

  @override
  Future<String?> readPassCodePin() {
    return SecureStorageService.read(SecureStorageKeys.passCodePin);
  }

  @override
  Future<void> setPassCodePin(String passCodePin) {
    return SecureStorageService.write(
        SecureStorageKeys.passCodePin, passCodePin);
  }

  @override
  Future<String> getPrivateKey(String seed) async {
    return WalletAddressUtils.getPrivateKey(seed);
  }

  @override
  Future<String> getPublicKey(String privateKey) async {
    return Future.value(WalletAddressUtils.getPublicKey(privateKey).toString());
  }

  Future<String> signMessage(String privateKey, String message) async {
    return WalletAddressUtils.signMessage(privateKey, message);
  }
}
