import 'dart:io' as io;
import 'dart:typed_data'; // <-- for Uint8List (web)

class FileModel {
  final String keyName;
  final io.File? file; // for mobile/desktop
  final Uint8List? fileBytes; // for web
  final String? fileName; // required for web

  FileModel({
    required this.keyName,
    this.file,
    this.fileBytes,
    this.fileName,
  });
}
