class PublisherID {
  String publisherID;
  PublisherID({required this.publisherID});

  factory PublisherID.fromJson(Map<String, dynamic> json) {
    return PublisherID(
      publisherID: json['publisherId'] ?? 'N/A',
    );
  }
}
