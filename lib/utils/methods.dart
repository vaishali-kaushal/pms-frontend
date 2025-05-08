import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:performance_management_system/pms.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
//import 'package:pdf_compressor/pdf_compressor.dart';

Future<void> loadNetworkImage(String image) async {
  await loadAppImage(NetworkImage(image));
}

Future<void> loadAppImage(ImageProvider provider) {
  final config = ImageConfiguration(
    bundle: rootBundle,
    devicePixelRatio: 1,
    platform: defaultTargetPlatform,
  );
  final Completer<void> completer = Completer();
  final ImageStream stream = provider.resolve(config);

  late final ImageStreamListener listener;

  listener = ImageStreamListener((ImageInfo image, bool sync) {
    debugPrint("Image ${image.debugLabel} finished loading");
    completer.complete();
    stream.removeListener(listener);
  }, onError: (dynamic exception, StackTrace? stackTrace) {
    completer.complete();
    stream.removeListener(listener);
    FlutterError.reportError(FlutterErrorDetails(
      context: ErrorDescription('image failed to load'),
      library: 'image resource service',
      exception: exception,
      stack: stackTrace,
      silent: true,
    ));
  });

  stream.addListener(listener);
  return completer.future;
}

const platform = MethodChannel('device_id');

String getFileName(File file) {
  return path.basename(file.path);
}
String getUrlType(String url)  {
  String returnUrl="";
  Uri uri = Uri.parse(url);
  print(url);
  String typeString = uri.path.substring(uri.path.length - 3).toLowerCase();
  if (typeString == "jpg" || typeString == "jpeg" || typeString == "png") {
    returnUrl="image";
  }else if (typeString == "pdf") {
    returnUrl="pdf";
  } else {
    returnUrl="unknown";
  }
  print("return ${returnUrl}");
  return returnUrl;
}

/*Future<String?> compressPdf(String? file) async {
  if (file == null) {
    return null;
  }

  String outputPath = await getTempPath();

  await PdfCompressor.compressPdfFile(
      file,
      outputPath,
      CompressQuality.MEDIUM
  );
  return  outputPath;
}*/

Future<String> getTempPath() async {
  final outputDir = await getTemporaryDirectory();
  final outputFile = File('${outputDir.path}/compressed.pdf');

  return outputFile.path;
}

Future<File?> compressImage(File? file) async {
  if (file == null) {
    return null;
  }
  Directory directory = await getTemporaryDirectory();
  var byte = await FlutterImageCompress.compressWithList(
    file.absolute.readAsBytesSync(),
    quality: 70,
    rotate: 0,
  );


  File result = File("${directory.path}/${DateTime.now().microsecondsSinceEpoch}.jpg")
    ..writeAsBytesSync(byte);

  final size = result.lengthSync();

  if (size > (1024*1024)) {
    return await compressImage(result);
  } else {
    return result;
  }
}