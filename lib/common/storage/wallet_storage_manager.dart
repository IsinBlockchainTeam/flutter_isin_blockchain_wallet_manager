import '../utils/wallet_utils.dart';

abstract class WalletStorageManager {
  // TODO: Think how to validate the private key
  Future<String?> readPrivateKey();

  Future<void> setPrivateKey(String privateKey);

  Future<void> delete();

  Future<String?> readPassCodePin();

  Future<void> setPassCodePin(String passCodePin);

  String generateMnemonic() {
    return WalletUtils.generateMnemonic();
  }

  Future<String> getPrivateKey(String seed);

  Future<String> getPublicKey(String privateKey);
}
