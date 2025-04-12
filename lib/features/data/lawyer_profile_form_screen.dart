import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_right_portal/models/lawyer_profile_field.dart';

class LawyerProfileFormScreen extends StatefulWidget {
  const LawyerProfileFormScreen({super.key});

  @override
  State<LawyerProfileFormScreen> createState() =>
      _LawyerProfileFormScreenState();
}

class _LawyerProfileFormScreenState extends State<LawyerProfileFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};

  final List<LawyerProfileField> _fields = const [
    LawyerProfileField(
      key: 'companyNameEn',
      label: 'Company Name (English)',
      required: true,
    ),
    LawyerProfileField(key: 'companyNameEs', label: 'Company Name (Spanish)'),
    LawyerProfileField(key: 'bioEn', label: 'Bio (English)', required: true),
    LawyerProfileField(key: 'bioEs', label: 'Bio (Spanish)'),
    LawyerProfileField(key: 'languagesEn', label: 'Languages Spoken (English)'),
    LawyerProfileField(key: 'languagesEs', label: 'Languages Spoken (Spanish)'),
    LawyerProfileField(key: 'phone', label: 'Phone', required: true),
    LawyerProfileField(key: 'email', label: 'Email', required: true),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Your Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              for (final field in _fields)
                TextFormField(
                  initialValue: _formData[field.key] ?? '',
                  decoration: InputDecoration(labelText: field.label),
                  validator:
                      field.required
                          ? (value) =>
                              (value == null || value.trim().isEmpty)
                                  ? 'Required'
                                  : null
                          : null,
                  onSaved:
                      (value) => _formData[field.key] = value?.trim() ?? '',
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
