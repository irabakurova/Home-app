/// Описание доступного обновления, полученное из version.json.
class UpdateInfo {
  const UpdateInfo({
    required this.version,
    required this.buildNumber,
    required this.androidUrl,
    required this.windowsUrl,
    required this.releaseNotes,
  });

  final String version;
  final int buildNumber;
  final String androidUrl;
  final String windowsUrl;
  final String releaseNotes;

  factory UpdateInfo.fromJson(Map<String, dynamic> json) => UpdateInfo(
        version: json['version'] as String? ?? '',
        buildNumber: (json['build_number'] as num?)?.toInt() ?? 0,
        androidUrl: json['android_url'] as String? ?? '',
        windowsUrl: json['windows_url'] as String? ?? '',
        releaseNotes: json['release_notes'] as String? ?? '',
      );
}
