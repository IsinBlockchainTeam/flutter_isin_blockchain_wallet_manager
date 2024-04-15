import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:polygonid_flutter_sdk/credential/domain/entities/claim_entity.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/common/iden3_message_entity.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/credential/request/base.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/exceptions/iden3comm_exceptions.dart';
import 'package:polygonid_flutter_sdk/identity/domain/entities/identity_entity.dart';
import 'package:polygonid_flutter_sdk/identity/domain/entities/private_identity_entity.dart';
import 'package:polygonid_flutter_sdk/sdk/polygon_id_sdk.dart';

import '../../common/storage/secure_storage.dart';
import '../../common/storage/wallet_storage_manager.dart';
import '../../exceptions/vc_authentication_exception.dart';
import '../../utils/qrcode_parser_utils.dart';
import '../../utils/secure_storage_keys.dart';
import '../../vc_wallet_mgmt/utils/wallet_address_utils.dart';
import '../model/vc_credential.dart';
import '../model/vc_type.dart';
import '../model/vc_wallet.dart';

class VCWalletService extends WalletStorageManager {
  PolygonIdSdk sdk;

  VCWalletService(this.sdk);

  Future<VCWallet> retrieveIdentity(String privateKey) async {
    String did = await sdk.identity.getDidIdentifier(
        privateKey: privateKey, blockchain: 'polygon', network: 'mumbai');
    return VCWallet(privateKey, did);
  }

  getVCWallet() async {
    final String? vcPrivateKey = await readPrivateKey();
    return await retrieveIdentity(vcPrivateKey!);
  }

  Future<VCWallet> createIdentity(String secret) async {
    String? formattedSecret =
        WalletAddressUtils.getFormattedSecretString(secret: secret);
    PrivateIdentityEntity privateIdentityEntity =
        await sdk.identity.addIdentity(secret: formattedSecret);
    return VCWallet(
        privateIdentityEntity.privateKey, privateIdentityEntity.did);
  }

  Future<void> authenticate(
      Iden3MessageEntity iden3AuthMessageEntity, VCWallet wallet) async {
    try {
      Map readInfo = await sdk.iden3comm.getDidProfileInfo(
          did: wallet.did,
          privateKey: wallet.privateKey,
          interactedWithDid: iden3AuthMessageEntity.from);

      var nonce = readInfo["profileNonce"] != null
          ? BigInt.parse(readInfo["profileNonce"])
          : null;

      await sdk.iden3comm.authenticate(
          message: iden3AuthMessageEntity,
          genesisDid: wallet.did,
          privateKey: wallet.privateKey,
          profileNonce: nonce);
    } on ProofsNotFoundException catch (e) {
      debugPrint("PROOOFS NOT FOUND: ${e.toString()}");
      throw VcAuthenticationException(e.toString());
    }
  }

  Future<List<ClaimEntity>> getClaimsFromIssuer(
      CredentialOfferMessageEntity claimOfferMessage, VCWallet wallet) async {
    return sdk.iden3comm.fetchAndSaveClaims(
        message: claimOfferMessage,
        genesisDid: wallet.did,
        privateKey: wallet.privateKey);
  }

  Future<List<ClaimEntity>> getClaims(VCWallet wallet) async {
    return sdk.credential
        .getClaims(genesisDid: wallet.did, privateKey: wallet.privateKey);
  }

  Future<List<ClaimEntity>> updateClaims(VCWallet wallet) async {
    List<ClaimEntity> claims = await getClaims(wallet);
    debugPrint("*** got wallet claims");
    List<ClaimEntity> updatedClaims = [];
    for (ClaimEntity claim in claims) {
      ClaimEntity updClaim = await sdk.credential.updateClaim(
          claimId: claim.id,
          genesisDid: wallet.did,
          privateKey: wallet.privateKey);
      debugPrint("*** updated claim ${updClaim}");
      updatedClaims.add(updClaim);
    }
    return sdk.credential.saveClaims(
        claims: updatedClaims,
        genesisDid: wallet.did,
        privateKey: wallet.privateKey);
  }

  Future<void> removeClaim(ClaimEntity claim, VCWallet wallet) async {
    return sdk.credential.removeClaim(
        claimId: claim.id,
        genesisDid: wallet.did,
        privateKey: wallet.privateKey);
  }

  Future<List<T>> getClaimsByType<T extends VCCredential>(VCWallet wallet,
      VCType type, T Function(ClaimEntity claim) fromClaimEntity) async {
    List<T> result = [];
    List<ClaimEntity> claims = await updateClaims(wallet);
    for (ClaimEntity claim in claims) {
      // await removeClaim(claim, wallet);

      debugPrint("**************** claim found ************");
      // debugPrint(claim.toString());
      debugPrint(claim.type);
      if (claim.type != type.name) {
        continue;
      }

      var revocationStatus = await sdk.credential.getClaimRevocationStatus(
          claimId: claim.id,
          genesisDid: wallet.did,
          privateKey: wallet.privateKey);
      if (revocationStatus["mtp"]["existence"]) {
        claim = await sdk.credential.updateClaim(
            claimId: claim.id,
            genesisDid: wallet.did,
            privateKey: wallet.privateKey,
            state: ClaimState.revoked);
      }
      debugPrint("REVOKED??? ${claim.state.name}");
      debugPrint("*************REVOCATION STATUS: $revocationStatus");

      result.add(fromClaimEntity(claim));
      debugPrint("--------- INFOS ------ ${claim.info.toString()}");
    }
    debugPrint(result.toString());
    return result;
  }

  //TODO return a result object
  Future<String> performOperation(
      Iden3MessageEntity iden3messageEntity, VCWallet wallet) async {
    debugPrint(iden3messageEntity.type);
    try {
      switch (iden3messageEntity.messageType) {
        case Iden3MessageType.authRequest:
          await authenticate(iden3messageEntity, wallet);
          break;
        case Iden3MessageType.credentialOffer:
          await getClaimsFromIssuer(
              iden3messageEntity as CredentialOfferMessageEntity, wallet);
          break;
        default:
          debugPrint("not managed now");
          break;
      }
    } catch (e) {
      rethrow;
    }
    return Future.value("SUCCESS");
  }

  Future<bool> checkIdentityExists() async {
    List<IdentityEntity> list = await sdk.identity.getIdentities();
    debugPrint("Identities length: ${list.length}");
    return list.isNotEmpty;
  }

  @override
  Future<String?> readPrivateKey() {
    return SecureStorageService.read(SecureStorageKeys.vcPrivateKey);
  }

  @override
  Future<void> setPrivateKey(String privateKey) {
    return SecureStorageService.write(
        SecureStorageKeys.vcPrivateKey, privateKey);
  }

  @override
  Future<void> delete() async {
    final String? vcPrivateKey = await readPrivateKey();
    final VCWallet vcWallet = await retrieveIdentity(vcPrivateKey!);

    try {
      await sdk.identity.removeIdentity(
          genesisDid: vcWallet.did, privateKey: vcWallet.privateKey);
    } finally {
      await SecureStorageService.delete(SecureStorageKeys.vcPrivateKey);
    }
  }

  @override
  Future<String?> readPassCodePin() {
    return SecureStorageService.read(SecureStorageKeys.passCodePin);
  }

  @override
  Future<void> setPassCodePin(String passCodePin) {
    return SecureStorageService.write(
        SecureStorageKeys.passCodePin, passCodePin);
  }

  @override
  Future<String> getPrivateKey(String seed) {
    var secret = WalletAddressUtils.getFormattedSecretString(secret: seed);
    return sdk.identity.getPrivateKey(secret: secret);
  }

  // TODO: In the future verify why we have multiple private keys
  @override
  Future<String> getPublicKey(String privateKey) async {
    String did = (await retrieveIdentity(privateKey)).did;

    return (await sdk.identity
            .getIdentity(genesisDid: did, privateKey: privateKey))
        .publicKey[0];
  }

  static Map<String, String> getApiHeaders() {
    String username = 'test';
    String password = 'test';
    var auth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    var headers = <String, String>{"authorization": auth};
    return headers;
  }

  Future<Iden3MessageEntity> getVerificationRequestFromApi(Uri url) async {
    Response response = await get(url, headers: getApiHeaders());
    debugPrint(response.statusCode.toString());
    debugPrint(response.body);
    Map<String, dynamic> requestJson = (jsonDecode(response.body))["request"];
    return QrcodeParserUtils(sdk)
        .getIden3MessageFromQrCode(jsonEncode(requestJson));
  }
}
