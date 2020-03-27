class NetworkDevice {
  var _iPAddress;
  var _macAddress;

  NetworkDevice(this._iPAddress, this._macAddress);

  String getIP() {
    return this._iPAddress;
  }

  String getMAC() {
    return this._macAddress;
  }
}
