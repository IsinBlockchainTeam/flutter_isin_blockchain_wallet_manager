import 'package:flutter/material.dart';

class WalletSecretPhrase extends StatelessWidget {
  const WalletSecretPhrase({super.key, required this.secretPhrase});

  final String secretPhrase;

  @override
  Widget build(BuildContext context) {
    final List<String> secretPhraseWords = secretPhrase.split(' ');

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 50,
      ),
      itemCount: secretPhraseWords.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blue,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              "${index + 1}. ${secretPhraseWords[index]}",
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}
