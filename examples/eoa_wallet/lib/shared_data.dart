class SharedData {
  static final SharedData _instance = SharedData._privateConstructor();

  String? eoaWalletPrivateKey;

  SharedData._privateConstructor();

  factory SharedData() {
    return _instance;
  }
}

final sharedData = SharedData();
