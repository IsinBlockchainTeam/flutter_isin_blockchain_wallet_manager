import 'package:polygonid_flutter_sdk/sdk/polygon_id_sdk.dart';
import 'package:flutter_isin_blockchain_wallet_manager/vc_wallet_mgmt/views/vc_wallet_eraser_view.dart';

import '../../common/views/wallet_manager.dart';
import '../../eoa_wallet_mgmt/services/wallet_service.dart';
import '../components/vc_wallet_setup.dart';
import '../services/vc_wallet_service.dart';

final VCWalletService vcWalletService = VCWalletService(PolygonIdSdk.I);
final WalletService walletService = WalletService();

class VCWalletMain extends WalletManager {
  VCWalletMain({
    super.key,
    required super.targetView,
    super.requiresPinScreen,
  }) : super(
          eraser: VCWalletEraserView(
            walletService: walletService,
            vcWalletService: vcWalletService,
          ),
          setup: VCWalletSetup(
            walletService: walletService,
            vcWalletService: vcWalletService,
            onFinished: (ctx) => VCWalletMain(
              targetView: targetView,
              requiresPinScreen: requiresPinScreen,
            ),
          ),
          walletStorageManager: vcWalletService,
        );
}
