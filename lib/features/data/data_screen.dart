// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_right_portal/models/data_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_right_portal/utils/constants.dart';
import 'package:my_right_portal/widgets/custom_app_bar_widget.dart';
import 'package:my_right_portal/widgets/custom_text_widget.dart';
import 'package:my_right_portal/widgets/phone_number_input_with_country.dart';
import 'package:my_right_portal/models/form_fields.dart';

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
class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = FirebaseAuth.instance.currentUser;
    debugPrint("Trying to write to Firestore as UID: ${user?.uid}");
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('lawyers')
              .doc(user.uid)
              .get();
      if (doc.exists) {
        setState(() {
          _formData.addAll(doc.data()!);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

Widget _buildTextField(String key, String label, {int maxLines = 1}) {
  return TextFormField(
    initialValue: _formData[key]?.toString() ?? '',
    decoration: InputDecoration(
      focusColor: Colors.blue,
      labelText: label,
      floatingLabelStyle: const TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        height: 1.25,
        color: Colors.black,
      ),
      floatingLabelAlignment: FloatingLabelAlignment.center,
    ),
    maxLines: maxLines,
    keyboardType: key == 'zipCode' ? TextInputType.number : TextInputType.text,
    validator: (value) {
      if (key == 'zipCode') {
        final zipCode = value?.trim() ?? '';
        debugPrint('ZIP Code: $zipCode');
        if (zipCode.isEmpty) {
          return 'ZIP Code is required';
        } else if (!RegExp(r'^\d{5}$').hasMatch(zipCode)) {
          return 'ZIP Code must be 5 digits';
        }
      }
      return null;
    },
    onSaved: (value) {
      _formData[key] = value;
    },
  );
}

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double getToolBarHeight = screenHeight * Constants.kToolbarHeight;
    double iconSize = screenWidth * 0.055;
    iconSize = iconSize.clamp(18.0, 26.0);

    return Scaffold(
      appBar: CustomAppBarWidget(
        title: localizations.my_right_to_stay_title,
        getToolBarHeight: getToolBarHeight,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double screenWidth = constraints.maxWidth;
                      bool isLarge = screenWidth >= 1000;
                      bool isTablet = screenWidth >= 600 && screenWidth < 1000;

                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child: Text(
                                localizations.service_providers_en,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children:
                                  getLocalizedDataFields(context)
                                      .where(
                                        (f) =>
                                            f.key.endsWith('En') ||
                                            f.key == 'streetAddress' ||
                                            f.key == 'city' ||
                                            f.key == 'state' ||
                                            f.key == 'zipCode' ||
                                            f.key == 'websiteUrl' ||
                                            f.key == 'emailAddress' ||
                                            f.key == 'mobilePhoneNumber' ||
                                            f.key == 'officePhoneNumber' ||
                                            f.key == 'experience' ||
                                            f.key == 'image',
                                      )
                                      .map(
                                        (field) => SizedBox(
                                          width:
                                              isLarge
                                                  ? 300
                                                  : isTablet
                                                  ? 250
                                                  : double.infinity,
                                          child: _buildTextField(
                                            field.key,
                                            field.label,
                                            maxLines:
                                                field.key.contains('bio')
                                                    ? 3
                                                    : 1,
                                          ),
                                        ),
                                      )
                                      .toList()
                                    ..add(
                                      SizedBox(
                                        width:
                                            isLarge
                                                ? 300
                                                : isTablet
                                                ? 250
                                                : double.infinity,
                                        child: SwitchListTile(
                                          title: Text(
                                            localizations.data_entry_video_con,
                                          ),
                                          value:
                                              _formData['videoConsultation'] ??
                                              false,
                                          onChanged: (bool value) {
                                            setState(() {
                                              _formData['videoConsultation'] =
                                                  value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child: Text(
                                localizations.service_providers_es,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children:
                                  getLocalizedDataFields(context)
                                      .where(
                                        (f) =>
                                            f.key.endsWith('Es') ||
                                            f.key == 'streetAddress' ||
                                            f.key == 'city' ||
                                            f.key == 'state' ||
                                            f.key == 'zipCode' ||
                                            f.key == 'websiteUrl' ||
                                            f.key == 'emailAddress' ||
                                            f.key == 'mobilePhoneNumber' ||
                                            f.key == 'officePhoneNumber' ||
                                            f.key == 'experience' ||
                                            f.key == 'image',
                                      )
                                      .map(
                                        (field) => SizedBox(
                                          width:
                                              isLarge
                                                  ? 300
                                                  : isTablet
                                                  ? 250
                                                  : double.infinity,
                                          child: _buildTextField(
                                            field.key,
                                            field.label,
                                            maxLines:
                                                field.key.contains('bio')
                                                    ? 3
                                                    : 1,
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                            const SizedBox(height: 24),
                            Center(
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    debugPrint('Form Data: $_formData');
                                    final user =
                                        FirebaseAuth.instance.currentUser;
                                    if (user != null) {
                                      final uid = user.uid;
                                      try {
                                        await FirebaseFirestore.instance
                                            .collection('lawyers')
                                            .doc(uid)
                                            .set(
                                              _formData,
                                              SetOptions(merge: true),
                                            );
                                        debugPrint(
                                          '✅ Form data saved successfully for UID: $uid',
                                        );
                                        if (!mounted) return;
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Data saved successfully.',
                                            ),
                                          ),
                                        );
                                      } catch (e) {
                                        debugPrint('❌ Failed to save data: $e');
                                        if (!mounted) return;
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(content: Text('Error: $e')),
                                        );
                                      }
                                    } else {
                                      debugPrint('❌ No authenticated user.');
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('User not logged in.'),
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: const Text('Submit'),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
    );
  }
}
