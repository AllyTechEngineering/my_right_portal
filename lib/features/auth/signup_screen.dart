// ignore_for_file: unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_right_portal/utils/button_styles.dart';
import 'package:my_right_portal/widgets/custom_drawer_widget.dart';
import 'package:my_right_portal/utils/constants.dart';
import 'package:my_right_portal/widgets/custom_app_bar_widget.dart';

enum DeviceType { mobile, tablet, desktop }

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _confirmEmail = '';
  String _password = '';
  String _confirmPassword = '';
  String? _errorMessage;
  bool _isLoading = false;

  DeviceType _getDeviceType(double width) {
    if (width >= 1024) return DeviceType.desktop;
    if (width >= 600) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (_password != _confirmPassword) {
      setState(() => _errorMessage = 'Passwords do not match');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance
            .collection('lawyers')
            .doc(user.uid)
            .set({
              'id': user.uid,
              'emailAddress': user.email,
              'subscriptionActive': false,
              'profileApproved': false,
              'createdAt': FieldValue.serverTimestamp(),
            });

        await FirebaseAuth.instance.currentUser?.sendEmailVerification();
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/verify-email');
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = e.message);
      debugPrint('Error: ${e.message}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(
        const AssetImage('assets/images/mrts_liberty.png'),
        context,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;
    final getToolBarHeight = screenHeight * Constants.kToolbarHeight;

    return Scaffold(
      appBar: CustomAppBarWidget(
        title: localizations.my_right_to_stay_title,
        getToolBarHeight: getToolBarHeight,
      ),
      drawer: const CustomDrawerWidget(),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/mrts_background.png',
                fit: BoxFit.cover,
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                final deviceType = _getDeviceType(screenWidth);
                final padding = deviceType == DeviceType.mobile ? 16.0 : 32.0;
                final widthFactor =
                    deviceType == DeviceType.mobile
                        ? 0.8
                        : deviceType == DeviceType.tablet
                        ? 0.7
                        : 0.6;
                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: padding,
                    right: padding,
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: (deviceType == DeviceType.mobile
                                ? screenWidth * 0.8
                                : deviceType == DeviceType.tablet
                                ? screenWidth * 0.7
                                : screenWidth * 0.6)
                            .clamp(0.0, 640.0),
                      ),
                      child: FractionallySizedBox(
                        widthFactor: widthFactor,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 40),
                              Text(
                                localizations.sign_up_register,
                                style: Theme.of(
                                  context,
                                ).textTheme.titleLarge?.copyWith(
                                  fontSize:
                                      deviceType == DeviceType.mobile
                                          ? 20
                                          : deviceType == DeviceType.tablet
                                          ? 24
                                          : 28,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText:
                                      localizations.service_providers_email,
                                ),
                                onChanged: (value) => _email = value.trim(),
                                validator:
                                    (value) =>
                                        value!.isEmpty
                                            ? localizations.sign_up_email
                                            : null,
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText:
                                      localizations.sign_up_confirm_email,
                                ),
                                onChanged:
                                    (value) => _confirmEmail = value.trim(),
                                validator:
                                    (value) =>
                                        value != _email
                                            ? localizations
                                                .sign_up_email_mismatch
                                            : null,
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: localizations.sign_up_password,
                                  hintText: localizations.login_password_hint,
                                ),
                                obscureText: true,
                                onChanged: (value) => _password = value,
                                validator:
                                    (value) =>
                                        value!.length < 6
                                            ? localizations
                                                .sign_up_password_size
                                            : null,
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText:
                                      localizations.sign_up_password_confirm,
                                  hintText: localizations.login_password_hint,
                                ),
                                obscureText: true,
                                onChanged: (value) => _confirmPassword = value,
                                validator:
                                    (value) =>
                                        value!.isEmpty
                                            ? localizations
                                                .sign_up_password_confirm_two
                                            : null,
                              ),
                              const SizedBox(height: 20),
                              if (_errorMessage != null)
                                Text(
                                  _errorMessage!,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.onError,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              const SizedBox(height: 30),
                              _isLoading
                                  ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                  : ElevatedButton(
                                    onPressed: _register,
                                    style:
                                        ButtonStyles.primaryElevatedButtonStyle(
                                          screenHeight: screenHeight,
                                          screenWidth: screenWidth,
                                          context: context,
                                        ),
                                    child: Text(
                                      localizations.sign_up_register,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge?.copyWith(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.surface,
                                      ),
                                    ),
                                  ),
                              Container(
                                color: Colors.transparent,
                                height: screenHeight * .5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
