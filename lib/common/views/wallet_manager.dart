import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

import '../model/wallet_store.dart';
import '../storage/wallet_storage_manager.dart';

class WalletManager extends StatefulWidget {
  final Widget targetView;
  final bool requiresPinScreen;
  final Widget? eraser;
  final Widget setup;
  final WalletStorageManager walletStorageManager;

  const WalletManager(
      {super.key,
      required this.targetView,
      this.requiresPinScreen = true,
      this.eraser,
      required this.setup,
      required this.walletStorageManager});

  @override
  State<WalletManager> createState() => _WalletManagerState();
}

class _WalletManagerState extends State<WalletManager> {
  late final Future<WalletStore> loadWalletFuture;

  @override
  void initState() {
    // loadWalletFuture = _loadWallet();
    loadWalletFuture = _loadWalletProtected();

    super.initState();
  }

  Future<String?> _loadPrivateKey() async {
    return widget.walletStorageManager.readPrivateKey();
  }

  Future<String?> _loadPin() async {
    return widget.walletStorageManager.readPassCodePin();
  }

  Future<WalletStore> _loadWallet() async {
    // await widget.walletStorageManager.delete();

    String? privateKey = await _loadPrivateKey();

    debugPrint('Retrieved private key: $privateKey');

    if (privateKey == null) {
      return WalletStore(null, null);
    }

    String? pin = await _loadPin();

    debugPrint('Retrieved passcodePin: $pin');

    // TODO verify pin existence
    return WalletStore(privateKey, pin);
  }

  Future<WalletStore> _loadWalletProtected() async {
    final WalletStore walletStore = await _loadWallet();

    if (walletStore.privateKey != null &&
        walletStore.pin != null &&
        widget.requiresPinScreen) {
      openScreenLock(walletStore.pin!);
    }

    return walletStore;
  }

  void openScreenLock(String pin) {
    screenLock(
      context: context,
      correctString: pin,
      onUnlocked: () => {
        Navigator.of(context).pop(),
      },
      onCancelled: widget.eraser == null
          ? null
          : () => {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => Scaffold(
                      body: widget.eraser!,
                    ),
                  ),
                ),
              },
      canCancel: widget.eraser == null ? false : true,
      keyPadConfig: const KeyPadConfig(
        clearOnLongPressed: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadWalletFuture,
      builder: (BuildContext context, AsyncSnapshot<WalletStore> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        WalletStore? walletStore = snapshot.data;

        if (walletStore != null && walletStore.privateKey != null) {
          return widget.targetView;
        } else {
          return Scaffold(
            appBar: AppBar(),
            body: widget.setup,
          );
        }
      },
    );
  }
}
