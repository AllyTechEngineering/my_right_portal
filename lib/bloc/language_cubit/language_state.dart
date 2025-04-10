part of 'language_cubit.dart';

class LanguageState extends Equatable {
  final Locale locale;

  const LanguageState({required this.locale});

  LanguageState copyWith({Locale? locale}) {
    return LanguageState(locale: locale ?? this.locale);
  }

  @override
  List<Object> get props => [locale];

  @override
  String toString() => 'LanguageState(locale: $locale)';
}
