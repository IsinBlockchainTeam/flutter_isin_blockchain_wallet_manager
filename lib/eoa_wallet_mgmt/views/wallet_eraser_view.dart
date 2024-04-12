import '../../common/storage/wallet_storage_manager.dart';
import '../../common/views/wallet_eraser_view.dart';

class EoaWalletEraserView extends WalletEraserView {
  const EoaWalletEraserView({super.key, required this.walletStorageManager});

  final WalletStorageManager walletStorageManager;

  @override
  Future<void> deleteWallets() async {
    await walletStorageManager.delete();
  }
}
