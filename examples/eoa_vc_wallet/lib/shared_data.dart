import 'package:polygonid_flutter_sdk/proof/data/dtos/circuits_to_download_param.dart';
import 'package:polygonid_flutter_sdk/proof/domain/entities/download_info_entity.dart';
import 'package:flutter_isin_blockchain_wallet_manager/vc_wallet_mgmt/model/vc_wallet.dart';

class SharedData {
  static final SharedData _instance = SharedData._privateConstructor();

  String? eoaWalletPrivateKey;
  VCWallet? vcWallet;

  Stream<DownloadInfo>? circuitDownloadStream;
  List<CircuitsToDownloadParam>? circuitsToDownload;

  SharedData._privateConstructor();

  factory SharedData() {
    return _instance;
  }
}

final sharedData = SharedData();
