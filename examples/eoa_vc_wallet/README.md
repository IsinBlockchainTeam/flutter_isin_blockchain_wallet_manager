# EOA + VC Wallet Example

## Description

Example project that demonstrates how to use the EOA and VC Wallet SDKs in a Flutter application.

## Getting Started

### Installing

Download the dependencies by running the following command in the example project root directory:

```bash
flutter pub get
```

### Configuration

1. Copy the `.env.example` to `.env`.
   ```bash
    cp .env.example .env
    ```
2. Fill in the `.env` file with the required values.

If you are running the app on an Android device, you need to specify the `minSdkVersion` in
the `android/local.properties` file.

```properties
minSdkVersion=21
```

### Executing program

Run the following command in the example project root directory to start the application:

```bash
flutter run
```

## Notes

Actually the ios build gives problem on the ios simulator, related to
the [Polygon Flutter SDK](https://github.com/0xPolygonID/polygonid-flutter-sdk) so it is recommended to run the
application on a physical device.

## Authors

Contributors names and contact info

* [Giuliano Gremlich](https://www.linkedin.com/in/giuliano-gremlich-265018153/) - giuliano.gremlich@supsi.ch
* [Roberto Guidi](https://www.linkedin.com/in/rguidi/) - roberto.guidi@supsi.ch
* [Lorenzo Ronzani](https://www.linkedin.com/in/lorenzo-ronzani-658311186/) - lorenzo.ronzani@supsi.ch

## License

Distributed under the MIT License.
See [LICENSE](https://github.com/IsinBlockchainTeam/flutter_isin_blockchain_wallet_manager/blob/main/LICENSE) for more
information.

## Acknowledgments

Inspiration, code snippets, etc.

* [awesome-readme](https://github.com/matiassingers/awesome-readme)
* [PurpleBooth](https://gist.github.com/PurpleBooth/109311bb0361f32d87a2)
* [dbader](https://github.com/dbader/readme-template)
* [zenorocha](https://gist.github.com/zenorocha/4526327)
* [fvcproductions](https://gist.github.com/fvcproductions/1bfc2d4aecb01a834b46)
