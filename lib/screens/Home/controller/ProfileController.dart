import 'package:performance_management_system/pms.dart';

class ProfileController extends GetxController {
  bool loader = false;
  ProfileData? profileData;
  String years = '';
  String months = '';
  String resume = '';

  Future<void> fetchProfileDetail() async {
    if (!loader) {
      loader = true;
      update(['home']); // Show loader on UI
    }

    try {
      final response = await HttpService.getApi(url: EndPoints.userDetail);

      if (response != null && response.statusCode == 200) {
        final result = profileModelFromJson(response.body);
        profileData = result.data;

        // Set resume full URL if present
        if (profileData?.resume != null && profileData!.resume!.isNotEmpty) {
          resume = "${EndPoints.baseUrlImages}${profileData!.resume}";
        }

        // Parse experience into years and months
        final experience = profileData?.experience?.toString() ?? '';
        final parts = experience.split(',');
        if (parts.isNotEmpty) {
          years = parts[0].trim().replaceAll(RegExp(r'[^0-9]'), '');
          if (parts.length > 1) {
            months = parts[1].trim().replaceAll(RegExp(r'[^0-9]'), '');
          }
        }
      }
    } catch (e) {
      print("Error fetching profile: $e");
    } finally {
      loader = false;
      update(['home']); // Update UI with data
    }
  }

}
