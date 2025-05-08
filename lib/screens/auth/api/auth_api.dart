import 'package:performance_management_system/pms.dart';

class AuthApi{

  static Future<LoginModel?> userLogin(Map<String, String> loginBody) async {
    try {
      final response = await HttpService.postApi(
          url: EndPoints.login,
          isContentType: true,
          body: loginBody
      );
      print("loginBody: $loginBody");
      print("login: ${response?.body}");

      if (response != null && response.statusCode == 200) {
        final responseBody = response.body;
        try {
          LoginModel model = loginModelFromJson(responseBody);
          return model;
        } catch (e) {
          throw Exception("Unexpected response format: $responseBody");
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return null;
  }

  static Future<AddMilestoneModel?> addMilestone(Map<String, String> milestoneBody) async {
    try {
      final response = await HttpService.postApi(
          url: EndPoints.addMilestone,
          isContentType: true,
          body: milestoneBody
      );
      print("milestoneBody: $milestoneBody");
      print("Add Milestone: ${response?.body}");

      if (response != null && response.statusCode == 200) {
        final responseBody = response.body;
        try {
          AddMilestoneModel model = addMilestoneModelFromJson(responseBody);
          return model;
        } catch (e) {
          throw Exception("Unexpected response format: $responseBody");
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return null;
  }

  static Future<updateTaskStatusModel?> updateTaskStatus(Map<String, String> milestoneBody) async {
    try {
      final response = await HttpService.postApi(
          url: EndPoints.updateTaskStatus,
          isContentType: true,
          body: milestoneBody
      );
      print("updateTaskStatus: $milestoneBody");
      print("updateTaskStatus: ${response?.body}");

      if (response != null && response.statusCode == 200) {
        final responseBody = response.body;
        try {
          updateTaskStatusModel model = updateTaskStatusModelFromJson(responseBody);
          return model;
        } catch (e) {
          throw Exception("Unexpected response format: $responseBody");
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return null;
  }
}
