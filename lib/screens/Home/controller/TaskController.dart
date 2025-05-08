import 'package:performance_management_system/pms.dart';

class TaskController extends GetxController {
  int currentPage = 0;
  List<int> rowsPerPageOptions = [5, 10, 20, 50];
  int rowsPerPage = 10;
  String? remarks;
  DateTime? nextDueDate;
  String searchQuery = '';
  List<TaskData> allTasks = [];       // All fetched tasks
  List<TaskData> paginatedTasks = []; // Final data for UI

  // Get filtered tasks based on search query
  List<TaskData> get filteredTasks {
    if (searchQuery.isEmpty) return allTasks;
    return allTasks.where((task) =>
    (task.name ?? '').toLowerCase().contains(searchQuery) ||
        (task.projectName ?? '').toLowerCase().contains(searchQuery) ||
        (task.assignedTo ?? '').toLowerCase().contains(searchQuery)
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
    paginatedTasks = filtered.sublist(start, end);
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
  void setTasks(List<TaskData> tasks) {
    allTasks = tasks;
    currentPage = 0;
    _applySearchAndPagination();
    update(['home']);
  }

  // Fetch tasks from API
  Future fetchTasks(String? projectId) async {
    loader = true;
    update(['home']);

    Map<String, String> taskBody = {
      "project_id": projectId ?? "",
    };

    try {
      final response = await HttpService.getApi(url: EndPoints.getTasks, queryParams: taskBody);
      if (response != null && response.statusCode == 200) {
        final tasksModel = tasksModelFromJson(response.body);
        final fetched = tasksModel.data ?? [];
        setTasks(fetched); // <- Use new method to set tasks and paginate
      }
    } catch (e) {
      throw Exception(e.toString());
    }

    loader = false;
    update(['home']);
  }

/*  Future fetchTasks(String? projectId) async {
    loader = true;
    update(['home']);

    Map<String, String> taskBody = {
      "project_id": projectId ?? "",
    };

    try {
      final response = await HttpService.getApi(url: EndPoints.getTasks, queryParams: taskBody);
      print("Tasks List: ${response?.body}");
      if (response != null && response.statusCode == 200) {
        final tasksModel = tasksModelFromJson(response.body);
        tasksList = tasksModel.data ?? [];
        paginatedTasks = tasksList;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    loader = false;
    update(['home']);

    return [];
  }*/

  // Use this for display
  String get pageInfoText => 'Page ${currentPage + 1} of $totalPages';



  void search(String query) {
    searchQuery = query.toLowerCase();
    _applySearchAndPagination();
    update(['home']);
  }




  bool loader = false;
  final List<Map<String, String>> taskData = [
    {
      "projectName": "Haryana System",
      "title": "Design Login Page",
      "assignedTo": "User1, User3",
      "priority": "High",
      "status": "In Progress",
      "statusColor": "0xFF2196F3",
      "startDate": "01-04-2025",
      "dueDate": "05-04-2025",
    },
    {
      "projectName": "Haryana System",
      "title": "API Integration",
      "assignedTo": "User2",
      "priority": "Medium",
      "status": "Assigned",
      "statusColor": "0xFFFF9800",
      "startDate": "03-04-2025",
      "dueDate": "07-04-2025",
    },
  ];
  String taskTitle = '';
  String taskDescription = '';
  DateTime? startDate;
  DateTime? dueDate;
  String? priority;

  List<String> users = ['Ankit', 'Sneha', 'Ravinder', 'Vishal'];

  List<Map<String, dynamic>> fetchedProjects = [];
  String selectedProjectId = '';
  String selectedMilestoneId = '';

  List<ProjectsData> projectsList = [];
  List<MilestoneData> milestoneList = [];
  List<TeamMemberData> teamMemberList = [];
  String selectedProject = '';
  String selectedMemberId = '';

  // Variables to hold validation error messages
  String? taskTitleError;
  String? priorityError;
  String? remarksError;
  String? selectedProjectError;
  String? selectedMilestoneIdError;
  String? assignedMembersError;
  String? startDateError;
  String? dueDateError;
  String? taskDescriptionError;


  Future<void> selectDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
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

  Future fetchMilestones(String? projectId) async {
    loader = true;
    update(['add_dialog']);

    Map<String, String> taskBody = {
      "project_id": projectId ?? "",
    };

    try {
      final response = await HttpService.getApi(url: EndPoints.getMilestone, queryParams: taskBody);
      print("Tasks List: ${response?.body}");
      if (response != null && response.statusCode == 200) {
        final milestoneModel = milestoneModelFromJson(response.body);
        milestoneList = milestoneModel.data ?? [];
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    loader = false;
    update(['add_dialog']);

    return [];
  }

   updateTaskStatus(String projectId, String taskId, String newStatus, String endDate) {
    final index = paginatedTasks.indexWhere((task) => task.id.toString() == taskId);
    print("index $index");
    if (index != -1) {
      updateTaskStatusApi(index, projectId, taskId, newStatus, endDate);
    }
  }

  bool validateTaskForm() {
    taskTitleError = taskTitle.isEmpty ? "Please enter task title" : null;
    selectedProjectError = (selectedProjectId == null || selectedProjectId!.isEmpty)
        ? "Please select project"
        : null;
    selectedMilestoneIdError = (selectedMilestoneId == null || selectedMilestoneId!.isEmpty)
        ? "Please select milestone"
        : null;
    assignedMembersError = (selectedMemberId == null || selectedMemberId!.isEmpty) ? "Please assign member" : null;
    startDateError = startDate == null ? "Please select start date" : null;
    dueDateError = dueDate == null ? "Please select due date" : null;
    taskDescriptionError = taskDescription.isEmpty ? "Please enter task description" : null;
    priorityError = priority == null ? "Please select priority" : null;


    // Check if dueDate is before startDate
    if (startDate != null && dueDate != null && dueDate!.isBefore(startDate!)) {
      dueDateError = "Due date must be after start date";
    }

    update(['add_dialog']);

    return taskTitleError == null &&
        selectedProjectError == null &&
        assignedMembersError == null &&
        startDateError == null &&
        dueDateError == null &&
        taskDescriptionError == null&&
        priorityError == null;
  }





  Future fetchProjects() async {
    loader = true;
    update(['home']);

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
      }
    } catch (e) {
      throw Exception(e.toString());
    }

    loader = false;
    update(['home']);
    return [];
  }


  FileModel? selectedFileModel;

  Future<void> pickFile() async {
    final file = await FilePickerHelper.pickSingleFile(
      keyName: "task_document", // dynamic key here
    );

    if (file != null) {
      selectedFileModel = file;
      update(['add_dialog']);
    }
  }


  Future<void> addTask(BuildContext context, String projectId) async {
    if (validateTaskForm()) {
      loader = true;
      update(['home']);

      Map<String, String> addTaskBody = {
        "project_id": projectId,
        "milestone_id": selectedMilestoneId,
        "name": taskTitle.trim(),
        "start_date": startDate.toString(),
        "end_date": dueDate.toString(),
        "assigned_to": selectedMemberId.toString(),
        "priority": priority.toString(),
        "description": taskDescription.toString(),
      };

      try {
        final response = await HttpService.postMultipartApi(
          url: EndPoints.addTask,
          body: addTaskBody,
          files: selectedFileModel != null ? [selectedFileModel!] : [],
        );

        if (response != null && response.statusCode == 200) {
          final model = addProjectModelFromJson(response.body);
          if (model.status == "success") {
            toastMsg(model.message ?? "Task added successfully.");
            Navigator.pop(context);
            fetchTasks("");
          } else {
            toastMsg("Something went wrong.");
          }
        } else {
          toastMsg("Failed to upload task.");
        }
      } catch (e) {
        debugPrint("AddTask Error: $e");
        toastMsg("Upload error: $e");
      }

      loader = false;
      update(['home']);
    }
  }

  /*addTask(BuildContext context, String projectId) async {
    if(validateTaskForm()){
      FocusManager.instance.primaryFocus?.unfocus();
      loader = true;
      update(['home']);
      Map<String,String> addTaskBody = {
        "project_id": projectId,
        "milestone_id": selectedMilestoneId,
        "name": taskTitle.trim(),
        "start_date": startDate.toString().trim(),
        "end_date": dueDate.toString().trim(),
        "assigned_to": selectedMemberId.toString().trim(),
        "priority": priority.toString().trim(),
        "description": taskDescription.toString().trim(),
      };

      debugPrint("Sending task data: $addTaskBody");

      try {
        AddProjectModel? model = await AuthApi.addTask(taskBody: addTaskBody,
          fileData: selectedFileModel != null ? [selectedFileModel!] : [],
        );

        if (model != null) {
          if (model.status == "success") {
            toastMsg(model.message.toString());
            Navigator.pop(context);
            fetchTasks("");
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

  Future fetchMembers(String projectId) async {
    loader = true;
    update(['add_dialog']);

    Map<String,String> membersBody = {
      "project_id": projectId,
    };

    debugPrint("Fetch Members: $membersBody");

    try {
      final response = await HttpService.getApi(url: EndPoints.getMembers, queryParams: membersBody);
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

  void resetTaskForm() {
    taskTitle = '';
    //selectedProjectId = '';
    selectedMilestoneId = '';
    selectedMemberId = '';
    priority = null;
    taskDescription = '';
    startDate = null;
    dueDate = null;

    // Reset error texts
    taskTitleError = null;
    startDateError = null;
    dueDateError = null;
    selectedProjectError= null;
    priorityError=null;
    assignedMembersError = null;
    taskDescriptionError = null;

    update(['add_dialog']);
  }

  updateTaskStatusApi(int index, String projectId, String taskId, String status, String endDate) async {
      FocusManager.instance.primaryFocus?.unfocus();
      loader = false;
      update(['home']);
      Map<String,String> updateTaskBody = {
        "project_id": projectId,
        "task_id": taskId,
        "status": status,
        "remarks": remarks ?? '',
        "due_date": endDate
      };
      try {
        updateTaskStatusModel? model = await AuthApi.updateTaskStatus(updateTaskBody);

        print(model);

        if (model != null) {
          if (model.status == "success") {
            toastMsg(model.message.toString());
            paginatedTasks[index].status = status;
            update(['home']);
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











    //performace filters
  // Filters
  String? selectedUser;
  String? selectedYear;
  String? selectedFromMonth;
  String? selectedToMonth;

  // Data sources for dropdowns
  List<String> availableUsers = ['User A', 'User B'];
  List<String> availableProjects = ['Project X', 'Project Y'];
  List<String> availableYears = [
    for (int i = 2020; i <= DateTime.now().year; i++) i.toString()
  ];
  List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  String selectedFilterType = 'Monthly';
  DateTime? selectedFilterMonth;

  String? selectedProjectName;
  DateTimeRange? dateRange;

  void setFilterDateRange(DateTime baseDate) {
    selectedFilterMonth = baseDate;

    switch (selectedFilterType) {
      case 'Monthly':
        final start = DateTime(baseDate.year, baseDate.month, 1);
        final end = DateTime(baseDate.year, baseDate.month + 1, 0);
        dateRange = DateTimeRange(start: start, end: end);
        break;

      case 'Quarterly':
        final quarter = ((baseDate.month - 1) ~/ 3) + 1;
        final startMonth = (quarter - 1) * 3 + 1;
        final start = DateTime(baseDate.year, startMonth, 1);
        final end = DateTime(baseDate.year, startMonth + 3, 0);
        dateRange = DateTimeRange(start: start, end: end);
        break;

      case '6 Months':
        final start = DateTime(baseDate.year, baseDate.month - 5, 1);
        final end = DateTime(baseDate.year, baseDate.month + 1, 0);
        dateRange = DateTimeRange(start: start, end: end);
        break;

      case '1 Year':
        final start = DateTime(baseDate.year, baseDate.month - 11, 1);
        final end = DateTime(baseDate.year, baseDate.month + 1, 0);
        dateRange = DateTimeRange(start: start, end: end);
        break;
    }

    applyFilters();
  }

  int? getMonthNumber(String? monthName) {
    if (monthName == null) return null;

    const months = {
      'January': 1,
      'February': 2,
      'March': 3,
      'April': 4,
      'May': 5,
      'June': 6,
      'July': 7,
      'August': 8,
      'September': 9,
      'October': 10,
      'November': 11,
      'December': 12,
    };

    return months[monthName];
  }

  void applyFilters() {
    int? selectedYearInt = int.tryParse(selectedYear ?? '');
    int? fromMonthInt = getMonthNumber(selectedFromMonth);
    int? toMonthInt = getMonthNumber(selectedToMonth);

    print("Selected Year: $selectedYearInt");
    print("From Month: $fromMonthInt, To Month: $toMonthInt");

    paginatedTasks = allTasks.where((task) {
      // Parse start and end dates
      DateTime? start;
      DateTime? end;

      try {
        start = DateTime.parse(task.startDate!);
        end = DateTime.parse(task.endDate!);
      } catch (e) {
        print("Error parsing dates for task: ${task.name}");
        return false;
      }

      final startYear = start.year;
      final endYear = end.year;
      final startMonth = start.month;
      final endMonth = end.month;

      final matchUser = selectedUser == null || task.assignedTo == selectedUser;
      final matchProject = selectedProjectName == null || task.projectName == selectedProjectName;

      final matchYear = selectedYearInt == null || startYear == selectedYearInt || endYear == selectedYearInt;

      // Match if any part of the task duration falls within the selected month range
      final matchMonth = (fromMonthInt == null && toMonthInt == null) ||
          (fromMonthInt != null && toMonthInt != null &&
              ((startMonth >= fromMonthInt && startMonth <= toMonthInt) ||
                  (endMonth >= fromMonthInt && endMonth <= toMonthInt)));

      return matchUser && matchProject && matchYear && matchMonth;
    }).toList();

    print("Filtered task count: ${paginatedTasks.length}");

    currentPage = 0;
    update(['home']);
  }

  void resetFilters() {
    selectedUser = null;
    selectedProjectName = null;
    dateRange = null;
    paginatedTasks = allTasks;
    currentPage = 0;
    selectedYear = null;
    selectedFromMonth = null;
    selectedToMonth = null;
    update(['home']);
  }

  void setYearFilter(String? year) {
    selectedYear = year;
    currentPage = 0;
    applyFilters();
  }

  void setFromMonthFilter(String? month) {
    selectedFromMonth = month;
    currentPage = 0;
    applyFilters();
  }

  void setToMonthFilter(String? month) {
    selectedToMonth = month;
    currentPage = 0;
    applyFilters();
  }

  int monthIndex(String monthName) => months.indexOf(monthName);

}
