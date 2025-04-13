class DataField {
  final String key;
  final String label;
  final bool required;

  const DataField({
    required this.key,
    required this.label,
    this.required = false,
  });
}