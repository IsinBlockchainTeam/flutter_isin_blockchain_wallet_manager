import 'package:flutter/material.dart';
import 'package:polygonid_flutter_sdk/sdk/polygon_id_sdk.dart';
import 'package:wallet_management/common/views/wallet_home.dart';
import 'package:wallet_management/eoa_wallet_mgmt/services/wallet_service.dart';
import 'package:wallet_management/vc_wallet_mgmt/services/vc_wallet_service.dart';

import '../shared_data.dart';
import 'download_screen_view.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  late PolygonIdSdk sdk = PolygonIdSdk.I;
  final WalletService walletService = WalletService();
  final VCWalletService vcWalletService = VCWalletService(PolygonIdSdk.I);

  @override
  void initState() {
    super.initState();

    checkCircuitDownloadStatus();

    initSharedData();
  }

  Future<void> checkCircuitDownloadStatus() async {
    bool isCircuitV2Available = await PolygonIdSdk.I.proof
        .isAlreadyDownloadedCircuitsFromServer(circuitsFileName: 'circuitsV2');
    bool isCircuitV3Available = await PolygonIdSdk.I.proof
        .isAlreadyDownloadedCircuitsFromServer(circuitsFileName: 'circuitsV3');

    debugPrint('CircuitsV2: $isCircuitV2Available');
    debugPrint('CircuitsV3: $isCircuitV3Available');

    if (!isCircuitV2Available | !isCircuitV3Available) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const DownloadScreen()));
    }
  }

  Future<void> initSharedData() async {
    sharedData.eoaWalletPrivateKey = await walletService.readPrivateKey();

    final String? vcPrivateKey = await vcWalletService.readPrivateKey();
    sharedData.vcWallet =
        await vcWalletService.retrieveIdentity(vcPrivateKey ?? '');

    debugPrint('Retrieved EOA private key: ${sharedData.eoaWalletPrivateKey}');
    debugPrint(
        'Retrieved EOA address: ${await walletService.getPublicKey(sharedData.eoaWalletPrivateKey!)}');
    debugPrint('Retrieved VC private key: ${sharedData.vcWallet?.privateKey}');
    debugPrint('Retrieved VC did: ${sharedData.vcWallet?.did}');

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
          vcWalletService: vcWalletService,
          walletService: walletService,
        ));
  }
}
