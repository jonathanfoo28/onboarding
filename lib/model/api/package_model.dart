class Package {
  String name;
  bool isFavourite;

  Package({required this.name, this.isFavourite = false});

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      name: json['package'],
    );
  }
}
