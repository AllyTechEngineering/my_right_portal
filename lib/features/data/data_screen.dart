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

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};

  Widget _buildTextField(String key, String label, {int maxLines = 1}) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      maxLines: maxLines,
      onSaved: (value) {
        _formData[key] = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double getToolBarHeight = screenHeight * Constants.kToolbarHeight;

    return Scaffold(
      appBar: CustomAppBarWidget(
        title: localizations.my_right_to_stay_title,
        getToolBarHeight: getToolBarHeight,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: LayoutBuilder(
            builder: (context, constraints) {
              double screenWidth = constraints.maxWidth;
              bool isLarge = screenWidth >= 1000;
              bool isTablet = screenWidth >= 600 && screenWidth < 1000;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      'English',
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
                        [
                              _buildTextField('companyNameEn', 'Company Name'),
                              _buildTextField('specialtiesEn', 'Specialties'),
                              _buildTextField('languagesEn', 'Languages'),
                              _buildTextField('contactNameEn', 'Contact Name'),
                              _buildTextField(
                                'streetAddress',
                                'Street Address',
                              ),
                              _buildTextField('city', 'City'),
                              _buildTextField('state', 'State'),
                              _buildTextField('zipCode', 'Postal Code'),
                              _buildTextField('websiteUrl', 'Website URL'),
                              _buildTextField('emailAddress', 'Email Address'),
                              _buildTextField(
                                'mobilePhoneNumber',
                                'Mobile Phone',
                              ),
                              _buildTextField(
                                'officePhoneNumber',
                                'Office Phone',
                              ),
                              _buildTextField('bioEn', 'Bio', maxLines: 3),
                              _buildTextField('educationEn', 'Education'),
                              _buildTextField('experience', 'Experience'),
                              SwitchListTile(
                                title: const Text('Video Consult'),
                                value: _formData['videoConsultation'] ?? false,
                                onChanged: (bool value) {
                                  setState(() {
                                    _formData['videoConsultation'] = value;
                                  });
                                },
                              ),
                              _buildTextField(
                                'consultationFeeEn',
                                'Consult Fee',
                              ),
                              _buildTextField('image', 'Image'),
                            ]
                            .map(
                              (e) => SizedBox(
                                width:
                                    isLarge
                                        ? 300
                                        : isTablet
                                        ? 250
                                        : double.infinity,
                                child: e,
                              ),
                            )
                            .toList(),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      'Spanish',
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
                        [
                              _buildTextField('companyNameEs', 'Company Name'),
                              _buildTextField('specialtiesEs', 'Specialties'),
                              _buildTextField('languagesEs', 'Languages'),
                              _buildTextField('contactNameEs', 'Contact Name'),
                              _buildTextField(
                                'streetAddress',
                                'Street Address',
                              ),
                              _buildTextField('city', 'City'),
                              _buildTextField('state', 'State'),
                              _buildTextField('zipCode', 'Postal Code'),
                              _buildTextField('websiteUrl', 'Website URL'),
                              _buildTextField('emailAddress', 'Email Address'),
                              _buildTextField(
                                'mobilePhoneNumber',
                                'Mobile Phone',
                              ),
                              _buildTextField(
                                'officePhoneNumber',
                                'Office Phone',
                              ),
                              _buildTextField('bioEs', 'Bio', maxLines: 3),
                              _buildTextField('educationEs', 'Education'),
                              _buildTextField('experience', 'Experience'),
                              SwitchListTile(
                                title: const Text('Video Consult'),
                                value: _formData['videoConsultation'] ?? false,
                                onChanged: (bool value) {
                                  setState(() {
                                    _formData['videoConsultation'] = value;
                                  });
                                },
                              ),
                              _buildTextField(
                                'consultationFeeEs',
                                'Consult Fee',
                              ),
                              _buildTextField('image', 'Image'),
                            ]
                            .map(
                              (e) => SizedBox(
                                width:
                                    isLarge
                                        ? 300
                                        : isTablet
                                        ? 250
                                        : double.infinity,
                                child: e,
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
                          final user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            final uid = user.uid;
                            try {
                              await FirebaseFirestore.instance
                                  .collection('listings')
                                  .doc(uid)
                                  .set(_formData, SetOptions(merge: true));
                              debugPrint(
                                '✅ Form data saved successfully for UID: $uid',
                              );
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Data saved successfully.'),
                                ),
                              );
                            } catch (e) {
                              debugPrint('❌ Failed to save data: $e');
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          } else {
                            debugPrint('❌ No authenticated user.');
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
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
              );
            },
          ),
        ),
      ),
    );
  }
}
