import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum AppScreen {
  home,
  addContacts,
  rights,
  legal,
  resources,
  jobs,
  settings,
  viewContacts,
  services,
  healthcare,
  consulate,
  community,
}

extension AppScreenExtension on AppScreen {
  String get route {
    switch (this) {
      case AppScreen.home:
        return '/home';
      case AppScreen.addContacts:
        return '/addContacts';
      case AppScreen.rights:
        return '/rights';
      case AppScreen.legal:
        return '/legal';
      case AppScreen.healthcare:
        return '/healthcare';
      case AppScreen.consulate:
        return '/consulate';
      case AppScreen.community:
        return '/community';
      default:
        return '/';
    }
  }

  IconData get icon {
    switch (this) {
      case AppScreen.home:
        return Icons.home_outlined;
      case AppScreen.addContacts:
        return Icons.group_add_outlined;
      case AppScreen.rights:
        return Icons.shield_outlined;
      case AppScreen.legal:
        return Icons.balance_outlined;
      case AppScreen.healthcare:
        return Icons.favorite_border_outlined;
      case AppScreen.consulate:
        return Icons.public_outlined;
      case AppScreen.community:
        return Icons.people_outline;
      default:
        return Icons.circle;
    }
  }

  String label(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    switch (this) {
      case AppScreen.home:
        return localizations.drawer_home;
      case AppScreen.addContacts:
        return localizations.drawer_add_contacts;
      case AppScreen.rights:
        return localizations.drawer_know_your_rights;
      case AppScreen.legal:
        return localizations.drawer_legal_help;
      case AppScreen.healthcare:
        return localizations.healthcare_title;
      case AppScreen.consulate:
        return localizations.drawer_consulate;
      case AppScreen.community:
        return localizations.community_support_title;
      default:
        return '';
    }
  }
}
