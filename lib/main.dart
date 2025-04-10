import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_right_portal/bloc/language_cubit/language_cubit.dart';
import 'package:my_right_portal/features/auth/auth_gate.dart';
import 'package:my_right_portal/features/auth/login_screen.dart';
import 'package:my_right_portal/features/auth/signup_screen.dart';
import 'package:my_right_portal/features/auth/verify_email_screen.dart';
import 'package:my_right_portal/features/profile/lawyer_dashboard_screen.dart';
import 'package:my_right_portal/firebase_options.dart';
import 'package:my_right_portal/utils/custom_app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
            title: 'My Right Portal',
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
              '/': (context) => const AuthGate(),
              '/login': (context) => const LoginScreen(),
              '/verify-email': (context) => const VerifyEmailScreen(),
              '/signup': (context) => const SignupScreen(),
              '/lawyer-dashboard': (context) => const LawyerDashboardScreen(),
            },
          );
        },
      ),
    );
  }
}
/*
// import 'package:right_2_stay/screens/health_care_detail_screen.dart';

import 'package:right_2_stay/screens/add_emergency_contacts_screen.dart';
import 'package:right_2_stay/screens/consulate_screen.dart';
import 'package:right_2_stay/screens/get_started_screen.dart';
import 'package:right_2_stay/screens/local_deals_screen.dart';
import 'package:right_2_stay/screens/srv_prov_menu_screen.dart';
import 'package:right_2_stay/screens/view_emergency_contacts_screen.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:right_2_stay/screens/view_legal_providers_screen.dart';
// import 'package:right_2_stay/screens/view_service_providers_screen.dart';
import 'package:right_2_stay/utilities/database_service.dart';
import 'app.dart'; // Import the barrel file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.instance.database;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<LanguageCubit>(create: (_) => LanguageCubit()),
            ],
            child: BlocBuilder<LanguageCubit, LanguageState>(
              builder: (context, languageState) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'MyRightToStay',
                  theme: CustomAppTheme.appTheme,
                  locale: languageState.locale,
                  supportedLocales: const [
                    Locale('en', 'US'),
                    Locale('es', 'ES'),
                  ],
                  localizationsDelegates: [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  builder: (context, child) {
                    final mediaQuery = MediaQuery.of(context);
                    return MediaQuery(
                      data: mediaQuery.copyWith(
                        textScaler: mediaQuery.textScaler.clamp(
                          minScaleFactor: 1.0,
                          maxScaleFactor: 1.1,
                        ),
                      ),
                      child: child!,
                    );
                  },
                  initialRoute: '/',
                  routes: {
                    '/': (context) => const HomeScreen(),
                    '/home': (context) => const HomeScreen(),
                    '/addContacts': (context) => AddEmergencyContactsScreen(),
                    '/viewContacts': (context) => ViewEmergencyContactsScreen(),
                    '/rights': (context) => const KnowYourRightsScreen(),
                    '/resources': (context) => LegalHelpScreen(),
                    '/services': (context) => const SrvProvMenuScreen(),
                    '/jobs': (context) => FindJobsScreen(),
                    '/localFoodDeals': (context) => LocalDealsScreen(),
                    '/settings': (context) => const SettingsScreen(),
                    '/community': (context) => CommunitySupportScreen(),
                    '/education': (context) => EducationScreen(),
                    '/emergencies': (context) => EmergenciesScreen(),
                    '/financial': (context) => FinancialHelpScreen(),
                    '/healthcare': (context) => HealthCareScreen(),
                    '/ice': (context) => IceRaidsScreen(),
                    '/getStarted': (context) => const GetStartedScreen(),
                    '/consulate': (context) => const ConsulateScreen(),
                  },
                  onGenerateRoute: (settings) {
                    if (settings.name == '/viewResources') {
                      final providerType = settings.arguments as String;
                      return MaterialPageRoute(
                        builder:
                            (context) => ViewLegalProvidersScreen(
                              providerType: providerType,
                            ),
                      );
                    }
                    return null;
                  },
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Failed to initialize phone formatting'),
              ),
            ),
          );
        } else {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }
      },
    );
  }
}

*/