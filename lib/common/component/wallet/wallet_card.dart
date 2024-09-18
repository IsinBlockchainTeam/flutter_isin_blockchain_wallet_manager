import 'package:flutter/material.dart';
import 'package:flutter_isin_ui_kit/components/fields/clipboard_copyable_field.dart';
import 'package:flutter_isin_ui_kit/components/fields/field_obscurable.dart';

import 'ethereum_qr_code.dart';

class WalletCard extends StatelessWidget {
  final String? eoaWalletAddress;
  final String? eoaWalletPrivateKey;
  final String? did;
  final Color? iconColor;

  const WalletCard(
      {super.key,
      this.eoaWalletAddress,
      this.eoaWalletPrivateKey,
      this.did,
      this.iconColor});

  Widget _buildWalletAddressQrCode(String? walletAddress) {
    Widget result = Container();

    if (walletAddress != null) {
      result = EthereumQrCode(
        address: walletAddress,
        size: 200,
      );
    }

    return result;
  }

  Widget _buildWalletAddressCopyableField(String? walletAddress) {
    Widget result = Container();

    if (walletAddress != null) {
      result = ClipboardCopyableField(
        label: 'Wallet address',
        value: walletAddress.toString(),
        iconColor: iconColor,
      );
    }

    return result;
  }

  Widget _buildPrivateField(String labelText, String? value) {
    Widget result = Container();

    if (value != null) {
      result = FieldObscurable(
        labelText: labelText,
        text: value.toString(),
        iconColor: iconColor,
      );
    }

    return result;
  }

  Widget _buildEoaWalletDetails(
      String? eoaWalletAddress, String? eoaWalletPrivateKey) {
    return Column(
      children: [
        _buildWalletAddressQrCode(eoaWalletAddress),
        _buildWalletAddressCopyableField(eoaWalletAddress),
        const SizedBox(height: 15),
        _buildPrivateField('Wallet private key', eoaWalletPrivateKey),
      ],
    );
  }

  Widget _buildVcWalletDetails(String? did) {
    return _buildPrivateField('Did', did);
  }

  Widget _buildWalletCard() {
    return Card(
      surfaceTintColor: Colors.transparent,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildEoaWalletDetails(eoaWalletAddress, eoaWalletPrivateKey),
            const SizedBox(height: 15),
            _buildVcWalletDetails(did),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildWalletCard();
  }
}
