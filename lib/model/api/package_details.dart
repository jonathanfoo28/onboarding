class Pubspec {
  String name;
  String description;
  String version;

  Pubspec({
    required this.name,
    required this.description,
    required this.version,
  });

  factory Pubspec.fromJson(Map<String, dynamic> json) {
    return Pubspec(
      name: json['name'],
      description: json['description'],
      version: json['version'],
    );
  }
}

class LatestVersion {
  final String version;
  final Pubspec pubspec;
  final String publishedDate;

  LatestVersion({
    required this.version,
    required this.pubspec,
    required this.publishedDate,
  });

  DateTime? get publishedOn => DateTime.tryParse(publishedDate);

  factory LatestVersion.fromJson(Map<String, dynamic> json) {
    return LatestVersion(
      version: json['latest']['version'],
      pubspec: Pubspec.fromJson(json['latest']['pubspec']),
      publishedDate: json['latest']['published'],
    );
  }
}

class PackageDetails {
  String name;
  LatestVersion latestVersion;

  PackageDetails({
    required this.name,
    required this.latestVersion,
  });

  factory PackageDetails.fromJson(Map<String, dynamic> json) {
    return PackageDetails(
      name: json['name'],
      latestVersion: LatestVersion.fromJson(json),
    );
  }
}
