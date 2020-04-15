import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class DatabaseService {
  final firestoreInstance = Firestore.instance.collection("MAC_Address");
  final vendorInstance = Firestore.instance.collection("VENDOR");

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

  // Checks to see if the given vendor sells recording equipment
  // returns 'null' on a non-risky vendor and true for a risky vendor
  Future<bool> isVendorRisky(String vendor) async {
    try {
      return await vendorInstance.document(vendor).get().then(
          (documentSnapshot) => documentSnapshot.data['vendor']);
    } on NoSuchMethodError catch (e) {
      return false;
    } catch (e) {
      log("Failed to perform vendor lookup: " + e.toString());
    }
    return false;
  }

  // Provides an API to map mac addresses to known vendor names
  Future<String> _requestVendor(String macAddress) async {
    var url = 'http://api.macvendors.com/';
    //The url we want to send our requests to.
    var key = """Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImp0aSI6IjQyZDM4ZTQ0LTEwNmEtNDQzZC05ZDQ3LTIyMmY5ODQwZmNhNCJ9.eyJpc3MiOiJtYWN2ZW5kb3JzIiwiYXVkIjoibWFjdmVuZG9ycyIsImp0aSI6IjQyZDM4ZTQ0LTEwNmEtNDQzZC05ZDQ3LTIyMmY5ODQwZmNhNCIsImlhdCI6MTU4NTU4MzY1MywiZXhwIjoxOTAwMDc5NjUzLCJzdWIiOiI2NTY1IiwidHlwIjoiYWNjZXNzIn0.MiRX-6lrP-GvNWvY4mglnpL3O8MnH3ZlY-rJyJOaJSuP4X6IWYlyXLKR5AnSXlEpItbkFzBYawxPD2EqH0S8Sw""";
    //The key is our key. It gives us 1000 requests per day. Clunky but thus far this is the only formatting that works.
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
        if (dbs.isVendorRisky(vendor)) {
          log("Vendor is a security risk");
        } else {
          log("Vendor is not a security risk");
        }
        ...
    }
  */

}
