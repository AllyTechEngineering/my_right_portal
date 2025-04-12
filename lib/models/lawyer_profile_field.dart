class LawyerProfileField {
  final String key;
  final String label;
  final bool required;

  const LawyerProfileField({
    required this.key,
    required this.label,
    this.required = false,
  });
}