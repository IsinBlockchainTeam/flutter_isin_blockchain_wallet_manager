import 'package:bip39/bip39.dart' as bip39;

class WalletUtils {
  static String generateMnemonic() {
    return bip39.generateMnemonic();
  }
}
