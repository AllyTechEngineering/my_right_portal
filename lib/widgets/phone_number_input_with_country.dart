import 'package:flutter/material.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:my_right_portal/utils/get_phone_prefix_for_country.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// ISO code map (you can move this to a shared utility file later)

class PhoneNumberInputWithCountry extends StatefulWidget {
  final TextEditingController phoneController;
  final String? selectedCountry;
  final void Function(String?) onCountryChanged;
  final String debugLabel;

  const PhoneNumberInputWithCountry({
    super.key,
    required this.phoneController,
    required this.selectedCountry,
    required this.onCountryChanged,
    required this.debugLabel,
  });

  @override
  State<PhoneNumberInputWithCountry> createState() =>
      _PhoneNumberInputWithCountryState();
}

class _PhoneNumberInputWithCountryState
    extends State<PhoneNumberInputWithCountry> {
  Map<String, String> getCountryIsoCodes() => {
    'USA': 'US',
    'Argentina': 'AR',
    'Bolivia': 'BO',
    'Chile': 'CL',
    'Colombia': 'CO',
    'Costa Rica': 'CR',
    'Cuba': 'CU',
    'Dominican Republic': 'DO',
    'Ecuador': 'EC',
    'El Salvador': 'SV',
    'Equatorial Guinea': 'GQ',
    'Guatemala': 'GT',
    'Honduras': 'HN',
    'Mexico': 'MX',
    'Nicaragua': 'NI',
    'Panama': 'PA',
    'Paraguay': 'PY',
    'Peru': 'PE',
    'Puerto Rico': 'PR',
    'Spain': 'ES',
    'Uruguay': 'UY',
    'Venezuela': 'VE',
  };
  @override
  void initState() {
    super.initState();

    // Trigger default country selection if none is set
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('In initState Selected country: ${widget.selectedCountry}');
      if (widget.selectedCountry == null || widget.selectedCountry!.isEmpty) {
        widget.onCountryChanged.call('USA');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    //final double screenWidth = MediaQuery.of(context).size.width;
    final countryIsoCodes = getCountryIsoCodes();
    final Map<String, String> localizedCountryNames = {
      'USA': localizations.country_usa,
      'Argentina': localizations.country_argentina,
      'Bolivia': localizations.country_bolivia,
      'Chile': localizations.country_chile,
      'Colombia': localizations.country_colombia,
      'Costa Rica': localizations.country_costa_rica,
      'Cuba': localizations.country_cuba,
      'Dominican Republic': localizations.country_dominican_republic,
      'Ecuador': localizations.country_ecuador,
      'El Salvador': localizations.country_el_salvador,
      'Equatorial Guinea': localizations.country_equatorial_guinea,
      'Guatemala': localizations.country_guatemala,
      'Honduras': localizations.country_honduras,
      'Mexico': localizations.country_mexico,
      'Nicaragua': localizations.country_nicaragua,
      'Panama': localizations.country_panama,
      'Paraguay': localizations.country_paraguay,
      'Peru': localizations.country_peru,
      'Puerto Rico': localizations.country_puerto_rico,
      'Spain': localizations.country_spain,
      'Uruguay': localizations.country_uruguay,
      'Venezuela': localizations.country_venezuela,
    };
    final String selectedCountry = widget.selectedCountry ?? 'USA';
    final String isoCode = countryIsoCodes[selectedCountry] ?? 'US';
    final String debugLabel = widget.debugLabel;
    debugPrint('In Phone: [$debugLabel] Selected country: $selectedCountry');
    debugPrint('In Phone: [$debugLabel] ISO code: $isoCode');
    debugPrint(
      'In Phone: Phone prefix: [$debugLabel] ${getPhonePrefixForCountry(selectedCountry)}',
    );
    final selectedCountryData = CountryManager().countries.firstWhere(
      (c) => c.countryCode == isoCode,
      orElse: () => CountryWithPhoneCode.us(),
    );

    debugPrint('🛰️ SENDING to LibPhonenumberTextFormatter:');
    debugPrint('   Country Code: ${selectedCountryData.countryCode}');
    debugPrint('   Phone Code:   ${selectedCountryData.phoneCode}');
    debugPrint('   Country Name: ${selectedCountryData.countryName}');
    return Column(
      children: [
        // Country Dropdown
        DropdownButtonFormField<String>(
          value: selectedCountry,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: localizations.add_emergency_contact_consulate_country,
            labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
            ),
            border: OutlineInputBorder(),
          ),
          items:
              countryIsoCodes.keys.map((country) {
                return DropdownMenuItem<String>(
                  value: country,
                  child: Text(
                    localizedCountryNames[country] ?? country,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withAlpha(150),
                    ),
                  ),
                );
              }).toList(),
          onChanged: widget.onCountryChanged,
        ),
        const SizedBox(width: 12),
        SizedBox(height: 8.0),
        // Phone Input
        TextField(
          key: ValueKey(widget.selectedCountry),
          controller: widget.phoneController,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            LibPhonenumberTextFormatter(
              country: CountryManager().countries.firstWhere(
                (c) => c.countryCode == isoCode,
                orElse: () => CountryWithPhoneCode.us(),
              ),
              phoneNumberType: PhoneNumberType.mobile,
              phoneNumberFormat: PhoneNumberFormat.international,
              inputContainsCountryCode: true,
            ),
          ],
          decoration: InputDecoration(
            labelText: localizations.add_emergency_contact_phone,
            labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
            ),
            hintText:
                '$selectedCountry ${getPhonePrefixForCountry(widget.selectedCountry)}',
            hintStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
            ),
            border: OutlineInputBorder(),
          ),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
          ),
        ),
      ],
    );
  }
}
