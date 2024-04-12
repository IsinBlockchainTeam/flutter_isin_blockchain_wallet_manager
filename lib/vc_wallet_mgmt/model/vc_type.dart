enum VCType {
  ticket,
  document
}

extension VCTypeExtension on VCType {
  String get name {
    return ["MOOVTicket", "MOOVIdentity"][index];
  }
}