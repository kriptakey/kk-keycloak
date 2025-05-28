class Config {
  Config._internal();

  static final Config _instance = Config._internal();

  String? _address;
  String? _realmName;

  factory Config() {
    return _instance;
  }

  void setAddress(String address) {
    _address = address;
  }

  void setRealmName(String realmName) {
    _realmName = realmName;
  }

  String? getAddress() {
    if (_address != null) {
      return _address;
    }
    return null;
  }

  String? getRealmName() {
    if (_realmName != null) {
      return _realmName;
    }
    return null;
  }
}
