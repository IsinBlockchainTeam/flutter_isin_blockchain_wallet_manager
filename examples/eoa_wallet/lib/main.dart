import 'package:eoa_wallet/views/home_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_isin_ui_kit/utils/restart_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_isin_blockchain_wallet_manager/eoa_wallet_mgmt/views/eoa_wallet_main.dart';
import 'package:flutter_isin_blockchain_wallet_manager/utils/secure_storage_keys.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// https://stackoverflow.com/questions/57933021/flutter-how-do-i-delete-fluttersecurestorage-items-during-install-uninstall
final keysToEliminate = [
  SecureStorageKeys.passCodePin,
  SecureStorageKeys.eoaPrivateKey,
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
  // Necessary for flutter shared preferences to work otherwise it will throw an error
  // https://stackoverflow.com/questions/75470485/flutter-unit-testing-binding-has-not-yet-been-initialized
  WidgetsFlutterBinding.ensureInitialized();

  // delete all keys from secure storage if first run!
  await clearSecureStorageFirstRun();

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
        targetView: const HomePageView(),
      ),
    );
  }
}
