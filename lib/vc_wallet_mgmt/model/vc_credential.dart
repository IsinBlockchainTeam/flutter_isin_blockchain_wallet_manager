import 'package:polygonid_flutter_sdk/credential/domain/entities/claim_entity.dart';
import 'package:flutter_isin_blockchain_wallet_manager/vc_wallet_mgmt/model/vc_type.dart';

abstract class VCCredential {
  late final ClaimEntity claimEntity;
  late final VCType type;

  VCCredential(this.claimEntity, this.type);

  bool isRevoked() {
    return claimEntity.state == ClaimState.revoked;
  }

  bool isExpired() {
    // debugPrint("Expiration check");
    // debugPrint("Expiration date: ${claimEntity.expiration}");
    // debugPrint("Now: ${DateTime.now().toUtc()}");
    // debugPrint(
    //     "Expired ?: ${DateTime.now().toUtc().isAfter(DateTime.parse(claimEntity.expiration!))}");

    if (claimEntity.expiration == null) {
      return false;
    }

    return DateTime.now()
        .toUtc()
        .isAfter(DateTime.parse(claimEntity.expiration!));
  }

  static DateTime getDateFromString(String date) {
    return DateTime.parse(date).toLocal();
  }

  String padNUmber(num) {
    return "$num".padLeft(2, "0");
  }

  String dateFormatter(date) {
    return "${padNUmber(date.day)}.${padNUmber(date.month)}.${date.year}";
  }
}
