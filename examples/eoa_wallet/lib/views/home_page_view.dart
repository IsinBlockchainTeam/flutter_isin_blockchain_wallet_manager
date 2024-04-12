import 'package:flutter/material.dart';
import 'package:wallet_management/common/views/wallet_home.dart';
import 'package:wallet_management/eoa_wallet_mgmt/services/wallet_service.dart';

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
    return Scaffold(
        appBar: AppBar(
          title: const Text('Wallet Management Example app'),
          backgroundColor: Colors.cyanAccent,
        ),
        body: WalletHome(
          isUnlocked: true,
          walletService: walletService,
        ));
  }
}
