import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

import '../../common/storage/wallet_storage_manager.dart';

class WalletSetup extends StatefulWidget {
  WalletSetup(
      {super.key,
      required this.walletStorageManager,
      required this.onCreateWallet,
      required this.onImportWallet});

  final Widget Function(BuildContext) onCreateWallet;
  final Widget Function(BuildContext) onImportWallet;
  final WalletStorageManager walletStorageManager;

  @override
  State<WalletSetup> createState() => _WalletSetupState();
}

class _WalletSetupState extends State<WalletSetup> {
  InputController _pinController = InputController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Wallet Setup',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Import an existing wallet or create a new one.',
            style: TextStyle(
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: widget.onImportWallet),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue[900],
                ),
                child: const Text(
                  'Import using Secret Recovery Phrase',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FilledButton(
                onPressed: () => screenLockCreate(
                  digits: 6,
                  context: context,
                  inputController: _pinController,
                  onConfirmed: (value) => {
                    widget.walletStorageManager.setPassCodePin(value),
                    Navigator.of(context).pop(),
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(builder: widget.onCreateWallet),
                        )
                        .then((value) => {
                              setState(() {
                                _pinController = InputController();
                              })
                            }),
                  },
                  onCancelled: () => {
                    debugPrint('Cancelled'),
                    _pinController.unsetConfirmed(),
                    Navigator.of(context).pop(),
                  },
                  keyPadConfig: const KeyPadConfig(
                    clearOnLongPressed: true,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                ),
                child: const Text(
                  'Create a new wallet',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
