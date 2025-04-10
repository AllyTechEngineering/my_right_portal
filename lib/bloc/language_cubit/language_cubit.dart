import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  static const String _languageKey = 'language_code';

  LanguageCubit() : super(const LanguageState(locale: Locale('en', 'US'))) {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey);
    // If a language is already saved, update the state accordingly.
    if (languageCode != null) {
      final locale =
          languageCode == 'es'
              ? const Locale('es', 'ES')
              : const Locale('en', 'US');
      emit(LanguageState(locale: locale));
    }
  }

  Future<void> switchToEnglish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, 'en');
    emit(LanguageState(locale: const Locale('en', 'US')));
  }

  Future<void> switchToSpanish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, 'es');
    emit(LanguageState(locale: const Locale('es', 'ES')));
  }

  Future<void> toggleLanguage() async {
    if (state.locale.languageCode == 'en') {
      await switchToSpanish();
    } else {
      await switchToEnglish();
    }
  }
}
