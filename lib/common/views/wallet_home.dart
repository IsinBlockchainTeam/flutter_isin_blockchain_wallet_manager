import 'package:flutter/material.dart';
import 'package:flutter_isin_blockchain_wallet_manager/common/component/wallet/wallet_card.dart';

import '../../eoa_wallet_mgmt/services/wallet_service.dart';
import '../../vc_wallet_mgmt/model/vc_wallet.dart';
import '../../vc_wallet_mgmt/services/vc_wallet_service.dart';
import '../component/menu_button_eraser.dart';

class WalletHome extends StatefulWidget {
  const WalletHome({
    super.key,
    required this.isUnlocked,
    this.vcWalletService,
    required this.walletService,
    this.buildAppBar,
    this.backgroundColor,
    this.iconColor,
  });

  final bool isUnlocked;
  final VCWalletService? vcWalletService;
  final WalletService walletService;

  final PreferredSizeWidget Function(List<Widget>)? buildAppBar;
  final Color? backgroundColor;
  final Color? iconColor;

  @override
  State<WalletHome> createState() => _WalletHomeState();
}

class _WalletHomeState extends State<WalletHome> {
  late final String? storedPin;

  late String? eoaWalletPrivateKey;
  late String? eoaWalletAddress;
  VCWallet? vcWallet;
  late Future<void> initialized;

  @override
  void initState() {
    super.initState();
    initialized = init();
  }

  readEoaPrivateKey() async {
    String? privateKey = await widget.walletService.readPrivateKey();
    setState(() {
      eoaWalletPrivateKey = privateKey;
    });
  }

  initEoaWalletAddress() async {
    String walletAddress =
        await widget.walletService.getPublicKey(eoaWalletPrivateKey!);
    setState(() {
      eoaWalletAddress = walletAddress;
    });
  }

  getVCWallet() async {
    VCWallet? wallet = await widget.vcWalletService!.getVCWallet();
    setState(() {
      vcWallet = wallet;
    });
  }

  Future<void> init() async {
    await readEoaPrivateKey();
    await initEoaWalletAddress();
    if (widget.vcWalletService != null) {
      await getVCWallet();
    }
  }

  Widget _buildMenu(BuildContext context) {
    return MenuAnchor(
      // childFocusNode: _buttonFocusNode,
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        return IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
        );
      },
      alignmentOffset: const Offset(-50, 0),
      menuChildren: [
        MenuButtonEraser(
                walletService: widget.walletService,
                vcWalletService: widget.vcWalletService)
            .build(context),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    PreferredSizeWidget appBar = AppBar(
      title: const Text('Wallet'),
      actions: [_buildMenu(context)],
    );

    if (widget.buildAppBar != null) {
      appBar = widget.buildAppBar!([_buildMenu(context)]);
    }

    return appBar;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: widget.backgroundColor,
      body: FutureBuilder(
          future: initialized,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return _buildBody(context);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  _buildBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: widget.isUnlocked
          ? SingleChildScrollView(
              child: WalletCard(
                eoaWalletAddress: eoaWalletAddress,
                eoaWalletPrivateKey: eoaWalletPrivateKey,
                did: vcWallet?.did.toString(),
                iconColor: widget.iconColor,
              ),
            )
          : const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Locked'),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
    );
  }
}
