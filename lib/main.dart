import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_right_portal/bloc/language_cubit/language_cubit.dart';
import 'package:my_right_portal/features/auth/auth_gate.dart';
import 'package:my_right_portal/features/auth/login_screen.dart';
import 'package:my_right_portal/features/auth/signup_screen.dart';
import 'package:my_right_portal/features/auth/verify_email_screen.dart';
import 'package:my_right_portal/features/data/data_screen.dart';
import 'package:my_right_portal/features/home/home_screen.dart';
import 'package:my_right_portal/features/profile/lawyer_dash_board_screen.dart';
import 'package:my_right_portal/features/subscription/cancel_screen.dart';
import 'package:my_right_portal/features/subscription/subscription_prompt_screen.dart';
import 'package:my_right_portal/features/subscription/success_screen.dart';
import 'package:my_right_portal/firebase_options.dart';
import 'package:my_right_portal/utils/custom_app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    // Optional: helpful during local dev
    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues({});
  }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider<LanguageCubit>(create: (_) => LanguageCubit())],
      child: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, languageState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Right2StayNow - Connect with Immigration Attorneys You Can Trust',
            theme: CustomAppTheme.appTheme,
            locale: languageState.locale,
            supportedLocales: const [Locale('en', 'US'), Locale('es', 'ES')],
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routes: {
              '/': (context) => const HomeScreen(),
              '/home': (context) => const HomeScreen(),
              '/auth-gate': (context) => const AuthGate(),
              '/login': (context) => const LoginScreen(),
              '/verify-email': (context) => const VerifyEmailScreen(),
              '/signup': (context) => const SignupScreen(),
              '/lawyer-dashboard': (context) => const LawyerDashboardScreen(),
              '/subscription-prompt': (context) => const SubscriptionPromptScreen(),
              '/data-form': (context) => const DataScreen(),
              '/cancel-subscription': (context) => const CancelScreen(),
              '/success-subscription': (context) => const SuccessScreen(),
            },
          );
        },
      ),
    );
  }
}