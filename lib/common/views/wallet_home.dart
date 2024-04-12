import 'package:flutter/material.dart';
import 'package:flutter_isin_ui_kit/components/clipboard_copyable_text.dart';
import 'package:flutter_isin_ui_kit/components/field_obscurable.dart';

import '../../eoa_wallet_mgmt/services/wallet_service.dart';
import '../../vc_wallet_mgmt/model/vc_wallet.dart';
import '../../vc_wallet_mgmt/services/vc_wallet_service.dart';
import '../component/menu_button_eraser.dart';

class WalletHome extends StatefulWidget {
  const WalletHome(
      {super.key,
      required this.isUnlocked,
      this.vcWalletService,
      required this.walletService});

  final bool isUnlocked;
  final VCWalletService? vcWalletService;
  final WalletService walletService;

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initialized,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _buildBody(context);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  _buildBody(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Center(
        child: widget.isUnlocked
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _buildWalletDetails(context),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildMenu(context),
                  const Text('Locked'),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
      ),
    );
  }

  List<Widget> _buildWalletDetails(BuildContext context) {
    List<Widget> children = [];
    children.add(_buildMenu(context));
    children.add(const SizedBox(height: 30));
    children.addAll(_buildEoaWalletDetails());
    children.addAll(_buildVcWalletDetails());
    return children;
  }

  List<Widget> _buildEoaWalletDetails() {
    return [
      Flexible(
          child: TextFormField(
        canRequestFocus: false,
        initialValue: eoaWalletAddress.toString(),
        readOnly: true,
        expands: true,
        maxLines: null,
        enabled: true,
        decoration: InputDecoration(
          labelText: "Wallet address",
          isDense: true,
          // Reduces height a bit
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          suffixIcon: Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
              child: ClipboardCopyableText(
                text: eoaWalletAddress.toString(),
                textLabel: 'EOA Wallet Address',
              )),
        ),
      )),
      const SizedBox(height: 30),
      Flexible(
          child: FieldObscurable(
        text: '${eoaWalletPrivateKey?.toString()}',
        labelText: 'Private Key',
      )),
      const SizedBox(height: 30),
    ];
  }

  List<Widget> _buildVcWalletDetails() {
    if (vcWallet == null) {
      return [];
    }

    return [
      Flexible(
          child: FieldObscurable(
              text: '${vcWallet?.did.toString()}', labelText: 'DID')),
      const SizedBox(height: 30),
    ];
  }

  Widget _buildMenu(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        MenuAnchor(
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
        ),
      ],
    );
  }
}
