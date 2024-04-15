import 'package:polygonid_flutter_sdk/credential/domain/entities/claim_entity.dart';

import 'vc_credential.dart';
import 'vc_type.dart';

class VCTicket extends VCCredential {
  String departureLocation;
  String arrivalLocation;
  DateTime departureDate;
  DateTime arrivalDate;
  String flightNumber;
  String airline;
  String seat;
  String ticketClass;
  int nftId;
  String nftContractAddress;

  VCTicket(
      this.departureLocation,
      this.arrivalLocation,
      this.departureDate,
      this.arrivalDate,
      this.flightNumber,
      this.airline,
      this.seat,
      this.ticketClass,
      this.nftId,
      this.nftContractAddress,
      ClaimEntity claimEntity)
      : super(claimEntity, VCType.ticket);

  static VCTicket fromClaimEntity(ClaimEntity claimEntity) {
    return VCTicket(
        claimEntity.info["credentialSubject"]["departureLocation"],
        claimEntity.info["credentialSubject"]["arrivalLocation"],
        VCCredential.getDateFromString(
            claimEntity.info["credentialSubject"]["departureDate"]),
        VCCredential.getDateFromString(
            claimEntity.info["credentialSubject"]["arrivalDate"]),
        claimEntity.info["credentialSubject"]["flightNumber"],
        claimEntity.info["credentialSubject"]["airline"],
        claimEntity.info["credentialSubject"]["seat"],
        claimEntity.info["credentialSubject"]["ticketClass"],
        claimEntity.info["credentialSubject"]["NFTId"],
        claimEntity.info["credentialSubject"]["NFTContractAddress"],
        claimEntity);
  }

  String departureDateFormatted() {
    return dateFormatter(departureDate);
  }

  String departureTimeFormatted() {
    return _timeFormatter(departureDate);
  }

  String _timeFormatter(date) {
    return "${padNUmber(date.hour)}:${padNUmber(date.minute)}";
  }

  @override
  String toString() {
    return "dep: $departureDate | $departureLocation - $arrivalLocation | flight: $flightNumber | seat: $seat";
  }
}
