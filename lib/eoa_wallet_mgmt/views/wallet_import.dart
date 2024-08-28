import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:flutter_isin_ui_kit/components/input_field_obscurable.dart';

import '../../common/storage/secure_storage.dart';
import '../../common/storage/wallet_storage_manager.dart';
import '../../utils/secure_storage_keys.dart';

class WalletImport extends StatefulWidget {
  const WalletImport(
      {super.key,
      required this.walletStorageManager,
      required this.onFinished});

  final WalletStorageManager walletStorageManager;
  final Widget Function(BuildContext) onFinished;

  @override
  State<WalletImport> createState() => _WalletImportState();
}

class _WalletImportState extends State<WalletImport> {
  final _pinController = InputController();
  final _formKey = GlobalKey<FormState>();

  bool isSeedValid = false;
  String _secretRecoveryPhrase = "";
  String _privateKey = "";

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _importWallet(String pin) async {
    if (isSeedValid) {
      String privateKey = _privateKey;
      if (_secretRecoveryPhrase != "") {
        privateKey = await widget.walletStorageManager
            .getPrivateKey(_secretRecoveryPhrase);
      }

      await widget.walletStorageManager.setPrivateKey(privateKey);
      SecureStorageService.write(SecureStorageKeys.passCodePin, pin);
    }
  }

  bool _isValidPrivateKey(String input) {
    // Check if input starts with '0x' and is 66 characters long (64 hex digits + '0x')
    final privateKeyPattern = RegExp(r'^0x[a-fA-F0-9]{64}$');
    return privateKeyPattern.hasMatch(input.trim());
  }

  Widget checkPhraseButton(BuildContext context) {
    return FilledButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          setState(() {
            isSeedValid = true;
          });
          // If the form is valid, display a snackbar. In the real world,
          // you'd often call a server or save the information in a database.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Value inserted correctly')),
          );
        }
      },
      style: FilledButton.styleFrom(
        backgroundColor: Colors.blue[900],
      ),
      child: const Text(
        'Check',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget setPinButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () => screenLockCreate(
        digits: 6,
        context: context,
        inputController: _pinController,
        onConfirmed: (matchedText) => {
          _importWallet(matchedText).then(
            (value) => {
              Navigator.of(context).popUntil((route) => false),
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: widget.onFinished,
                ),
              ),
            },
          ),
          // Navigator.of(context).pushAndRemoveUntil(
          //     MaterialPageRoute(builder: (ctx) => const WalletMain()),
          //     (route) => false),
          Navigator.of(context).popUntil((route) => route.isFirst),
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
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.blue[900],
      ),
      child: const Text(
        'Set pin',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: const EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Import by seed phrase or private key',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              InputFieldObscurable(
                hintText: 'spaced words or 0x...',
                labelText: 'Seed phrase or private key',
                isEnabled: !isSeedValid,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your value';
                  }
                  if (_isValidPrivateKey(value)) {
                    _privateKey = value;
                    return null;
                  }
                  if (value.split(' ').length == 12) {
                    _secretRecoveryPhrase = value;
                    return null;
                  }

                  return 'Please enter a valid seed phrase or private key';
                },
              ),
              const SizedBox(
                height: 20,
              ),
              isSeedValid ? setPinButton(context) : checkPhraseButton(context),
            ],
          ),
        ),
      ),
    );
  }
}
