import 'package:flutter/material.dart';

import '../component/wallet_eraser_button.dart';

abstract class WalletEraserView extends StatelessWidget {
  const WalletEraserView({super.key});

  Future<void> deleteWallets();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: const EdgeInsets.all(40),
        child: Center(
            child: WalletEraserButton(
          deleteWallets: deleteWallets,
        )),
      ),
    );
  }
}
