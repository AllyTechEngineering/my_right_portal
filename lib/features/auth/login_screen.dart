import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_right_portal/utils/constants.dart';
import 'package:my_right_portal/widgets/custom_app_bar_widget.dart';

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
          ScaffoldMessenger.of(//'Login successful'
            context,
          ).showSnackBar( SnackBar(content: Text(
            AppLocalizations.of(context)!.login_success,
          )));
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
    final localizations = AppLocalizations.of(context)!;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    //final double buttonSize = screenWidth * 0.30;
    double iconSize = screenWidth * 0.055;
    iconSize = iconSize.clamp(18.0, 26.0);
    final double getToolBarHeight = screenHeight * Constants.kToolbarHeight;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomAppBarWidget(
        title: localizations.my_right_to_stay_title,
        getToolBarHeight: getToolBarHeight,
      ),
      body: Center(
        child: Card(
          elevation: 6,
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    localizations.login_title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  TextFormField(
                    style: Theme.of(context).textTheme.titleLarge,
                    decoration: InputDecoration(
                      labelText: localizations.login_email,
                    ),
                    onChanged: (value) => _email = value.trim(),
                    validator:
                        (value) =>
                            value!.isEmpty
                                ? localizations.login_email_required
                                : null,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      helperStyle: Theme.of(context).textTheme.titleLarge,
                      labelStyle: Theme.of(context).textTheme.titleLarge,
                      labelText: localizations.login_title,
                      hintStyle: Theme.of(context).textTheme.titleLarge,
                      hintText: localizations.login_password_hint,
                    ),
                    obscureText: true,
                    onChanged: (value) => _password = value,
                    validator:
                        (value) =>
                            value!.isEmpty
                                ? localizations.login_password_required
                                : null,
                  ),
                  const SizedBox(height: 20),
                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onError,
                      ),
                    ),
                  const SizedBox(height: 10),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                        style: TextButton.styleFrom(
                          elevation: 3.0,
                          shadowColor: Theme.of(context).colorScheme.onPrimary,
                          backgroundColor:
                              Theme.of(
                                context,
                              ).colorScheme.onPrimaryFixedVariant,
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02,
                            horizontal: screenWidth * 0.1,
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
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                      ),
                  const SizedBox(height: 10),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                        horizontal: screenWidth * 0.1,
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
                    child: Text(
                      localizations.login_dont_have_account,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
