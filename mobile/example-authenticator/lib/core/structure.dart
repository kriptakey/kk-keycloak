class RequestEncryptedSecretObject {
  String e2eeSessionId;
  String sessionKeyAlgo;
  String macAlgo;
  String ciphertext;
  String metadata;

  RequestEncryptedSecretObject(this.e2eeSessionId, this.sessionKeyAlgo,
      this.macAlgo, this.ciphertext, this.metadata);
  Map<String, dynamic> toJson() {
    return {
      'e2eeSessionId': e2eeSessionId,
      'sessionKeyAlgo': sessionKeyAlgo,
      'macAlgo': macAlgo,
      'ciphertext': ciphertext,
      'metadata': metadata,
    };
  }
}

class RequestSignedSecretObject {
  String sessionId;
  String nonce;
  String signature;

  RequestSignedSecretObject(this.sessionId, this.nonce, this.signature);
  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'nonce': nonce,
      'signature': signature,
    };
  }
}
