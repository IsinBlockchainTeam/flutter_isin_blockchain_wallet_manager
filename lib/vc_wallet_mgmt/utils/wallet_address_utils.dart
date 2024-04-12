import 'dart:typed_data';

import 'package:crypto/crypto.dart';

class WalletAddressUtils {
  static getFormattedSecretString({String? secret}) {
    if (secret == null) {
      return null;
    }
    final digest = sha256.convert(secret.codeUnits);
    return String.fromCharCodes(Uint16List.fromList(digest.bytes));
  }
}
