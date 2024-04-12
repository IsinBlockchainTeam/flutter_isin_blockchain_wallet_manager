import 'package:flutter/material.dart';

import './wallet_eraser_button.dart';
import '../storage/wallet_storage_manager.dart';

class MenuButtonEraser extends WalletEraserButton {
  final WalletStorageManager walletService;
  final WalletStorageManager? vcWalletService;

  MenuButtonEraser(
      {super.key, required this.walletService, this.vcWalletService})
      : super(deleteWallets: () async {
          debugPrint(
            "erasing",
          );
          await walletService.delete();

          if (vcWalletService != null) {
            await vcWalletService.delete();
          }
        });

  @override
  Widget build(BuildContext context) {
    return MenuItemButton(
        leadingIcon: const Icon(Icons.delete),
        child: const Text("Erase"),
        onPressed: () {
          showConfirmDialog(context);
        });
  }
}
