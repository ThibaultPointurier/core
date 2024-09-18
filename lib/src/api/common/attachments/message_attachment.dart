import 'package:mineral/api.dart';

class MessageAttachment {
  Snowflake id;
  String filename;
  String? description;
  String? contentType;
  int size;
  String url;
  String proxyUrl;
  int? height;
  int? width;
  bool private;

  MessageAttachment({
    required this.id,
    required this.filename,
    required this.description,
    required this.contentType,
    required this.size,
    required this.url,
    required this.proxyUrl,
    required this.height,
    required this.width,
    required this.private,
  });
}