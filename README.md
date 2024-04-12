<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a name="readme-top"></a>
<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Don't forget to give the project a star!
*** Thanks again! Now go create something AMAZING! :D
-->



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]



<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/IsinBlockchainTeam/flutter-isin-blockchain-wallet-manager">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a>

<h3 align="center">flutter-isin-blockchain-wallet-manager</h3>

  <p align="center">
    A comprehensive Flutter library for seamlessly managing blockchain wallets, supporting both EOA (External Owned Account) and Polygon VC (Verifiable Credential), tailored for robust security and user-friendly interfaces.
    <br />
    <a href="https://github.com/IsinBlockchainTeam/flutter-isin-blockchain-wallet-manager"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/IsinBlockchainTeam/flutter-isin-blockchain-wallet-manager">View Demo</a>
    ·
    <a href="https://github.com/IsinBlockchainTeam/flutter-isin-blockchain-wallet-manager/issues/new?labels=bug&template=bug-report---.md">Report Bug</a>
    ·
    <a href="https://github.com/IsinBlockchainTeam/flutter-isin-blockchain-wallet-manager/issues/new?labels=enhancement&template=feature-request---.md">Request Feature</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
        <li><a href="#specifications">Specifications</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->

## About The Project

The flutter-blockchain-wallet-manager is an innovative Flutter library designed to facilitate the management of
blockchain wallets, including both Externally Owned Accounts (EOA) and Verifiable Credentials (VC). This project aims to
bridge the gap between complex blockchain operations and the user-friendly mobile environment Flutter is known for.

Key Features:

* Multi-Account Management: Easily handle multiple wallet types, including EOAs and VCs, within a single integrated
  framework.
* Security First: Built with security as a core principle, ensuring that all wallet interactions are safe from
  vulnerabilities.
* Cross-Platform Compatibility: Leverages Flutter's cross-platform capabilities to deliver a consistent experience on
  both iOS and Android.
* Open Source: As an open-source project, we encourage the community to contribute, suggest improvements, and help us
  extend the library's capabilities.

Our main goal is to simplify the integration of blockchain technologies in mobile applications, making it accessible to
developers without extensive blockchain experience. We focus on providing a robust, secure, and easy-to-use platform for
managing digital identities and assets through blockchain wallets.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Built With

This library is built mainly using the following technologies:

[![Flutter][Flutter]][Flutter-url]

[![Dart][Dart]][Dart-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Specifications

The project specifications are as follows:

* EOA Wallet are based on the EVM (Ethereum Virtual Machine) and are compatible with the Ethereum network and forks. We
  decided to use 12 words for the seed phrase and the BIP-39 standard for the wallet creation.
* The private key is stored in the device's secure storage, and the wallet is encrypted with the user's PIN.
* We decided to use the [Polygon ID](https://devs.polygonid.com/) platform for the VC (Verifiable Credential)
  implementation.
* When using both EOA and VC wallets together, the EOA secret phrase allows to recover also the VC wallet.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- GETTING STARTED -->

## Getting Started

To get started with the flutter-blockchain-wallet-manager, please refer to our setup guide and installation
instructions in the documentation section. We provide step-by-step guidelines to help you integrate the library into
your Flutter projects effectively.

### Prerequisites

Before diving into the flutter-blockchain-wallet-manager, ensure you have the necessary environment and tools set up as
listed below.

* [Flutter][Flutter-installation-url]

### Installation

Follow these steps to seamlessly incorporate the flutter-blockchain-wallet-manager into your development environment.

1. Clone the repo
   ```sh
   git clone https://github.com/IsinBlockchainTeam/flutter-isin-blockchain-wallet-manager.git
   ```
2. Install PUB packages
   ```sh
   flutter pub get
   ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- USAGE EXAMPLES -->

## Usage

Getting started with the flutter-blockchain-wallet-manager is straightforward. Follow these steps to integrate the
wallet management functionality into your Flutter app.

1. Import the library
   ```dart
   import 'package:flutter_isin_blokchain_wallet_manager/<component>.dart';
   ```
2. Wrap your app with RestartWidget
   ```dart
   return const RestartWidget(
      child: MyApp(),
    );
    ```
3. Initialize the app with the wallet manager
   ```dart
   return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: EoaWalletMain(
        targetView: VCWalletMain(
          targetView: const HomePageView(),
          requiresPinScreen: false,
        ),
      ),
    );
    ```
4. Setup PolygonID
   ```dart
   final PolygonID polygonID = PolygonID(
      chainID: 137,
      chainName: 'Polygon',
      rpcUrl: 'https://rpc-mainnet.maticvigil.com',
      explorerUrl: 'https://explorer-mainnet.maticvigil.com',
      chainToken: 'MATIC',
      chainTokenSymbol: 'MATIC',
      chainTokenDecimals: 18,
      chainTokenExplorerUrl: 'https://explorer-mainnet.maticvigil.com/tokens',
    );
    ```
5. Instantiate Wallet Services
   ```dart
    final WalletService walletService = WalletService();
    final VCWalletService vcWalletService = VCWalletService(PolygonIdSdk.I);
   ```
6. Get Wallets data
   ```dart
    final String? eoaWalletPrivateKey = await walletService.readPrivateKey();
    final String? vcPrivateKey = await vcWalletService.readPrivateKey();
   ```

For more detailed information, please refer to
the [Example](https://github.com/IsinBlockchainTeam/flutter_isin_blockchain_wallet_manager/tree/main/examples) section.

If you want to have more information about the PolygondID, please refer to
the [PolygonID](https://github.com/0xPolygonID/polygonid-flutter-sdk)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ROADMAP -->

## Roadmap

See the [open issues](https://github.com/IsinBlockchainTeam/flutter-isin-blockchain-wallet-manager/issues) for a full
list of proposed
features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTRIBUTING -->

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any
contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also
simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- LICENSE -->

## License

Distributed under the MIT License. See `LICENSE` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->

## Contact

* [Giuliano Gremlich](https://www.linkedin.com/in/giuliano-gremlich-265018153/) - giuliano.gremlich@supsi.ch
* [Roberto Guidi](https://www.linkedin.com/in/rguidi/) - roberto.guidi@supsi.ch
* [Lorenzo Ronzani](https://www.linkedin.com/in/lorenzo-ronzani-658311186/) - lorenzo.ronzani@supsi.ch

Project
Link: [flutter-isin-blockchain-wallet-manager](https://github.com/IsinBlockchainTeam/flutter-isin-blockchain-wallet-manager)

Organization Link: [IsinBlockchainTeam](https://github.com/IsinBlockchainTeam)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->

## Acknowledgments

Use this space to list resources you find helpful and would like to give credit to. I've included a few of my favorites
to kick things off!

* [Choose an Open Source License](https://choosealicense.com)
* [GitHub Emoji Cheat Sheet](https://www.webpagefx.com/tools/emoji-cheat-sheet)
* [Malven's Flexbox Cheatsheet](https://flexbox.malven.co/)
* [Malven's Grid Cheatsheet](https://grid.malven.co/)
* [Img Shields](https://shields.io)
* [GitHub Pages](https://pages.github.com)
* [Font Awesome](https://fontawesome.com)
* [React Icons](https://react-icons.github.io/react-icons/search)
* [Flat Icon](https://www.flaticon.com)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

[contributors-shield]: https://img.shields.io/github/contributors/IsinBlockchainTeam/flutter-isin-blockchain-wallet-manager.svg?style=for-the-badge

[contributors-url]: https://github.com/IsinBlockchainTeam/flutter-isin-blockchain-wallet-manager/graphs/contributors

[forks-shield]: https://img.shields.io/github/forks/IsinBlockchainTeam/flutter-isin-blockchain-wallet-manager.svg?style=for-the-badge

[forks-url]: https://github.com/IsinBlockchainTeam/flutter-isin-blockchain-wallet-manager/network/members

[stars-shield]: https://img.shields.io/github/stars/IsinBlockchainTeam/flutter-isin-blockchain-wallet-manager.svg?style=for-the-badge

[stars-url]: https://github.com/IsinBlockchainTeam/flutter-isin-blockchain-wallet-manager/stargazers

[issues-shield]: https://img.shields.io/github/issues/IsinBlockchainTeam/flutter-isin-blockchain-wallet-manager.svg?style=for-the-badge

[issues-url]: https://github.com/IsinBlockchainTeam/flutter-isin-blockchain-wallet-manager/issues

[license-shield]: https://img.shields.io/github/license/IsinBlockchainTeam/flutter-isin-blockchain-wallet-manager.svg?style=for-the-badge

[license-url]: https://github.com/IsinBlockchainTeam/flutter-isin-blockchain-wallet-manager/blob/master/LICENSE.txt

[Dart]: https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white

[Dart-url]: https://dart.dev/

[Flutter]: https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white

[Flutter-url]: https://flutter.dev/

[Next.js]: https://img.shields.io/badge/next.js-000000?style=for-the-badge&logo=nextdotjs&logoColor=white

[Next-url]: https://nextjs.org/

[React.js]: https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB

[React-url]: https://reactjs.org/

[Vue.js]: https://img.shields.io/badge/Vue.js-35495E?style=for-the-badge&logo=vuedotjs&logoColor=4FC08D

[Vue-url]: https://vuejs.org/

[Angular.io]: https://img.shields.io/badge/Angular-DD0031?style=for-the-badge&logo=angular&logoColor=white

[Angular-url]: https://angular.io/

[Svelte.dev]: https://img.shields.io/badge/Svelte-4A4A55?style=for-the-badge&logo=svelte&logoColor=FF3E00

[Svelte-url]: https://svelte.dev/

[Laravel.com]: https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white

[Laravel-url]: https://laravel.com

[Bootstrap.com]: https://img.shields.io/badge/Bootstrap-563D7C?style=for-the-badge&logo=bootstrap&logoColor=white

[Bootstrap-url]: https://getbootstrap.com

[JQuery.com]: https://img.shields.io/badge/jQuery-0769AD?style=for-the-badge&logo=jquery&logoColor=white

[JQuery-url]: https://jquery.com

[Flutter-installation-url]: https://docs.flutter.dev/get-started/install
