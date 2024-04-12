import 'package:wallet_management/common/views/wallet_manager.dart';
import 'package:wallet_management/eoa_wallet_mgmt/components/wallet_setup.dart';
import 'package:wallet_management/eoa_wallet_mgmt/services/wallet_service.dart';
import 'package:wallet_management/eoa_wallet_mgmt/views/wallet_eraser_view.dart';

import 'wallet_import.dart';
import 'wallet_secret_phrase_confirmation.dart';
import 'wallet_secret_phrase_reveal.dart';

final WalletService walletStorageManager = WalletService();

class EoaWalletMain extends WalletManager {
  EoaWalletMain({
    super.key,
    required super.targetView,
    super.requiresPinScreen,
  }) : super(
          eraser: EoaWalletEraserView(
            // walletStorageManager: WalletService(),
            walletStorageManager: walletStorageManager,
          ),
          setup: WalletSetup(
            onCreateWallet: (ctx) => WalletSecretPhraseReveal(
              onContinue: (ctx, secretPhrase) => WalletSecretPhraseConfirmation(
                secretPhrase: secretPhrase,
                // walletStorageManager: WalletService(),
                walletStorageManager: walletStorageManager,
                onFinished: (ctx) => EoaWalletMain(
                  targetView: targetView,
                  requiresPinScreen: requiresPinScreen,
                ),
              ),
              // walletStorageManager: WalletService(),
              walletStorageManager: walletStorageManager,
            ),
            // walletStorageManager: WalletService(),
            walletStorageManager: walletStorageManager,
            onImportWallet: (ctx) => WalletImport(
              walletStorageManager: walletStorageManager,
              onFinished: (ctx) => EoaWalletMain(
                targetView: targetView,
                requiresPinScreen: requiresPinScreen,
              ),
            ),
          ),
          // walletStorageManager: WalletService(),
          walletStorageManager: walletStorageManager,
        );
}
