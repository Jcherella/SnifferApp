import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snifferapp/services/DatabaseService.dart';

const collectionName = 'MAC_Address';

void main() {
  testWidgets('Show Firebase CloudStore Valid Look Up', (WidgetTester tester) async {
    // Populate the mock database.
    final firestore = MockFirestoreInstance().collection(collectionName);
    firestore.document('00:de:fb').setData({'vendor': 'Cisco Systems, Inc'});

    // Call service
    final DatabaseService dbs = new DatabaseService();
    String vendor = await dbs.lookupVendor("00:de:fb:35:c0:c1", instance: firestore);

    // Verify the output.
    expect("Cisco Systems, Inc", vendor);
  });

  testWidgets('Show Firebase CloudStore N/A Vendor', (WidgetTester tester) async {
    // Populate the mock database.
    final firestore = MockFirestoreInstance().collection(collectionName);
    firestore.document('44:aa:fb').setData({'vendor': 'Apple'});

    // Call service
    final DatabaseService dbs = new DatabaseService();
    String vendor = await dbs.lookupVendor("45:aa:fb:35:c0:c2", instance: firestore);

    // Verify the output.
    expect("null", vendor);
  });

  testWidgets('Show Firebase CloudStore Invalid MAC Address', (WidgetTester tester) async {
    // Populate the mock database.
    final firestore = MockFirestoreInstance().collection(collectionName);
    firestore.document('44:aa:fb').setData({'vendor': 'Apple'});

    // Call service
    final DatabaseService dbs = new DatabaseService();
    String vendor = await dbs.lookupVendor("45:aa", instance: firestore);

    // Verify the output.
    expect("null", vendor);
  });
}