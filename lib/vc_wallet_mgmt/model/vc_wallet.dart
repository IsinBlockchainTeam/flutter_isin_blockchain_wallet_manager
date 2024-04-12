class VCWallet {
  String privateKey;
  String did;

  VCWallet(this.privateKey, this.did);

  @override
  String toString() {
    return "priv: $privateKey, did: $did";
  }
}
