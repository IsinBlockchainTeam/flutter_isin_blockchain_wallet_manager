import 'package:flutter/material.dart';

import '../../eoa_wallet_mgmt/services/wallet_service.dart';
import '../model/vc_wallet.dart';
import '../services/vc_wallet_service.dart';

class VCWalletSetup extends StatefulWidget {
  const VCWalletSetup(
      {super.key,
      required this.walletService,
      required this.vcWalletService,
      required this.onFinished});

  final WalletService walletService;
  final VCWalletService vcWalletService;
  final Widget Function(BuildContext) onFinished;

  @override
  State<VCWalletSetup> createState() => _VCWalletSetupState();
}

class _VCWalletSetupState extends State<VCWalletSetup> {
  Future<VCWallet?> _createVcWallet() async {
    final secret = await widget.walletService.readPrivateKey();

    debugPrint("Creation vcWallet secret: $secret");

    if (secret != null) {
      final VCWallet vcWallet =
          await widget.vcWalletService.createIdentity(secret);

      debugPrint(
          "Identity not available, created new identity with: did: ${vcWallet.did}, privKey: ${vcWallet.privateKey}");

      await widget.vcWalletService.setPrivateKey(vcWallet.privateKey);

      debugPrint("Identity stored into SecureStorage");

      return vcWallet;
    }

    return null;
  }

  Future<VCWallet?> _createVcWalletNextStep(BuildContext context) {
    return _createVcWallet().then((vcWallet) {
      if (vcWallet != null) {
        Navigator.of(context).popUntil((route) => false);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: widget.onFinished,
          ),
        );
      }
      return vcWallet;
    });
  }

  // Future<VCWallet?> _createVcWalletNextStep(BuildContext context) async {
  //   final VCWallet? vcWallet = await _createVcWallet();
  //   if (vcWallet != null) {
  //     Navigator.of(context).popUntil((route) => false);
  //     Navigator.of(context).push(
  //       MaterialPageRoute(
  //         builder: widget.onFinished,
  //         maintainState: false,
  //       ),
  //     );
  //   }
  //   return vcWallet;
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _createVcWalletNextStep(context),
      builder: (BuildContext context, AsyncSnapshot<VCWallet?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        VCWallet? vcWallet = snapshot.data;

        if (vcWallet != null) {
          return Container();
        } else {
          return const Center(
            child: Text('Error'),
          );
        }
      },
    );
  }
}
