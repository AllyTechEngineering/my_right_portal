import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_right_portal/models/data_field.dart';
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
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};

  final TextEditingController _mobilePhoneController = TextEditingController();
  final TextEditingController _officePhoneController = TextEditingController();
  String _selectedMobileCountry = 'USA';
  String _selectedOfficeCountry= 'USA';

  final List<DataField> _fields = const [
    DataField(key: 'companyNameEn', label: 'Company Name (English)'),
    DataField(key: 'companyNameEs', label: 'Company Name (Spanish)'),
    DataField(key: 'contactNameEn', label: 'Contact Name (English)'),
    DataField(key: 'contactNameEs', label: 'Contact Name (Spanish)'),
    DataField(key: 'streetAddress', label: 'Street Address'),
    DataField(key: 'city', label: 'City'),
    DataField(key: 'state', label: 'State'),
    DataField(key: 'zipCode', label: 'ZIP Code'),
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
    debugPrint('⚙️ DataScreen.initState called');
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
        _mobilePhoneController.text =
            data['mobilePhoneNumber']?.toString() ?? '';
        _officePhoneController.text =
            data['officePhoneNumber']?.toString() ?? '';
        _selectedMobileCountry = data['mobilePhoneCountry']?.toString() ?? 'USA';
        _selectedOfficeCountry = data['officePhoneCountry']?.toString() ?? 'USA';
        debugPrint('📦 Loaded profile data:');
        debugPrint('mobilePhoneCountry: ${data['mobilePhoneCountry']}');
        debugPrint('officePhoneCountry: ${data['officePhoneCountry']}');
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    _formData['mobilePhoneNumber'] = _mobilePhoneController.text.trim();
    _formData['officePhoneNumber'] = _officePhoneController.text.trim();
    _formData['mobilePhoneCountry'] = _selectedMobileCountry;
    _formData['officePhoneCountry'] = _selectedOfficeCountry;
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
    // final localizations = AppLocalizations.of(context)!;
    // final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
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
                      children: [
                        SizedBox(
                          width: maxFieldWidth,
                          child: PhoneNumberInputWithCountry(
                            phoneController: _mobilePhoneController,
                            selectedCountry: _selectedMobileCountry,
                            debugLabel: 'Mobile Phone',
                            onCountryChanged:
                                (value) => setState(
                                  () => _selectedMobileCountry = value!,
                                ),
                          ),
                        ),
                        // SizedBox(
                        //   width: maxFieldWidth,
                        //   child: PhoneNumberInputWithCountry(
                        //     phoneController: _officePhoneController,
                        //     selectedCountry: _selectedOfficeCountry,
                        //     debugLabel: 'Office Phone',
                        //     onCountryChanged:
                        //         (value) => setState(
                        //           () => _selectedOfficeCountry = value!,
                        //         ),
                        //   ),
                        // ),
                        ..._fields.map((field) {
                          if (field.key == 'videoConsultation') {
                            return SizedBox(
                              width: maxFieldWidth,
                              child: SwitchListTile(
                                title: CustomTextWidget(
                                  field.label,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.labelSmall,
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
                                textAlign: TextAlign.left,
                                maxLines: null,
                                maxLength:
                                    (field.key == 'bioEn' ||
                                            field.key == 'bioEs')
                                        ? 350
                                        : null,
                                keyboardType:
                                    (field.key == 'bioEn' ||
                                            field.key == 'bioEs')
                                        ? TextInputType.multiline
                                        : field.key == 'rating'
                                        ? TextInputType.number
                                        : TextInputType.text,
                                textInputAction:
                                    (field.key == 'bioEn' ||
                                            field.key == 'bioEs')
                                        ? TextInputAction.newline
                                        : TextInputAction.done,
                                style: Theme.of(
                                  context,
                                ).textTheme.labelLarge?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                                initialValue: _formData[field.key] ?? '',
                                decoration: InputDecoration(
                                  labelText: field.label,
                                  labelStyle: Theme.of(
                                    context,
                                  ).textTheme.labelSmall?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
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
                                    final parsed = double.tryParse(value ?? '');
                                    _formData[field.key] =
                                        parsed != null
                                            ? parsed.toStringAsFixed(1)
                                            : '';
                                  } else {
                                    _formData[field.key] = value?.trim() ?? '';
                                  }
                                },
                              ),
                            );
                          }
                        }),
                      ],
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
