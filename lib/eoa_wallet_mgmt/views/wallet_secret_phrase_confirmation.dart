import 'dart:math';

import 'package:flutter/material.dart';

import '../../common/storage/wallet_storage_manager.dart';

class WalletSecretPhraseConfirmation extends StatefulWidget {
  const WalletSecretPhraseConfirmation(
      {super.key,
      required this.secretPhrase,
      required this.walletStorageManager,
      required this.onFinished,
      this.requiredConfirmationCount = 3});

  final String secretPhrase;
  final WalletStorageManager walletStorageManager;

  final Widget Function(BuildContext) onFinished;

  final int requiredConfirmationCount;

  @override
  State<WalletSecretPhraseConfirmation> createState() =>
      _WalletSecretPhraseConfirmationState();
}

class _WalletSecretPhraseConfirmationState
    extends State<WalletSecretPhraseConfirmation> {
  late final List<String> _secretPhraseWords;
  late final List<String> _shuffledSecretPhraseWords;

  final Map<int, String> ellipsesValue = {};
  final List<int> disabledEllipses = [];
  int selectedEllipseIndex = 0;

  @override
  void initState() {
    super.initState();

    _secretPhraseWords = widget.secretPhrase.split(' ');
    _shuffledSecretPhraseWords = List.from(_secretPhraseWords);
    _shuffledSecretPhraseWords.shuffle();

    _populateEllipsesValue(widget.requiredConfirmationCount);

    setState(() {
      selectedEllipseIndex = _nextAvailableIndex(-1);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _populateEllipsesValue(final int requiredConfirmationCount) {
    final populateCount = _secretPhraseWords.length - requiredConfirmationCount;
    int i = 0;
    while (i < populateCount) {
      final int randomIndex = Random().nextInt(_secretPhraseWords.length);

      if (!ellipsesValue.containsKey(randomIndex)) {
        disabledEllipses.add(randomIndex);
        ellipsesValue[randomIndex] = _secretPhraseWords[randomIndex];
        i++;
      }
    }
  }

  bool _isDisabled(int index) {
    return disabledEllipses.contains(index);
  }

  int _nextAvailableIndex(int currentIndex) {
    int i = currentIndex + 1;
    while (ellipsesValue.containsKey(i) && i != currentIndex) {
      i = (i + 1) % _secretPhraseWords.length;
    }

    if (i == currentIndex) {
      i = -1;
    }

    return i;
  }

  bool _checkSecretPhrase() {
    bool correct = true;
    int i = 0;

    while (correct && i < _secretPhraseWords.length) {
      if (_secretPhraseWords[i] != ellipsesValue[i]) {
        correct = false;
      }
      i++;
    }

    return correct;
  }

  Future<void> _createWallet() async {
    final String privateKey =
        await widget.walletStorageManager.getPrivateKey(widget.secretPhrase);
    await widget.walletStorageManager.setPrivateKey(privateKey);
  }

  void _selectEllipse(int index) {
    setState(() {
      if (selectedEllipseIndex == index) {
        selectedEllipseIndex = -1;
      } else if (ellipsesValue.containsKey(index)) {
        ellipsesValue.remove(index);
        selectedEllipseIndex = index;
      } else {
        selectedEllipseIndex = index;
      }
    });
  }

  Widget buildEllipsesInput(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 50,
      ),
      itemCount: _secretPhraseWords.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: !_isDisabled(index)
              ? () {
                  _selectEllipse(index);
                }
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${index + 1}. ', // Display index starting from 1
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3 - 10,
                // Adjust the size as needed
                height: 30.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectedEllipseIndex == index
                        ? Colors.red // Change to your desired selected color
                        : Colors.lightBlueAccent,
                    width: 1,
                  ),
                  color: _isDisabled(index) ? Colors.grey[300] : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    ellipsesValue[index] ?? '',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildEllipsesValues(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 35,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemCount: _shuffledSecretPhraseWords.length,
      itemBuilder: (context, index) {
        return OutlinedButton(
          onPressed:
              ellipsesValue.containsValue(_shuffledSecretPhraseWords[index])
                  ? null
                  : () {
                      if (selectedEllipseIndex != -1) {
                        setState(() {
                          ellipsesValue[selectedEllipseIndex] =
                              _shuffledSecretPhraseWords[index];
                          selectedEllipseIndex =
                              _nextAvailableIndex(selectedEllipseIndex);
                        });
                      }
                    },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(_shuffledSecretPhraseWords[index]),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Confirm Secret Recovery Phrase',
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
                'Select each word in the order it was presented to you.',
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
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: buildEllipsesInput(context),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 160,
                child: buildEllipsesValues(context),
              ),
              const SizedBox(
                height: 10,
              ),
              FilledButton(
                onPressed: () {
                  if (_checkSecretPhrase()) {
                    _createWallet().then(
                      (value) => {
                        Navigator.of(context).popUntil((route) => false),
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: widget.onFinished,
                          ),
                        ),
                      },
                    );
                    // widget.onFinished();
                    // Navigator.of(context).pushAndRemoveUntil(
                    //     MaterialPageRoute(builder: (ctx) => const WalletMain()),
                    //     (route) => false);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Secret Phrase is not correct'),
                      ),
                    );
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                ),
                child: const Text(
                  'Confirm backup',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
