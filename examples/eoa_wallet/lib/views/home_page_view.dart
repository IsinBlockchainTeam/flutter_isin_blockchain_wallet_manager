import 'package:flutter/material.dart';
import 'package:flutter_isin_blockchain_wallet_manager/common/views/wallet_home.dart';
import 'package:flutter_isin_blockchain_wallet_manager/eoa_wallet_mgmt/services/wallet_service.dart';

import '../shared_data.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final WalletService walletService = WalletService();

  @override
  void initState() {
    super.initState();

    initSharedData();
  }

  Future<void> initSharedData() async {
    sharedData.eoaWalletPrivateKey = await walletService.readPrivateKey();

    debugPrint('Retrieved EOA private key: ${sharedData.eoaWalletPrivateKey}');
    debugPrint(
        'Retrieved EOA address: ${await walletService.getPublicKey(sharedData.eoaWalletPrivateKey!)}');

    debugPrint('Initialized');
  }

  @override
  Widget build(BuildContext context) {
    return WalletHome(
      isUnlocked: true,
      walletService: walletService,
    );
  }
}
