// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_right_portal/utils/button_styles.dart';
import 'package:my_right_portal/utils/constants.dart';
import 'package:my_right_portal/widgets/custom_app_bar_widget.dart';
import 'package:my_right_portal/models/form_fields.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_right_portal/widgets/custom_text_widget.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  bool _isLoading = true;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = FirebaseAuth.instance.currentUser;
    // debugPrint("Trying to write to Firestore as UID: ${user?.uid}");
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

  Widget _buildTextField(
    BuildContext context,
    String key,
    String label, {
    int maxLines = 1,
  }) {
    final localizations = AppLocalizations.of(context)!;

    String? validateField(String? value) {
      final trimmedValue = value?.trim() ?? '';

      if ((key == 'mobilePhoneNumber' || key == 'officePhoneNumber')) {
        final regex = RegExp(r'^\d{3}\d{3}\d{4}$');
        if (trimmedValue.isEmpty) {
          return localizations.validation_phone_required;
        }
        try {
          if (!regex.hasMatch(trimmedValue)) {
            return localizations.validation_phone_format;
          }
        } catch (e) {
          return localizations.validation_invalid_phone;
        }
      }

      if (key == 'emailAddress') {
        final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
        if (trimmedValue.isEmpty) {
          return localizations.validation_email_required;
        }
        try {
          if (!regex.hasMatch(trimmedValue)) {
            return localizations.validation_email_invalid;
          }
        } catch (e) {
          return localizations.validation_invalid_email;
        }
      }

      if (key == 'websiteUrl') {
        final regex = RegExp(
          r'^(https?:\/\/)?([\w\-]+\.)+[\w\-]+(\/[\w\-]*)*\/?$',
        );
        if (trimmedValue.isNotEmpty) {
          try {
            if (!regex.hasMatch(trimmedValue)) {
              return localizations.validation_url_invalid;
            }
          } catch (e) {
            return localizations.validation_invalid_url;
          }
        }
      }

      if (key == 'experience') {
        if (trimmedValue.isNotEmpty) {
          try {
            final parsed = int.tryParse(trimmedValue);
            if (parsed == null) {
              return localizations.validation_experience_number;
            }
          } catch (e) {
            return localizations.validation_invalid_experience;
          }
        }
      }

      if (key == 'zipCode') {
        final regex = RegExp(r'^\d{5}$');
        if (trimmedValue.isNotEmpty) {
          try {
            if (!regex.hasMatch(trimmedValue)) {
              return localizations.validation_zip_format;
            }
          } catch (e) {
            return localizations.validation_invalid_zip;
          }
        }
      }
      if (key == 'bioEn' || key == 'bioEs') {
        if (trimmedValue.length > 250) {
          return localizations.validation_bio_limit;
        }
      }

      return null;
    }

    return TextFormField(
      initialValue: _formData[key]?.toString() ?? '',
      decoration: InputDecoration(
        labelText: label,
        floatingLabelStyle: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          height: 1.25,
          color: Colors.black,
        ),
        floatingLabelAlignment: FloatingLabelAlignment.center,
        counterText: (key == 'bioEn' || key == 'bioEs') ? null : '',
      ),
      maxLength: (key == 'bioEn' || key == 'bioEs') ? 250 : null,
      maxLines: maxLines,
      keyboardType: () {
        if (key == 'mobilePhoneNumber' || key == 'officePhoneNumber') {
          return TextInputType.phone;
        } else if (key == 'emailAddress') {
          return TextInputType.emailAddress;
        } else if (key == 'websiteUrl') {
          return TextInputType.url;
        } else if (key == 'experience') {
          return TextInputType.number;
        } else {
          return TextInputType.text;
        }
      }(),
      validator: validateField,
      onSaved: (value) {
        _formData[key] = value;
      },
    );
  }

  Future<void> _pickAndUploadImage(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    // debugPrint("🧪 Upload button clicked");
    final user = FirebaseAuth.instance.currentUser;

    // debugPrint("Trying to upload image as UID: ${user?.uid}");
    if (user == null) return;
    // debugPrint("User is authenticated: ${user.uid}");

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      // debugPrint("File picker result: $result");
      if (result != null) {
        // debugPrint("File picker result is not null");
        final file = result.files.single;
        // debugPrint("File path: ${file.path}");
        // debugPrint("File size: ${file.size}");
        // debugPrint("File extension: ${file.extension}");
        final fileBytes = file.bytes;
        // debugPrint("File bytes: ${file.bytes}");
        final fileName = file.name;
        // debugPrint("File name: ${file.name}");
        final extension = file.extension?.toLowerCase();
        // debugPrint("File extension: $extension");

        if (fileBytes == null) {
          // debugPrint("❌ File bytes are null");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.data_error_failed_to_read_image),
            ),
          );
          return;
        }

        if (extension == null ||
            !['jpg', 'jpeg', 'png', 'webp'].contains(extension)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.data_error_unsupported_image_format),
            ),
          );
          return;
        }

        try {
          final ref = _storage.ref('lawyer_images/${user.uid}/$fileName');
          // debugPrint("Uploading image to: ${ref.fullPath}");
          final uploadTask = await ref.putData(fileBytes);
          // debugPrint("Upload task completed: ${uploadTask.state}");
          final url = await uploadTask.ref.getDownloadURL();
          // debugPrint("Download URL: $url");
          // debugPrint('✅ Image uploaded to: $url');

          setState(() {
            _formData['image'] = url;
          });

          await FirebaseFirestore.instance
              .collection('lawyers')
              .doc(user.uid)
              .set({'image': url}, SetOptions(merge: true));

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(localizations.data_success_image_uploaded)),
          );
        } catch (e) {
          debugPrint('❌ Error uploading image: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.data_error_failed_to_upload_image),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('❌ Error picking image: $e');
    }
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
                padding: EdgeInsets.only(
                  left: screenWidth * 0.05,
                  right: screenWidth * 0.05,
                  bottom: screenWidth * 0.05,
                ),
                child: Form(
                  key: _formKey,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double screenWidth = constraints.maxWidth;
                      bool isLarge = screenWidth >= 1000;
                      bool isTablet = screenWidth >= 600 && screenWidth < 1000;
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextWidget(
                                '${localizations.service_providers_en}\n${localizations.data_screen_save_warning_title}',
                                textAlign: TextAlign.left,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: screenHeight * 0.01),
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
                                              context,
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
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ElevatedButton.icon(
                                                style:
                                                    ButtonStyles.primaryElevatedButtonStyle(
                                                      screenHeight:
                                                          screenHeight,
                                                      screenWidth: screenWidth,
                                                      context: context,
                                                    ),
                                                onPressed:
                                                    () => _pickAndUploadImage(
                                                      context,
                                                    ),
                                                icon: Icon(
                                                  Icons.image,
                                                  color:
                                                      Theme.of(
                                                        context,
                                                      ).colorScheme.surface,
                                                ),
                                                label: Text(
                                                  localizations
                                                      .data_entry_upload_image,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .surface,
                                                      ),
                                                ),
                                              ),
                                              if (_formData['image'] != null)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        top: 8.0,
                                                      ),
                                                  child: Image.network(
                                                    _formData['image'],
                                                    height: 120,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      )
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
                                              localizations
                                                  .data_entry_video_con,
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
                              CustomTextWidget(
                                '${localizations.service_providers_es}\n${localizations.data_screen_save_warning_title}',
                                textAlign: TextAlign.left,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children:
                                    getLocalizedDataFields(context)
                                        .where((f) => f.key.endsWith('Es'))
                                        .map(
                                          (field) => SizedBox(
                                            width:
                                                isLarge
                                                    ? 300
                                                    : isTablet
                                                    ? 250
                                                    : double.infinity,
                                            child: _buildTextField(
                                              context,
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
                                  style:
                                      ButtonStyles.primaryElevatedButtonStyle(
                                        screenHeight: screenHeight,
                                        screenWidth: screenWidth,
                                        context: context,
                                      ),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      // debugPrint('Form Data: $_formData');
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
                                          // debugPrint(
                                          //   '✅ Form data saved successfully for UID: $uid',
                                          // );
                                          if (!mounted) return;
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                localizations
                                                    .data_success_data_saved,
                                              ),
                                            ),
                                          );
                                        } catch (e) {
                                          debugPrint(
                                            '❌ Failed to save data: $e',
                                          );
                                          if (!mounted) return;
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                localizations
                                                    .data_error_general_with_variable(
                                                      e.toString(),
                                                    ),
                                              ),
                                            ),
                                          );
                                        }
                                      } else {
                                        debugPrint('❌ No authenticated user.');
                                        if (!mounted) return;
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              localizations
                                                  .data_error_user_not_logged_in,
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: Text(
                                    localizations.edit_emergency_contact_add,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium!.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/lawyer-dashboard',
                                      (Route<dynamic> route) =>
                                          false, // removes everything before
                                    );
                                  },
                                  style:
                                      ButtonStyles.primaryElevatedButtonStyle(
                                        screenHeight: screenHeight,
                                        screenWidth: screenWidth,
                                        context: context,
                                      ),
                                  child: Text(
                                    localizations.data_button_back_to_dashboard,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium!.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
    );
  }
}
