import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:performance_management_system/pms.dart';
import 'package:http/http.dart' as http;

class HttpService {

  static Future<http.Response?> postApi({
    required String url,
    Map<String, String>? header,
    Map<String, String>? body,
    bool isContentType = false,
  }) async {
    try {
      header = header ?? {};
      debugPrint("Url = $url");
      debugPrint("Header = $header");
      debugPrint("Body = $body");

      // Set Content-Type header to application/x-www-form-urlencoded
      //header['Content-Type'] = 'application/x-www-form-urlencoded';
      header.addAll({
        if(PrefService.getString(PrefKeys.accessToken).isNotEmpty)
          'Authorization': "Bearer ${PrefService.getString(PrefKeys.accessToken)}",
          "Content-Type": 'application/x-www-form-urlencoded',
      });
      // Encode the body as form data
      final encodedBody = body != null ? body.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&') : null;

      final response = await http.post(Uri.parse(url), headers: header, body: encodedBody);
      print("header $header");

      bool isExpired = await isTokenExpire(response);
      if (!isExpired) {
        return response;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  static Future<http.Response?> postMultipartApi({
    required String url,
    required Map<String, String> body,
    required List<FileModel> files,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers['Authorization'] = "Bearer ${PrefService.getString(PrefKeys.accessToken)}";

      request.fields.addAll(body);

      for (var fileModel in files) {
        if (kIsWeb) {
          if (fileModel.fileBytes != null && fileModel.fileName != null) {
            request.files.add(http.MultipartFile.fromBytes(
              fileModel.keyName,
              fileModel.fileBytes! as List<int>,
              filename: fileModel.fileName!,
            ));
          }
        } else {
          if (fileModel.file != null) {
            request.files.add(await http.MultipartFile.fromPath(
              fileModel.keyName,
              fileModel.file!.path,
            ));
          }
        }
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      debugPrint("Upload Response: ${response.body}");

      return response;
    } catch (e) {
      debugPrint("Upload error: $e");
      return null;
    }
  }



  static Future<http.Response?> uploadFileWithDataApi({
    required String url,
    Map<String, String>? header,
    dynamic body,
    String? requestType,
    List<FileModel> fileData = const [],
    bool isContentType = false,
  }) async {
    header = header ?? appHeader(isContentType: isContentType);
    debugPrint("Url = $url");
    debugPrint("Header = $header");
    debugPrint("Body = $body");
    debugPrint("fileData = $fileData");
    try {
      var request =
      http.MultipartRequest(requestType ?? "POST", Uri.parse(url));
      request.fields.addAll(body ?? {});
      request.headers.addAll(header);
      for (FileModel element in fileData) {
        if (element.file == null || element.keyName == null) {
          continue;
        }
        request.files.add(
          http.MultipartFile(
            element.keyName ?? '',
            File(element.file!.path).readAsBytes().asStream(),
            File(element.file!.path).lengthSync(),
            filename: getFileName(element.file!)
          ),
        );
      }

      final http.StreamedResponse streamedResponse = await request.send();
      return await http.Response.fromStream(streamedResponse);
    } catch (e) {
      debugPrint(e.toString());
      // toastMsg(e.toString());
      return null;
    }
  }

  static Future<http.Response?> getDirectApi({
    required String url,
    Map<String, String>? headers,
    bool skipHeader = false,
    bool isContentType = false,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      if (!skipHeader) {
        headers = headers ?? appHeader(isContentType: isContentType);
      }
      debugPrint("Url = $url");
      debugPrint("Headers = $headers");
      debugPrint("Query Params = $queryParams");

      Uri uri;
      if (queryParams != null && queryParams.isNotEmpty) {
        uri = Uri.parse(url).replace(queryParameters: queryParams);
      } else {
        uri = Uri.parse(url);
      }

      final response = await http.get(uri, headers: headers);
      bool isExpired = await isTokenExpire(response);
      if (!isExpired) {
        return response;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  static Future<http.Response?> getApi({
    required String url,
    Map<String, String>? headers,
    bool skipHeader = false,
    bool isContentType = false,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      if (!skipHeader) {
        headers = headers ?? appHeader(isContentType: isContentType);
      }
      debugPrint("Url = $url");
      debugPrint("Headers = $headers");
      debugPrint("Query Params = $queryParams");

      // Construct the full URL with query parameters
      Uri uri = Uri.parse(url);
      if (queryParams != null) {
        uri = uri.replace(queryParameters: queryParams);
      }

      final response = await http.get(uri, headers: headers);
      bool isExpired = await isTokenExpire(response);
      if (!isExpired) {
        return response;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  static Map<String, String> appHeader({bool isContentType = false}) {
    if (PrefService.getString(PrefKeys.accessToken).isEmpty) {
      return {
        if(isContentType)
          "Content-Type":"application/json"
      };
    } else {
      return {
        'Authorization': "Bearer ${PrefService.getString(PrefKeys.accessToken)}",
        if(isContentType)
          "Content-Type":"application/json"
      };
    }
  }

  static Future<bool> isTokenExpire(http.Response response) async {
    if (response.statusCode == 401) {
      await PrefService.set(PrefKeys.accessToken, "");
      await PrefService.set(PrefKeys.isLogin, false);
      Get.offAll(() => LoginScreen());
      return true;
    } else {
      return false;
    }
  }

  static Future<http.Response?> postJsonApi({
    required String url,
    required Map<String, dynamic> body,
    Map<String, String>? header,
  }) async {
    try {
      header = header ?? {};
      header.addAll({
        "Content-Type": "application/json",
        if (PrefService.getString(PrefKeys.accessToken).isNotEmpty)
          'Authorization': "Bearer ${PrefService.getString(PrefKeys.accessToken)}",
      });

      debugPrint("POST JSON Url = $url");
      debugPrint("Headers = $header");
      debugPrint("JSON Body = ${jsonEncode(body)}");

      final response = await http.post(
        Uri.parse(url),
        headers: header,
        body: jsonEncode(body),
      );

      bool isExpired = await isTokenExpire(response);
      if (!isExpired) {
        return response;
      }
    } catch (e) {
      debugPrint("postJsonApi error: $e");
    }
    return null;
  }

}
