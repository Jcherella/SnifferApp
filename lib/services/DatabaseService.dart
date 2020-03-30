import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final databaseInstance = Firestore.instance.collection("MAC_Address");

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
  Future<String> lookupVendor(String macAddress) async {
    try {
      return await databaseInstance.document(macAddress).get().then(
          (documentSnapshot) => documentSnapshot.data['vendor'].toString());
    } on NoSuchMethodError catch (e) {
      log("Failed to find mac address in database: " + e.toString());
    } catch (e) {
      log("Failed to perform vendor lookup: " + e.toString());
    }
    return 'null';
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
