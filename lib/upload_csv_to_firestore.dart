import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/services.dart' show rootBundle;
import 'package:uuid/uuid.dart';

Future<void> uploadCsvToFirestore() async {
  final csvContent = await rootBundle.loadString('assets/srv_prov_contact_info.csv');

  if (csvContent.isEmpty) {
    debugPrint('❌ CSV file is empty or not found.');
    return;
  } else {
    debugPrint('✅ CSV file loaded successfully.');
  }

  final csvRows = const CsvToListConverter(
    eol: '\n',
    shouldParseNumbers: false,
  ).convert(csvContent);

  debugPrint('✅ CSV file parsed successfully with ${csvRows.length} rows.');

  if (csvRows.isEmpty) {
    debugPrint('❌ No data found in CSV file.');
    return;
  }

  final headers = csvRows.first;
  final dataRows = csvRows.sublist(1);
  final uuid = Uuid();

  for (final row in dataRows) {
    if (row.every((element) => element.toString().trim().isEmpty)) continue;

    final Map<String, dynamic> lawyer = {};
    final String generatedId = uuid.v4();

    for (int i = 0; i < headers.length && i < row.length; i++) {
      final key = headers[i].toString().trim();
      final rawValue = row[i];

      if (key.isEmpty) continue;
      final valueString = rawValue?.toString().trim().toLowerCase();

      // 🔘 Convert booleans
      if ([
        'videoConsultation',
        'featured',
        'subscriptionActive',
        'profileApproved',
      ].contains(key)) {
        lawyer[key] = valueString == 'true';
      }
      // 🕓 Convert timestamps
      else if (key == 'createdAt' || key == 'updatedAt') {
        lawyer[key] = FieldValue.serverTimestamp();
      }
      // 🆔 Use UUID for Firestore doc ID and store in field
      else if (key == 'id') {
        lawyer[key] = generatedId;
      }
      // 🔢 Convert rating to double (1 decimal)
      else if (key == 'rating') {
        try {
          final parsed = double.tryParse(rawValue.toString());
          lawyer[key] =
              parsed != null ? double.parse(parsed.toStringAsFixed(1)) : null;
        } catch (_) {
          lawyer[key] = null;
        }
      }
      // 🔤 Default: store as trimmed string or null
      else {
        lawyer[key] = rawValue == null || valueString == ''
            ? null
            : rawValue.toString().trim();
      }
    }

    // Ensure UUID is saved as the document ID and in the document
    lawyer['id'] = generatedId;

    try {
      await FirebaseFirestore.instance
          .collection('lawyers')
          .doc(generatedId)
          .set(lawyer);

      debugPrint('✅ Uploaded: ${lawyer['companyNameEn'] ?? 'Unnamed'}');
    } catch (e) {
      debugPrint('❌ Error uploading entry: $e');
    }
  }

  debugPrint('🎉 All data uploaded with UUIDs, clean booleans, and rating as double.');
}