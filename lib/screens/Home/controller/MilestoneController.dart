import 'package:performance_management_system/pms.dart';

class MilestoneController extends GetxController {
  // Milestone form fields
  String milestoneTitle = '';
  String milestoneDescription = '';
  DateTime? startDate;
  DateTime? dueDate;
  String selectedProjectId = '';

  // Error texts
  String? milestoneTitleError;
  String? selectedProjectError;
  String? milestoneDescriptionError;
  String? startDateError;
  String? dueDateError;

  // Data lists
  List<MilestoneData> milestoneList = [];
  List<Map<String, dynamic>> fetchedProjects = [];
  List<ProjectsData> projectsList = [];
  ProjectsData? projectsData;

  // Loader
  bool loader = false;

  /// Fetch all milestones
  Future fetchMilestones(String? projectId) async {
    loader = true;
    update(['home']);

    Map<String, String> taskBody = {
      "project_id": projectId ?? "",
    };

    try {
      final response = await HttpService.getApi(url: EndPoints.getMilestone, queryParams: taskBody);
      print("Tasks List: ${response?.body}");
      if (response != null && response.statusCode == 200) {
        final milestoneModel = milestoneModelFromJson(response.body);
      //  milestoneList = milestoneModel.data ?? [];
        final fetched = milestoneModel.data ?? [];
        setTasks(fetched); // <- Use new method to set tasks and paginate
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    loader = false;
    update(['home']);

    return [];
  }

  /// Fetch all projects
  Future fetchProjects(int? id) async {
    loader = true;
    update(['home']);

    print("ID::::, ${id.toString()}");

    try {
      final response = await HttpService.getApi(url: EndPoints.getProjects);
      print("Projects List: ${response?.body}");

      if (response != null && response.statusCode == 200) {
        final projectsModel = projectsModelFromJson(response.body);
        projectsList = projectsModel.data ?? [];

        // 👇 fetchedProjects will now contain both ID and Name
        fetchedProjects = projectsList.map((e) {
          return {
            'id': e.id,
            'name': e.name ?? '',
          };
        }).toList();

        if (projectsModel.data != null) {
          projectsData = projectsModel.data!.firstWhere(
                (project) => project.id.toString() == id.toString(),
            orElse: () => ProjectsData(), // or handle null case safely
          );
        }

      }
    } catch (e) {
      throw Exception(e.toString());
    }

    loader = false;
    update(['home']);
    return [];
  }

  /// Reset the form
  void resetMilestoneForm() {
    milestoneTitle = '';
    milestoneDescription = '';
    startDate = null;
    dueDate = null;
    selectedProjectId = '';
    milestoneTitleError = null;
    selectedProjectError = null;
    milestoneDescriptionError = null;
    startDateError = null;
    dueDateError = null;

    update(['add_dialog']);
  }

  /// Form validation
  bool validateMilestoneForm() {
    bool isValid = true;

    if (milestoneTitle.isEmpty) {
      milestoneTitleError = "Please enter milestone title";
      isValid = false;
    } else {
      milestoneTitleError = null;
    }
    if (selectedProjectId.isEmpty) {
      selectedProjectError = "Please select project";
      isValid = false;
    } else {
      selectedProjectError = null;
    }

    if (milestoneDescription.isEmpty) {
      milestoneDescriptionError = "Please enter description";
      isValid = false;
    } else {
      milestoneDescriptionError = null;
    }

    if (startDate == null) {
      startDateError = "Please select start date";
      isValid = false;
    } else {
      startDateError = null;
    }

    if (dueDate == null) {
      dueDateError = "Please select due date";
      isValid = false;
    } else {
      dueDateError = null;
    }

    update(['add_dialog']);
    return isValid;
  }

  /// Select date (true for start, false for due)
  void selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      if (isStart) {
        startDate = picked;
      } else {
        dueDate = picked;
      }
      update(['add_dialog']);
    }
  }

  /// Add milestone
  addMilestone(BuildContext context, String projectId) async {
    if(validateMilestoneForm()){
      FocusManager.instance.primaryFocus?.unfocus();
      loader = true;
      update(['home']);
      Map<String,String> addMilestoneBody = {
        "name": milestoneTitle,
        "description": milestoneDescription,
        "start_date": startDate!.toIso8601String(),
        "end_date": dueDate!.toIso8601String(),
        "project_id": projectId,
      };
      try {
        AddMilestoneModel? model = await AuthApi.addMilestone(addMilestoneBody);

        if (model != null) {
          if (model.status == "success") {
            toastMsg(model.message.toString());
            fetchMilestones("");
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


  String searchQuery = '';
  List<MilestoneData> allMilestones = [];       // All fetched tasks
  List<MilestoneData> paginatedMilestones = []; // Final data for UI
  int currentPage = 0;
  List<int> rowsPerPageOptions = [5, 10, 20, 50];
  int rowsPerPage = 10;

  // Get filtered tasks based on search query
  List<MilestoneData> get filteredTasks {
    if (searchQuery.isEmpty) return allMilestones;
    return allMilestones.where((project) =>
    (project.name ?? '').toLowerCase().contains(searchQuery)
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
    paginatedMilestones = filtered.sublist(start, end);
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
  void setTasks(List<MilestoneData> projects) {
    allMilestones = projects;
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

