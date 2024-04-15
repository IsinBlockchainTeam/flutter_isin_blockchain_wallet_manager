import 'package:flutter_isin_blockchain_wallet_manager/common/views/wallet_eraser_view.dart';

import '../../eoa_wallet_mgmt/services/wallet_service.dart';
import '../services/vc_wallet_service.dart';

class VCWalletEraserView extends WalletEraserView {
  const VCWalletEraserView({
    super.key,
    required this.walletService,
    required this.vcWalletService,
  });

  final WalletService walletService;
  final VCWalletService vcWalletService;

  @override
  Future<void> deleteWallets() async {
    await walletService.delete();
    await vcWalletService.delete();
  }
}
