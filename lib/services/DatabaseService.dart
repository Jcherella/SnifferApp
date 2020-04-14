import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'apiKey.dart';

class DatabaseService {
  final firestoreInstance = Firestore.instance.collection("MAC_Address");

  // Sets up class to be singleton
  DatabaseService._privateConstructor();
  static final DatabaseService _instance =
      DatabaseService._privateConstructor();
  factory DatabaseService() {
    return _instance;
  }

  // Queries Firebase CloudFirestore based on the provided mac address
  // Returns a string representing the vendor associated with the given address
  // Returns a 'null' if the mac address is in the DB but with no vendor
  // Throws 'NoSuchMethodError' if mac address is not in DB
  Future<String> lookupVendor(String fullMacAddress, {var instance = Null}) async {
    
    String shortMacAddr;
    try {
      // Get vendor part of address
      shortMacAddr = fullMacAddress.substring(0,8);
    } catch (e) {
      log("bad mac address for look up");
      return 'null';
    }
    
    var databaseInstance = firestoreInstance;

    // Used for testing purposes
    if (instance != Null) {
      databaseInstance = instance;
    }

    try {
      return await databaseInstance.document(shortMacAddr).get().then(
          (documentSnapshot) => documentSnapshot.data['vendor'].toString());
    } on NoSuchMethodError catch (e) {
      log("Failed to find mac address in database");
      log("Using API to find vendor...");
      String vendor = await _requestVendor(fullMacAddress);
      if (vendor != 'null') {
        databaseInstance.document(shortMacAddr).setData({'vendor': '$vendor'});
        return vendor;
      }
      log("No vendor found with API");
    } catch (e) {
      log("Failed to perform vendor lookup: " + e.toString());
    }
    return 'null';
  }

  // Provides an API to map mac addresses to known vendor names
  Future<String> _requestVendor(String macAddress) async {
    var url = 'http://api.macvendors.com/';
    //The url we want to send our requests to.
    var lookupResponse = await http.get(url + macAddress, headers: {"Authorization" : key});
    //We send the request above and wait for it to finish. Use double quotes in requests.
    var returnString = 'null';
    if(lookupResponse.statusCode==200) {
      // If the request returned successfully (i.e. status=200)
      returnString=lookupResponse.body;
      // Set the return value to the body of the response.
    }
    return returnString;
  }

  /*
    EXAMPLE USAGE OF DatabaseService
    void <function_name> async {
        ...
        final DatabaseService dbs = new DatabaseService();
        String vendor = await dbs.lookupVendor(<MAC Address>);
        if (vendor == 'null') {
          log("No vendor name");
        } else {
          log("Got vendor name: $vendor");
        }
        ...
    }
  */

}
