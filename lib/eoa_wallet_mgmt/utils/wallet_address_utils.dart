import 'dart:convert';
import 'dart:typed_data';

import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:hex/hex.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:bip39/bip39.dart' as bip39;

class WalletAddressUtils {
  static Future<String> getPrivateKey(String mnemonic) async {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final master = await ED25519_HD_KEY.getMasterKeyFromSeed(seed);
    return HEX.encode(master.key);
  }

  static EthereumAddress getPublicKey(String privateKey) {
    return EthPrivateKey.fromHex(privateKey).address;
  }

  static Future<String> signMessage(String privateKey, String message) async {
    final EthPrivateKey wallet = EthPrivateKey.fromHex(privateKey);
    final Uint8List hashedMessage =
        keccak256(Uint8List.fromList(utf8.encode(message)));

    final Uint8List signature =
        wallet.signPersonalMessageToUint8List(hashedMessage);
    return bytesToHex(signature, include0x: true);
  }
}
