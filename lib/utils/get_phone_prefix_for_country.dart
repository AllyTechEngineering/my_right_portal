// ignore: unused_element
String getPhonePrefixForCountry(String? countryName) {
  final Map<String, String> countryPrefixes = {
    'USA': '+1',
    'Argentina': '+54',
    'Bolivia': '+591',
    'Chile': '+56',
    'Colombia': '+57',
    'Costa Rica': '+506',
    'Cuba': '+53',
    'Dominican Republic': '+1',
    'Ecuador': '+593',
    'El Salvador': '+503',
    'Equatorial Guinea': '+240',
    'Guatemala': '+502',
    'Honduras': '+504',
    'Mexico': '+52',
    'Nicaragua': '+505',
    'Panama': '+507',
    'Paraguay': '+595',
    'Peru': '+51',
    'Puerto Rico': '+1',
    'Spain': '+34',
    'Uruguay': '+598',
    'Venezuela': '+58',
  };

  return countryPrefixes[countryName] ?? '';
}
