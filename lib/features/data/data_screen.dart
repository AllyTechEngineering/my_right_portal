import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_right_portal/models/data_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_right_portal/utils/constants.dart';
import 'package:my_right_portal/widgets/custom_app_bar_widget.dart';
import 'package:my_right_portal/widgets/custom_text_widget.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};

  final List<DataField> _fields = const [
    DataField(key: 'companyNameEn', label: 'Company Name (English)'),
    DataField(key: 'companyNameEs', label: 'Company Name (Spanish)'),
    DataField(key: 'contactNameEn', label: 'Contact Name (English)'),
    DataField(key: 'contactNameEs', label: 'Contact Name (Spanish)'),
    DataField(key: 'streetAddress', label: 'Street Address'),
    DataField(key: 'city', label: 'City'),
    DataField(key: 'state', label: 'State'),
    DataField(key: 'zipCode', label: 'ZIP Code'),
    DataField(key: 'mobilePhoneNumber', label: 'Mobile Phone Number'),
    DataField(key: 'officePhoneNumber', label: 'Office Phone Number'),
    DataField(key: 'emailAddress', label: 'Email Address'),
    DataField(key: 'websiteUrl', label: 'Website URL'),
    DataField(key: 'image', label: 'Image URL'),
    DataField(key: 'experience', label: 'Experience'),
    DataField(key: 'languagesEn', label: 'Languages (English)'),
    DataField(key: 'languagesEs', label: 'Languages (Spanish)'),
    DataField(key: 'educationEn', label: 'Education (English)'),
    DataField(key: 'educationEs', label: 'Education (Spanish)'),
    DataField(key: 'specialtiesEn', label: 'Specialties (English)'),
    DataField(key: 'specialtiesEs', label: 'Specialties (Spanish)'),
    DataField(key: 'consultationFeeEn', label: 'Consultation Fee (English)'),
    DataField(key: 'consultationFeeEs', label: 'Consultation Fee (Spanish)'),
    DataField(key: 'bioEn', label: 'Bio (English)'),
    DataField(key: 'bioEs', label: 'Bio (Spanish)'),
    DataField(key: 'videoConsultation', label: 'Video Consultation'),
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('lawyers').doc(uid).get();
    final data = doc.data();

    if (data != null) {
      setState(() {
        for (final field in _fields) {
          _formData[field.key] = data[field.key]?.toString() ?? '';
        }
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('lawyers')
          .doc(uid)
          .update(_formData);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Profile updated successfully')),
      );
    } catch (e) {
      debugPrint('❌ Error updating profile: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Failed to update profile')),
      );
    }
  }

  int _getColumnCount(double width) {
    if (width >= 1200) return 6;
    if (width >= 800) return 4;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double iconSize = screenWidth * 0.055;
    iconSize = iconSize.clamp(18.0, 26.0);
    final double getToolBarHeight = screenHeight * Constants.kToolbarHeight;

    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Manage Your Data',
        getToolBarHeight: getToolBarHeight,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final columns = _getColumnCount(constraints.maxWidth);
            final spacing = 16.0;
            final maxFieldWidth =
                (constraints.maxWidth - spacing * (columns - 1)) / columns;

            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: spacing,
                      runSpacing: 16,
                      children:
                          _fields.map((field) {
                            if (field.key == 'videoConsultation' ||
                                field.key == 'featured') {
                              return SizedBox(
                                width: maxFieldWidth,
                                //Text(field.label),
                                child: SwitchListTile(
                                  title: CustomTextWidget(
                                    field.label,
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),

                                  value: _formData[field.key] == 'true',
                                  onChanged: (value) {
                                    setState(() {
                                      _formData[field.key] = value.toString();
                                    });
                                  },
                                ),
                              );
                            } else {
                              return SizedBox(
                                width: maxFieldWidth,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  maxLines: null,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelLarge?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                  initialValue: _formData[field.key] ?? '',
                                  decoration: InputDecoration(
                                    labelText: field.label,
                                    labelStyle: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                  ),
                                  keyboardType:
                                      field.key == 'rating'
                                          ? TextInputType.number
                                          : TextInputType.text,
                                  validator:
                                      field.required
                                          ? (value) =>
                                              (value == null ||
                                                      value.trim().isEmpty)
                                                  ? 'Required'
                                                  : null
                                          : null,
                                  onSaved: (value) {
                                    if (field.key == 'rating') {
                                      final parsed = double.tryParse(
                                        value ?? '',
                                      );
                                      _formData[field.key] =
                                          parsed != null
                                              ? parsed.toStringAsFixed(1)
                                              : '';
                                    } else {
                                      _formData[field.key] =
                                          value?.trim() ?? '';
                                    }
                                  },
                                ),
                              );
                            }
                          }).toList(),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _saveProfile,
                      child: const Text('Save Changes'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
