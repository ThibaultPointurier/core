import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:path/path.dart';

/// Attachment [File] builder
class AttachmentBuilder {
  /// Content property of this.
  List<int> content;

  /// Filename property of this.
  String? filename;

  /// Description property of this.
  String? description;

  AttachmentBuilder(this.content, {
    this.filename,
    this.description,
  });

  /// Create a [MultipartFile] from the attachment
  MultipartFile toFile(int id) => MultipartFile.fromBytes('files[$id]', content, filename: filename, contentType: null);

  Object toJson({int? id}) => {
    'id': id,
    'filename': filename,
    'description': description,
  };

  factory AttachmentBuilder.file(String path, {String? description, String? overrideFilename}) {
    final File file = File(join(Directory.current.path, path));
    return AttachmentBuilder(file.readAsBytesSync(),
        filename: overrideFilename ?? basename(file.path),
        description: description);
  }

  factory AttachmentBuilder.base64(String content, {required String filename, String? description}) {
    return AttachmentBuilder(base64Decode(content), filename: filename, description: description);
  }
}