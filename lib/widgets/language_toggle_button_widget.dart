

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_right_portal/bloc/language_cubit/language_cubit.dart';

class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    //final localizations = AppLocalizations.of(context)!;
    //final double screenWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        final buttonText =
            state.locale.languageCode == 'en' ? 'Español' : 'English';
        return TextButton(
          onPressed: () {
            context.read<LanguageCubit>().toggleLanguage();
          },
          child: Text(
            buttonText,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        );
      },
    );
  }
}
