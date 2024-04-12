import 'package:polygonid_flutter_sdk/credential/domain/entities/claim_entity.dart';

import 'vc_credential.dart';
import 'vc_type.dart';

class VCIdentity extends VCCredential {
  String identityNumber;
  String name;
  String surname;
  String gender;
  DateTime birthDate;
  String nationality;
  String image;

  VCIdentity(this.identityNumber, this.name, this.surname, this.gender,
      this.birthDate, this.nationality, this.image, ClaimEntity claimEntity)
      : super(claimEntity, VCType.document);

  static VCIdentity fromClaimEntity(ClaimEntity claimEntity) {
    return VCIdentity(
        claimEntity.info["credentialSubject"]["identityNumber"],
        claimEntity.info["credentialSubject"]["name"],
        claimEntity.info["credentialSubject"]["surname"],
        claimEntity.info["credentialSubject"]["gender"],
        VCCredential.getDateFromString(
            claimEntity.info["credentialSubject"]["birthDate"]),
        claimEntity.info["credentialSubject"]["nationality"],
        claimEntity.info["credentialSubject"]["image"],
        claimEntity);
  }
}
