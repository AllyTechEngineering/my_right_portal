import 'package:flutter/widgets.dart';
import 'package:my_right_portal/models/data_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

List<DataField> getLocalizedDataFields(BuildContext context) {
  final localizations = AppLocalizations.of(context)!;

  return [
    DataField(
      key: 'companyNameEn',
      label: localizations.service_providers_company_name,
    ),
    DataField(
      key: 'companyNameEs',
      label: localizations.service_providers_company_name,
    ),
    DataField(
      key: 'contactNameEn',
      label: localizations.service_providers_contact_name,
    ),
    DataField(
      key: 'contactNameEs',
      label: localizations.service_providers_contact_name,
    ),
    DataField(
      key: 'streetAddress',
      label: localizations.service_providers_address,
    ),
    DataField(key: 'city', label: localizations.service_providers_city),
    DataField(key: 'state', label: localizations.service_providers_state),
    DataField(key: 'zipCode', label: localizations.service_providers_zip),
    DataField(
      key: 'mobilePhoneNumber',
      label: localizations.service_providers_mobile_phone,
    ),
    DataField(
      key: 'officePhoneNumber',
      label: localizations.service_providers_office_phone,
    ),
    DataField(
      key: 'emailAddress',
      label: localizations.service_providers_email,
    ),
    DataField(
      key: 'websiteUrl',
      label: localizations.service_providers_website,
    ),
    DataField(key: 'image', label: localizations.service_providers_imageUrl),
    DataField(
      key: 'experience',
      label: localizations.service_providers_experience,
    ),
    DataField(
      key: 'languagesEn',
      label: localizations.service_providers_languages,
    ),
    DataField(
      key: 'languagesEs',
      label: localizations.service_providers_languages,
    ),
    DataField(
      key: 'educationEn',
      label: localizations.service_providers_education,
    ),
    DataField(
      key: 'educationEs',
      label: localizations.service_providers_education,
    ),
    DataField(
      key: 'specialtiesEn',
      label: localizations.service_providers_specialties,
    ),
    DataField(
      key: 'specialtiesEs',
      label: localizations.service_providers_specialties,
    ),
    DataField(
      key: 'consultationFeeEn',
      label: localizations.service_providers_consultation_fee,
    ),
    DataField(
      key: 'consultationFeeEs',
      label: localizations.service_providers_consultation_fee,
    ),
    DataField(key: 'bioEn', label: localizations.service_providers_bio),
    DataField(key: 'bioEs', label: localizations.service_providers_bio),
    DataField(
      key: 'videoConsultation',
      label: localizations.data_entry_video_con,
    ),
  ];
}
