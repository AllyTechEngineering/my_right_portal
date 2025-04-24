import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  String _password = '';
  String _confirmPassword = '';
  String _confirmEmail = '';
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

        final doc =
            await FirebaseFirestore.instance
                .collection('lawyers')
                .doc(user.uid)
                .get();

        final isSubscribed = doc.data()?['subscriptionActive'];
        debugPrint(
          '🔍 Verified after write: subscriptionActive = $isSubscribed',
        );

        await FirebaseAuth.instance.currentUser?.sendEmailVerification();
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/verify-email');
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = e.message);
    } finally {
      setState(() => _isLoading = false);
    }
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
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final deviceType = _getDeviceType(constraints.maxWidth);
            final screenWidth = constraints.maxWidth;
            final horizontalPadding =
                deviceType == DeviceType.mobile ? 16.0 : 32.0;
            final cardMaxWidth =
                deviceType == DeviceType.desktop
                    ? 600.0
                    : deviceType == DeviceType.tablet
                    ? 500.0
                    : double.infinity;
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Center(
                    child: Card(
                      elevation: 6,
                      margin: EdgeInsets.symmetric(
                        horizontal: screenWidth * .02,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * .02,
                          vertical: screenHeight * .01,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                localizations.sign_up_register,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              FractionallySizedBox(
                                widthFactor:
                                    deviceType == DeviceType.mobile
                                        ? 0.8
                                        : deviceType == DeviceType.tablet
                                        ? 0.6
                                        : 0.4,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintMaxLines: 3,
                                    labelStyle: Theme.of(
                                      context,
                                    ).textTheme.titleMedium?.copyWith(
                                      overflow: TextOverflow.visible,
                                    ),
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
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              FractionallySizedBox(
                                widthFactor:
                                    deviceType == DeviceType.mobile
                                        ? 0.8
                                        : deviceType == DeviceType.tablet
                                        ? 0.6
                                        : 0.4,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintMaxLines: 3,
                                    labelText:
                                        localizations.sign_up_confirm_email,
                                    labelStyle: Theme.of(
                                      context,
                                    ).textTheme.titleMedium?.copyWith(
                                      overflow: TextOverflow.visible,
                                    ),
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
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              FractionallySizedBox(
                                widthFactor:
                                    deviceType == DeviceType.mobile
                                        ? 0.8
                                        : deviceType == DeviceType.tablet
                                        ? 0.6
                                        : 0.4,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintMaxLines: 3,
                                    helperStyle:
                                        Theme.of(context).textTheme.titleMedium,
                                    labelStyle:
                                        Theme.of(context).textTheme.titleMedium,
                                    hintStyle: Theme.of(
                                      context,
                                    ).textTheme.labelLarge?.copyWith(
                                      overflow: TextOverflow.visible,
                                    ),
                                    hintText: localizations.login_password_hint,
                                    labelText: localizations.sign_up_password,
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
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              FractionallySizedBox(
                                widthFactor:
                                    deviceType == DeviceType.mobile
                                        ? 0.8
                                        : deviceType == DeviceType.tablet
                                        ? 0.6
                                        : 0.4,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintMaxLines: 3,
                                    labelStyle:
                                        Theme.of(context).textTheme.titleMedium,
                                    labelText:
                                        localizations.sign_up_password_confirm,
                                    hintStyle: Theme.of(
                                      context,
                                    ).textTheme.labelLarge?.copyWith(
                                      overflow: TextOverflow.visible,
                                    ),
                                    hintText: localizations.login_password_hint,
                                  ),
                                  obscureText: true,
                                  onChanged:
                                      (value) => _confirmPassword = value,
                                  validator:
                                      (value) =>
                                          value!.isEmpty
                                              ? localizations
                                                  .sign_up_password_confirm_two
                                              : null,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              if (_errorMessage != null)
                                Text(
                                  _errorMessage!,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelLarge?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onError,
                                  ),
                                ),
                              SizedBox(height: screenHeight * 0.02),
                              _isLoading
                                  ? const CircularProgressIndicator()
                                  : FractionallySizedBox(
                                    widthFactor:
                                        deviceType == DeviceType.mobile
                                            ? 0.5
                                            : deviceType == DeviceType.tablet
                                            ? 0.3
                                            : 0.2,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 3.0,
                                        shadowColor:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                        backgroundColor:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onPrimaryFixedVariant,
                                        padding: EdgeInsets.symmetric(
                                          vertical: screenHeight * 0.02,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16.0,
                                          ),
                                          side: BorderSide.none,
                                        ),
                                      ),
                                      onPressed: _register, //'Create Account',
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
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
