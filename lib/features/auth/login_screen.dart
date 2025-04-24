import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_right_portal/utils/constants.dart';
import 'package:my_right_portal/widgets/custom_app_bar_widget.dart';
import 'package:my_right_portal/widgets/custom_text_widget.dart';

enum DeviceType { mobile, tablet, desktop }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String? _errorMessage;
  bool _isLoading = false;

  DeviceType _getDeviceType(double width) {
    if (width >= 1024) return DeviceType.desktop;
    if (width >= 600) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  String _getLocalizedErrorMessage(
    FirebaseAuthException e,
    AppLocalizations localizations,
  ) {
    switch (e.code) {
      case 'invalid-email':
        return localizations.login_invalid_email;
      case 'user-disabled':
        return localizations.login_user_disabled;
      case 'user-not-found':
        return localizations.login_user_not_found;
      case 'wrong-password':
      case 'invalid-password':
        return localizations.login_invalid_password;
      case 'too-many-requests':
        return localizations.login_too_many_attempts;
      case 'network-request-failed':
        return localizations.login_network_error;
      default:
        return localizations.login_generic_error;
    }
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.login_success),
            ),
          );
          Navigator.pushReplacementNamed(context, '/auth-gate');
        }
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        final localizations = AppLocalizations.of(context)!;
        _errorMessage = _getLocalizedErrorMessage(e, localizations);
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final localizations = AppLocalizations.of(context)!;
        final deviceType = _getDeviceType(constraints.maxWidth);
        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = constraints.maxWidth;
        final getToolBarHeight = screenHeight * Constants.kToolbarHeight;
        final horizontalPadding = deviceType == DeviceType.mobile ? 16.0 : 32.0;
        final cardMaxWidth =
            deviceType == DeviceType.desktop
                ? 600.0
                : deviceType == DeviceType.tablet
                ? 500.0
                : double.infinity;
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: CustomAppBarWidget(
            title: localizations.my_right_to_stay_title,
            getToolBarHeight: getToolBarHeight,
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: screenHeight * 0.04,
                  ),
                  color: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withAlpha(100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomTextWidget(
                        localizations.mission_statement_title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Container(
                        padding: EdgeInsets.only(
                          left: screenWidth * 0.08,
                          right: screenWidth * 0.05,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextWidget(
                              localizations.mission_statement_msg,
                              textAlign: TextAlign.start,
                              style: Theme.of(
                                context,
                              ).textTheme.labelLarge!.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            CustomTextWidget(
                              localizations.mission_statement_submsg,
                              textAlign: TextAlign.start,
                              style: Theme.of(
                                context,
                              ).textTheme.labelLarge!.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            CustomTextWidget(
                              localizations.mission_statement_submsg_two,
                              textAlign: TextAlign.start,
                              style: Theme.of(
                                context,
                              ).textTheme.labelLarge!.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                Card(
                  elevation: 6,
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Padding(
                    padding: EdgeInsets.all(horizontalPadding),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            localizations.login_title,
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
                              style: Theme.of(context).textTheme.titleLarge,
                              decoration: InputDecoration(
                                isDense: true,
                                hintMaxLines: 3,
                                labelStyle:
                                    Theme.of(context).textTheme.titleLarge,
                                labelText: localizations.login_email,
                              ),
                              onChanged: (value) => _email = value.trim(),
                              validator:
                                  (value) =>
                                      value!.isEmpty
                                          ? localizations.login_email_required
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
                                    Theme.of(context).textTheme.titleLarge,
                                labelStyle:
                                    Theme.of(context).textTheme.titleLarge,
                                labelText: localizations.login_password,
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(overflow: TextOverflow.visible),
                                hintText: localizations.login_password_hint,
                              ),
                              obscureText: true,
                              onChanged: (value) => _password = value,
                              validator:
                                  (value) =>
                                      value!.isEmpty
                                          ? localizations
                                              .login_password_required
                                          : null,
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (_errorMessage != null)
                            Text(
                              _errorMessage!,
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onError,
                              ),
                            ),
                          // 🔽 BEGIN Forgot Password Dialog
                          FractionallySizedBox(
                            widthFactor:
                                deviceType == DeviceType.mobile
                                    ? 0.9
                                    : deviceType == DeviceType.tablet
                                    ? 0.6
                                    : 0.4,
                            child: TextButton(
                              onPressed: () async {
                                final emailController = TextEditingController();
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                        localizations
                                            .login_forgot_password_title,
                                      ),
                                      content: TextFormField(
                                        controller: emailController,
                                        decoration: InputDecoration(
                                          labelText: localizations.login_email,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            try {
                                              await FirebaseAuth.instance
                                                  .sendPasswordResetEmail(
                                                    email:
                                                        emailController.text
                                                            .trim(),
                                                  );
                                              if (context.mounted) {
                                                Navigator.pop(context);
                                              }
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      localizations
                                                          .login_password_reset_sent,
                                                    ),
                                                  ),
                                                );
                                              }
                                            } catch (e) {
                                              if (context.mounted) {
                                                Navigator.pop(context);
                                              }
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      localizations
                                                          .login_password_reset_error,
                                                    ),
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                          child: Text(
                                            localizations.login_send_reset_link,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text(
                                localizations.login_forgot_password,
                                style: Theme.of(
                                  context,
                                ).textTheme.titleSmall!.copyWith(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          // 🔼 END Forgot Password Dialog
                          const SizedBox(height: 10),
                          _isLoading
                              ? const CircularProgressIndicator()
                              : FractionallySizedBox(
                                widthFactor:
                                    deviceType == DeviceType.mobile
                                        ? 0.9
                                        : deviceType == DeviceType.tablet
                                        ? 0.6
                                        : 0.4,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 3.0,
                                    shadowColor:
                                        Theme.of(context).colorScheme.onPrimary,
                                    backgroundColor:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onPrimaryFixedVariant,
                                    padding: EdgeInsets.symmetric(
                                      vertical: screenHeight * 0.02,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                      side: BorderSide.none,
                                    ),
                                  ),
                                  onPressed: _login,
                                  child: Text(
                                    localizations.login_title,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleLarge?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                    ),
                                  ),
                                ),
                              ),
                          const SizedBox(height: 10),
                          FractionallySizedBox(
                            widthFactor:
                                deviceType == DeviceType.mobile
                                    ? 0.9
                                    : deviceType == DeviceType.tablet
                                    ? 0.6
                                    : 0.4,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryFixedVariant,
                                elevation: 3.0,
                                shadowColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.02,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                  side: BorderSide.none,
                                ),
                              ),
                              onPressed:
                                  () => Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/signup',
                                    (route) => false,
                                  ),
                              child: CustomTextWidget(
                                localizations.login_dont_have_account,
                                textAlign: TextAlign.center,
                                style: Theme.of(
                                  context,
                                ).textTheme.titleSmall!.copyWith(
                                  color: Theme.of(context).colorScheme.surface,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Theme.of(context).colorScheme.surface,
                                  decorationThickness: 2.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
