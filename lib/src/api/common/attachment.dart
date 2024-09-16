final class Attachment {
  final String name;
  final String url;
  final int size;
  final String? proxyUrl;
  final int? height;
  final int? width;

  Attachment(
      {required this.name,
      required this.url,
      required this.size,
      this.proxyUrl,
      this.height,
      this.width});
}

