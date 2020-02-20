class NetworkDevice {
  var iPAddress;
  var macAddress;

  NetworkDevice(this.iPAddress, this.macAddress);

  String getIP() {
    return this.iPAddress;
  }

  String getMAC() {
    return this.macAddress;
  }
}
