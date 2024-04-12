import 'package:eoa_vc_wallet_example_app/shared_data.dart';
import 'package:eoa_vc_wallet_example_app/views/home_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_isin_ui_kit/utils/restart_widget.dart';
import 'package:polygonid_flutter_sdk/common/domain/entities/env_entity.dart';
import 'package:polygonid_flutter_sdk/proof/data/dtos/circuits_to_download_param.dart';
import 'package:polygonid_flutter_sdk/sdk/polygon_id_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_management/eoa_wallet_mgmt/views/eoa_wallet_main.dart';
import 'package:wallet_management/utils/secure_storage_keys.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wallet_management/vc_wallet_mgmt/views/vc_wallet_main.dart';

// https://stackoverflow.com/questions/57933021/flutter-how-do-i-delete-fluttersecurestorage-items-during-install-uninstall
final keysToEliminate = [
  SecureStorageKeys.passCodePin,
  SecureStorageKeys.eoaPrivateKey,
  SecureStorageKeys.vcPrivateKey,
];

Future<void> clearSecureStorageFirstRun() async {
  final prefs = await SharedPreferences.getInstance();

  if (prefs.getBool('first_run') ?? true) {
    FlutterSecureStorage storage = const FlutterSecureStorage();

    await Future.wait(keysToEliminate.map((key) => storage.delete(key: key)));

    prefs.setBool('first_run', false);
  }
}

Future main() async {
  await dotenv.load(fileName: '.env');

  await PolygonIdSdk.init(
      env: EnvEntity(
          blockchain: dotenv.env['POLYGON_ID_BLOCKCHAIN']!,
          network: dotenv.env['POLYGON_ID_NETWORK']!,
          web3Url: dotenv.env['POLYGON_ID_WEB3_URL']!,
          web3RdpUrl: dotenv.env['POLYGON_ID_WEB3_RDP_URL']!,
          web3ApiKey: dotenv.env['POLYGON_ID_WEB3_API_KEY']!,
          idStateContract: dotenv.env['POLYGON_ID_STATE_CONTRACT']!,
          pushUrl: dotenv.env['POLYGON_ID_PUSH_URL']!,
          ipfsUrl: dotenv.env['POLYGON_ID_IPFS_URL']!));

  // PolygonIdSdk.I.switchLog(enabled: true);

  // delete all keys from secure storage if first run!
  await clearSecureStorageFirstRun();

  List<CircuitsToDownloadParam> circuitsToDownload = [
    CircuitsToDownloadParam(
      circuitsName: "circuitsV2",
      bucketUrl:
          "https://circuits.polygonid.me/circuits/v1.0.0/polygonid-keys.zip",
    ),
    CircuitsToDownloadParam(
      circuitsName: "circuitsV3",
      bucketUrl:
          "https://iden3-circuits-bucket.s3.eu-west-1.amazonaws.com/circuitsv3-beta-0.zip",
    ),
  ];
  sharedData.circuitsToDownload = circuitsToDownload;
  sharedData.circuitDownloadStream = PolygonIdSdk.I.proof
      .initCircuitsDownloadAndGetInfoStream(
          circuitsToDownload: circuitsToDownload);

  runApp(const RestartWidget(child: ExampleApp()));
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: EoaWalletMain(
        targetView: VCWalletMain(
          targetView: const HomePageView(),
          requiresPinScreen: false,
        ),
      ),
    );
  }
}
