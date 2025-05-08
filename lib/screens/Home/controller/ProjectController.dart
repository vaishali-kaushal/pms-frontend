import 'dart:io';
import 'package:performance_management_system/pms.dart';

class ProjectController extends GetxController {
  bool loader = false;
  List<DepartmentData> departmentList = [];
  List<TeamLeadData> techLeadList = [];
  List<ProjectsData> projectsList = [];
  List<String> fetchedDepartments = [];

  String? projectTitleError;
  String? departmentTypeError;
  String? departmentNameError;
  String? startDateError;
  String? endDateError;
  String? projectOverviewError;
  String? teamLeadError;

  String projectTitle = '';
  String? departmentType;
  String? departmentName;
  DateTime? startDate;
  DateTime? endDate;
  String projectOverview = '';
  PlatformFile? uploadedFile;
  String? selectedTeamLead;
  File? selectedFile;

  final Map<String, List<String>> departmentData = {
    "Board": ["Haryana Staff Selection Board", "Board of School Education"],
    "Department": ["Haryana State Industrial", "Haryana Roadways"],
  };
  TextEditingController searchController = TextEditingController();
  List<String> assignedMembers = [];
  List<TeamMemberData> teamMemberList = [];
  List<String> selectedMembers = [];


  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void resetForm() {
    projectTitle = '';
    projectOverview = '';
    selectedTeamLead = null;
    departmentType = null;
    departmentName = null;
    startDate = null;
    endDate = null;
    searchController.clear();

    selectedMembers = [];
    assignedMembers = [];

    projectTitleError = null;
    departmentTypeError= null;
    departmentNameError= null;
    startDateError= null;
    endDateError= null;
    projectOverviewError= null;
    teamLeadError= null;

    update(['add_dialog']);
  }

  Future fetchMembers() async {
    loader = true;
    update(['add_dialog']);

    try {
      final response = await HttpService.getApi(url: EndPoints.getMembers);
      print("tech members: ${response?.body}");
      if (response != null && response.statusCode == 200) {
        final issuesModel = teamMemberModelFromJson(response.body);
        teamMemberList = issuesModel.data ?? [];

      }
    } catch (e) {
      throw Exception(e.toString());
    }
    loader = false;
    update(['add_dialog']);

    return [];
  }

  Future<void> selectDate(BuildContext context, bool isStartDate) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      if (isStartDate) {
        startDate = picked;
      } else {
        endDate = picked;
      }
      update(['add_dialog']);
    }
  }

  FileModel? selectedFileModel;

  Future<void> pickFile() async {
    final file = await FilePickerHelper.pickSingleFile(
      keyName: "file", // dynamic key here
    );

    if (file != null) {
      selectedFileModel = file;
      update(['add_dialog']);
    }
  }

  bool validateProjectForm() {
    projectTitleError = projectTitle.isEmpty ? "Please enter project title" : null;
    departmentTypeError = departmentType == null ? "Please select department type" : null;
    departmentNameError = departmentName == null ? "Please select department name" : null;
    startDateError = startDate == null ? "Please select start date" : null;
    endDateError = endDate == null ? "Please select end date" : null;
    projectOverviewError = projectOverview.isEmpty ? "Please enter project overview" : null;
    teamLeadError = selectedTeamLead == null ? "Please select team lead" : null;

    // Check if endDate is before startDate
    if (startDate != null && endDate != null && endDate!.isBefore(startDate!)) {
      endDateError = "Delivery date must be after start date";
    }

    update(['add_dialog']);
    return projectTitleError == null &&
        departmentTypeError == null &&
        departmentNameError == null &&
        startDateError == null &&
        endDateError == null &&
        projectOverviewError == null &&
        teamLeadError == null;
  }

  Future fetchDepartments(String selectedType) async {
    loader = true;
    update(['add_dialog']);

    selectedType = selectedType == "Board"
        ? "B"
        : selectedType == "Department"
        ? "D"
        : "";
    Map<String, String> departmentBody = {
      "type": selectedType,
    };

    try {
      final response = await HttpService.getApi(url: EndPoints.departmentList, queryParams: departmentBody);
      print("issuesList: ${response?.body}");
      if (response != null && response.statusCode == 200) {
        final issuesModel = departmentModelFromJson(response.body);
        departmentList = issuesModel.data ?? [];
        fetchedDepartments = departmentList.map((e) => e.name ?? "").toList();

      }
    } catch (e) {
      throw Exception(e.toString());
    }
    loader = false;
    update(['add_dialog']);

    return [];
  }

  Future fetchTechLead() async {
      loader = true;
      update(['add_dialog']);

      try {
        final response = await HttpService.getApi(url: EndPoints.getTechLead);
        print("tech lead: ${response?.body}");
        if (response != null && response.statusCode == 200) {
          final issuesModel = teamLeadModelFromJson(response.body);
          techLeadList = issuesModel.data ?? [];

        }
      } catch (e) {
        throw Exception(e.toString());
      }
      loader = false;
      update(['add_dialog']);

      return [];
    }

  Future fetchProjects() async {
    loader = true;
    update(['home']);

    try {
      final response = await HttpService.getApi(url: EndPoints.getProjects);
      print("Projects List: ${response?.body}");
      if (response != null && response.statusCode == 200) {
        final projectsModel = projectsModelFromJson(response.body);
       // projectsList = projectsModel.data ?? [];
        final fetched = projectsModel.data ?? [];
        setTasks(fetched); // <- Use new method to set tasks and paginate
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    loader = false;
    update(['home']);

    return [];
  }

  Future<void> addProject(BuildContext context) async {
    if (validateProjectForm()) {
      FocusManager.instance.primaryFocus?.unfocus();
      loader = true;
      update(['home']);

      Map<String, String> addProjectBody = {
        "name": projectTitle.trim(),
        "team_lead_id": selectedTeamLead.toString().trim(),
        "project_members": selectedMembers.toString().trim(),
        "department_name": departmentName.toString().trim(),
        "department_type": departmentType.toString().trim(),
        "date_completion": endDate.toString().trim(),
        "description": projectOverview.toString().trim(),
        "start_date": startDate.toString().trim(),
      };

      debugPrint("Sending project data: $addProjectBody");

      try {
        final response = await HttpService.postMultipartApi(
          url: EndPoints.addProject,
          body: addProjectBody,
          files: selectedFileModel != null ? [selectedFileModel!] : [],
        );

        if (response != null && response.statusCode == 200) {
          final model = addProjectModelFromJson(response.body); // <- your parser here

          if (model.status == "success") {
            toastMsg(model.message ?? "Project added successfully.");
            Navigator.pop(context);
            fetchProjects();
          } else {
            toastMsg("Something went wrong.");
          }
        } else {
          toastMsg("Failed to upload project.");
        }
      } catch (e) {
        debugPrint("Upload error: $e");
        toastMsg("Upload error: $e");
      }

      loader = false;
      update(['home']);
    }
  }

  /*addProject(BuildContext context) async {
    if(validateProjectForm()){
      FocusManager.instance.primaryFocus?.unfocus();
      loader = true;
      update(['home']);
      Map<String,String> addProjectBody = {
        "name": projectTitle.trim(),
        "team_lead_id": selectedTeamLead.toString().trim(),
        "project_members": selectedMembers.toString().trim(),
        "department_name": departmentName.toString().trim(),
        "department_type": departmentType.toString().trim(),
        "date_completion": endDate.toString().trim(),
        "description": projectOverview.toString().trim(),
        "start_date": startDate.toString().trim(),
    };

      try {
        AddProjectModel? model = await AuthApi.addProject(
            projectBody: addProjectBody,
            fileData: [FileModel(keyName: "task_document", file: selectedFile)]);

        if (model != null) {
          if (model.status == "success") {
            toastMsg(model.message.toString());
            Navigator.pop(context);
            fetchProjects();
           // update(['home']);
          } else {
            toastMsg('something_went_wrong'.tr);
          }
        }else {
          toastMsg('something_went_wrong'.tr);
        }
      } catch (e) {
        debugPrint("Unexpected response format: ${e.toString()}");
      }
      loader = false;
      update(['home']);
    }
  }
*/
  String searchQuery = '';
  List<ProjectsData> allProjects = [];       // All fetched tasks
  List<ProjectsData> paginatedProjects = []; // Final data for UI
  int currentPage = 0;
  List<int> rowsPerPageOptions = [5, 10, 20, 50];
  int rowsPerPage = 10;

  // Get filtered tasks based on search query
  List<ProjectsData> get filteredTasks {
    if (searchQuery.isEmpty) return allProjects;
    return allProjects.where((project) =>
    (project.name ?? '').toLowerCase().contains(searchQuery) ||
        (project.name ?? '').toLowerCase().contains(searchQuery) ||
        (project.teamLeadName ?? '').toLowerCase().contains(searchQuery)
    ).toList();
  }

  // Get total number of pages based on filtered tasks
  int get totalPages {
    final totalItems = filteredTasks.length;
    return (totalItems / rowsPerPage).ceil().clamp(1, double.infinity).toInt();
  }

  // Filter tasks based on search
  void filterTasks(String query) {
    searchQuery = query.toLowerCase();
    currentPage = 0;
    _applySearchAndPagination();
    update(['home']);
  }

  // Change rows per page
  void changeRowsPerPage(int value) {
    rowsPerPage = value;
    currentPage = 0;
    _applySearchAndPagination();
    update(['home']);
  }

  // Apply filtering and pagination
  void _applySearchAndPagination() {
    final filtered = filteredTasks;
    final start = currentPage * rowsPerPage;
    final end = (start + rowsPerPage).clamp(0, filtered.length);
    paginatedProjects = filtered.sublist(start, end);
  }

  // Pagination functions
  void nextPage() {
    if ((currentPage + 1) < totalPages) {
      currentPage++;
      _applySearchAndPagination();
      update(['home']);
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      currentPage--;
      _applySearchAndPagination();
      update(['home']);
    }
  }

  // Call this after fetching tasks
  void setTasks(List<ProjectsData> projects) {
    allProjects = projects;
    currentPage = 0;
    _applySearchAndPagination();
    update(['home']);
  }
  // Use this for display
  String get pageInfoText => 'Page ${currentPage + 1} of $totalPages';



  void search(String query) {
    searchQuery = query.toLowerCase();
    _applySearchAndPagination();
    update(['home']);
  }
}