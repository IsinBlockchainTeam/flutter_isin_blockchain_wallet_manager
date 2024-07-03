import 'package:flutter/material.dart';
import 'package:flutter_isin_blockchain_wallet_manager/common/component/wallet/custom_qr_code.dart';

class EthereumQrCode extends StatelessWidget {
  final String address;
  final double size;

  const EthereumQrCode({super.key, required this.address, this.size = 300});

  @override
  Widget build(BuildContext context) {
    return CustomQrCode(
      data: 'ethereum:$address',
      size: size,
    );
  }
}
