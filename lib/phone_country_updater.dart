import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show debugPrint;
/*
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /lawyers/{lawyerId} {
      allow read: if true; // allow public read
      allow write: if request.auth != null && request.auth.uid == lawyerId;
    }
  }
}
*/
class PhoneCountryUpdater {
  final FirebaseFirestore firestore;

  PhoneCountryUpdater({required this.firestore});

  Future<void> updateMissingPhoneCountries() async {
    final querySnapshot = await firestore.collection('lawyers').get();
    debugPrint('🔍 Found ${querySnapshot.docs.length} documents...');

    for (var doc in querySnapshot.docs) {
      final data = doc.data();

      final Map<String, dynamic> updateFields = {};

      if (!data.containsKey('mobilePhoneCountry')) {
        updateFields['mobilePhoneCountry'] = 'US';
      }

      if (!data.containsKey('officePhoneCountry')) {
        updateFields['officePhoneCountry'] = 'US';
      }

      if (updateFields.isNotEmpty) {
        await doc.reference.update(updateFields);
        debugPrint('✅ Updated: ${doc.id}');
      } else {
        debugPrint('⏭️ Skipped: ${doc.id} (already has phone country fields)');
      }
    }

    debugPrint('🎉 Done updating all records!');
  }
}