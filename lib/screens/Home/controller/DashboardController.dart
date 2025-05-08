import 'package:performance_management_system/pms.dart';

class DashboardController extends GetxController {
  bool loader = false;
  bool isProjectLoaded = false;

  int selectedIndex = 0;
  bool showTaskList = false;
  String selectedProjectId = "";
  ProjectsData? projectDetails;
  late MilestoneData milestoneDetails;
  late projectDetailModel model;
  String? remarks;
  DateTime? nextDueDate;

  @override
  void onInit() {
    super.onInit();
  }

  final List<String> menuTitles = [
    "Dashboard",
    "Users",
    "Projects",
    "Milestones",
    "Tasks",
   // "Reports",
    "Performance",
    "Self Appraisal",
    "Review Appraisal",
    "My Profile"
  ];

  void changeTab(int index) {
    selectedIndex = index;
    showTaskList = false; // Close detail view
    update(['home']);
  }
  /// Fetch project details
  Future loadProjectDetails(String? id) async {
    isProjectLoaded = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      update(['home']);
    });

    print("ID::::, ${id.toString()}");

    try {
      final response = await HttpService.getDirectApi(
        url: '${EndPoints.projectDetails}/$id',
      );
      print("Project Detail: ${response?.body}");

      if (response != null && response.statusCode == 200) {
        model = projectDetailModelFromJson(response.body);

      }
    } catch (e) {
      throw Exception(e.toString());
    }

    isProjectLoaded = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      update(['home']);
    });
    return [];
  }

}
