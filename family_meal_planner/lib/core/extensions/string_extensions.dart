extension StringExtensions on String {
  String get capitalized =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  bool get isBlankOrEmpty => trim().isEmpty;

  String truncate(int maxLength, {String ellipsis = '…'}) =>
      length > maxLength ? '${substring(0, maxLength)}$ellipsis' : this;
}
