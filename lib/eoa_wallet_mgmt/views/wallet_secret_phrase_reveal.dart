import 'package:flutter/material.dart';

import '../../common/storage/wallet_storage_manager.dart';
import '../components/wallet_secret_phrase.dart';

class WalletSecretPhraseReveal extends StatefulWidget {
  const WalletSecretPhraseReveal(
      {super.key,
      required this.walletStorageManager,
      required this.onContinue});

  final WalletStorageManager walletStorageManager;
  final Widget Function(BuildContext, String) onContinue;

  @override
  State<WalletSecretPhraseReveal> createState() =>
      _WalletSecretPhraseRevealState();
}

class _WalletSecretPhraseRevealState extends State<WalletSecretPhraseReveal> {
  bool _isSecretPhraseVisible = false;
  late final String _secretPhrase;

  @override
  void initState() {
    super.initState();

    _secretPhrase = widget.walletStorageManager.generateMnemonic();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildSecretInvisible(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Icon(
          Icons.visibility_off_outlined,
          color: Colors.white,
        ),
        const Column(
          children: [
            Text(
              'Tap to reveal your Secret Recovery Phrase',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Make sure no one is watching your screen',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
        OutlinedButton(
          onPressed: () {
            setState(() {
              _isSecretPhraseVisible = !_isSecretPhraseVisible;
            });
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: const Text(
            'View',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Write down your Secret Recovery Phrase',
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
              'This is your Secret Recovery Phrase. Write it down on a paper and keep it in a safe place. You\'ll be asked to re-enter it this phrase (in order) on the next step.',
              style: TextStyle(
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: _isSecretPhraseVisible ? Colors.white : Colors.black,
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _isSecretPhraseVisible
                  ? WalletSecretPhrase(secretPhrase: _secretPhrase)
                  : buildSecretInvisible(context),
            ),
            const SizedBox(
              height: 70,
            ),
            FilledButton(
              onPressed: _isSecretPhraseVisible
                  ? () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (ctx) =>
                                widget.onContinue(ctx, _secretPhrase)
                            // WalletSecretPhraseConfirmation(
                            //   secretPhrase: _secretPhrase,
                            //   walletStorageManager: widget.walletStorageManager,
                            // ),
                            ),
                      );
                    }
                  : null,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.blue[600],
              ),
              child: const Text(
                'Continue',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
