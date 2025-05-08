import 'dart:convert';
import 'package:performance_management_system/pms.dart';

class SelfAppraisalController extends GetxController {
  bool _isInitialized = false;

  @override
  void onInit() {
    super.onInit();
    if (!_isInitialized) {
      initialize();
      fetchProjects();
      fetchSelfTasks(true);
      _isInitialized = true;
    }
  }

  String resourceName = '';
  String resourceId = '';
  String positionName = '';
  String dob = '';
  String qualification = '';
  String dojPresent = '';
  String dojDept = '01-10-2020';
  String reportingOfficer = '';
  String reviewingOfficer = '';
  String reportingOfficerId = '';
  String reviewingOfficerId = '';
  String acceptingOfficer = '';
  String appraisalId = '';

  int currentPage = 0;
  List<int> rowsPerPageOptions = [5, 10, 20, 50];
  int rowsPerPage = 10;
  String? remarks;
  DateTime? nextDueDate;
  FileModel? selectedFileModel;
  String searchQuery = '';
  List<SelfTaskData> allTasks = [];       // All fetched tasks
  List<SelfTaskData> paginatedTasks = []; // Final data for UI


  List<SelfTaskModel> allSelfTasks = [];
  List<SelfTaskModel> filteredSelfTasks = [];
  String selectedYear = DateTime.now().year.toString();

  List<String> availableYears = [
    for (int i = 2020; i <= DateTime.now().year; i++) i.toString()
  ];

  Future<void> initialize() async {
    setYearFilter(DateTime.now().year.toString());
  }

  void setYearFilter(String? year) {
    selectedYear = year!;
    currentPage = 0;
   // applyFilters();
    fetchSelfTasks(false);
  }

  Future<void> pickFile() async {
    final file = await FilePickerHelper.pickSingleFile(
      keyName: "file",
    );

    if (file != null) {
      selectedFileModel = file;
      update(['add_dialog']);
    }
  }


  void applyFilters() {
    int? selectedYearInt = int.tryParse(selectedYear ?? '');

    print("Selected Year: $selectedYearInt");

    paginatedTasks = allTasks.where((task) {

      final startYear = int.tryParse("2025");

      final matchYear = selectedYearInt == null || startYear == selectedYearInt;

      return matchYear;
    }).toList();

    print("Filtered task count: ${paginatedTasks.length}");

    currentPage = 0;
    update(['home']);
  }

  // Get filtered tasks based on search query
  List<SelfTaskData> get filteredTasks {
    if (searchQuery.isEmpty) return allTasks;
    return allTasks.where((task) =>
    (task.user?.name ?? '').toLowerCase().contains(searchQuery)
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
  void setTasks(List<SelfTaskData> tasks) {
    allTasks = tasks;
    currentPage = 0;
    _applySearchAndPagination();
    update(['home']);
  }

  bool isReportingFilled = false;
  bool isReportingFormNotFilled = false;
  bool isReviewingFilled = false;
  bool isReviewingFormNotFilled = false;

  // Fetch tasks from API
  Future fetchSelfTasks(bool isload) async {
    loader = isload;
    update(['home']);
    Map<String,String> taskBody = {
      "year": selectedYear.toString().trim(),
    };

    try {
      final response = await HttpService.getApi(url: EndPoints.selfTasksList, queryParams: taskBody);
      if (response != null && response.statusCode == 200) {
        final tasksModel = selfTasksModelFromJson(response.body);
        final fetched = tasksModel.data ?? [];
        setTasks(fetched); // <- Use new method to set tasks and paginate

        final model = selfTasksModelFromJson(response.body);
        metricsList = model.data
            ?.expand<UserMetricsData>((task) => task.section2?.metricsData ?? [])
            .toList() ?? [];

        isReportingFilled = metricsList.every(
              (e) => (e.reportingOfficerRating ?? 0) > 0,
        );

        isReviewingFilled = metricsList.every(
              (e) => (e.reviewingOfficerRating ?? 0) > 0,
        );


        if (model.data != null && model.data!.isNotEmpty) {
          final userDetail = model.data!.first.user;

          resourceName = userDetail?.name ?? '';
          resourceId = userDetail?.id?.toString() ?? '';
          positionName = userDetail?.designation ?? '';
          qualification = userDetail?.employer ?? '';
          reportingOfficer = userDetail?.reportingOfficer ?? '';
          reviewingOfficer = userDetail?.reviewingOfficer ?? '';
          reportingOfficerId = userDetail?.reportingOfficerId.toString() ?? '';
          reviewingOfficerId = userDetail?.reviewingOfficerId.toString() ?? '';
          acceptingOfficer = ''; // not available in your model
          dob = userDetail?.dob ?? ''; // not available in your model
          dojPresent = userDetail?.doj ?? ''; // not available in your model

          //dojDept = ''; // not available in your model

          final section1 = model.data!.first.section1;

          workDone = section1?.workDone ?? '';
          skills = section1?.skillsUpgrade ?? '';
          exceptionWork = section1?.exceptionalWork ?? '';
          improvingSkills = section1?.improvementPlan ?? '';
          helpNeeded = section1?.helpNeeded ?? '';
          professionalGoals = section1?.professionalGoals ?? '';
          measureProgress = section1?.measureProgress ?? '';
          alignWithTeamGoals = section1?.alignWithTeamGoals ?? '';

          final section3 = model.data!.first.section3;

          if(section3!=null){
            strength = section3.strength ?? '';
            weaknesses = section3.weaknesses ?? '';
            utilization = section3.utilization ?? '';
            goalMeasure = section3.goalMeasure ?? '';
            goalProgressMeasure = section3.goalProgressMeasure ?? '';
            goalStatus = section3.goalStatus ?? '';
            upskillRecommend = section3.upskillRecommend ?? '';
          }else{
            isReportingFormNotFilled = true;
          }

          final section4 = model.data!.first.section4;
          if(section4!=null) {
            reviewAgreementString = section4.reviewAgreement ?? '';
            reviewDifference = section4.reviewDifference ?? '';
            reviewComments = section4.reviewComments ?? '';
            reviewOverall = section4.reviewOverall ?? '';
          }else{
            isReviewingFormNotFilled = true;
          }
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }

    loader = false;
    update(['home']);
  }

  // Use this for display
  String get pageInfoText => 'Page ${currentPage + 1} of $totalPages';

  void search(String query) {
    searchQuery = query.toLowerCase();
    _applySearchAndPagination();
    update(['home']);
  }


  bool loader = false;
  String taskTitle = '';
  String taskDescription = '';
  DateTime? startDate;
  DateTime? dueDate;
  String? priority;

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

  String midTermDeliverables = '';
  String actualAchievement = '';
  String? midTermDeliverablesError;
  String? actualAchievementError;

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

  bool validateTaskForm() {
    int currentYear = DateTime.now().year;
    taskTitleError = taskTitle.isEmpty ? "Please enter appraisal" : null;

    if (int.tryParse(selectedYear) == currentYear) {
      print("current");
      // Validate full form
      selectedProjectError = (selectedProjectId == null || selectedProjectId!.isEmpty)
          ? "Please select project"
          : null;
      startDateError = startDate == null ? "Please select start date" : null;
      dueDateError = dueDate == null ? "Please select due date" : null;
      taskDescriptionError = taskDescription.isEmpty ? "Please enter activity description" : null;

      // Due date check
      if (startDate != null && dueDate != null && dueDate!.isBefore(startDate!)) {
        dueDateError = "Due date must be after start date";
      }
    } else {
      print("old");
      // Validate simplified form (for previous years)
      midTermDeliverablesError = midTermDeliverables.isEmpty ? "Please enter mid term deliverables" : null;
      actualAchievementError = actualAchievement.isEmpty ? "Please enter actual achievement" : null;
    }

    update(['add_dialog']);

    if (int.tryParse(selectedYear) == currentYear) {
      return taskTitleError == null &&
          selectedProjectError == null &&
          startDateError == null &&
          dueDateError == null &&
          taskDescriptionError == null;
    } else {
      return taskTitleError == null &&
          midTermDeliverablesError == null &&
          actualAchievementError == null;
    }
  }

  Future<void> addSelfTask(BuildContext context, String projectId) async {
    if (validateTaskForm()) {
      FocusManager.instance.primaryFocus?.unfocus();
      int currentYear = DateTime.now().year;

      loader = true;
      update(['home']);

      Map<String, String> addTaskBody;

      if (int.tryParse(selectedYear) == currentYear){
        addTaskBody = {
          "project_id": projectId,
          "task_name": taskTitle.trim(),
          "start_date": startDate.toString().trim(),
          "end_date": dueDate.toString().trim(),
          "task_description": taskDescription.toString().trim(),
          "year": selectedYear.toString().trim(),
        };
      }else{
        addTaskBody = {
          "task_name": taskTitle.trim(),
          "year": selectedYear.toString().trim(),
          "mid_term_delieverable": midTermDeliverables.toString().trim(),
          "actual_achievement": actualAchievement.toString().trim()
        };
      }


      debugPrint("Sending task data: $addTaskBody");

      try {
        final response = await HttpService.postMultipartApi(
          url: EndPoints.saveSelfTask,
          body: addTaskBody,
          files: selectedFileModel != null ? [selectedFileModel!] : [],
        );

        if (response != null && response.statusCode == 200) {
          final model = saveTaskModelFromJson(response.body); // Use your model parser

          if (model.status == "success") {
            toastMsg(model.message ?? "Task added successfully.");
            Navigator.pop(context);
            fetchSelfTasks(true);
          } else {
            toastMsg("Something went wrong.");
          }
        } else {
          toastMsg("Failed to upload task.");
        }
      } catch (e) {
        debugPrint("Upload error: $e");
        toastMsg("Upload error: $e");
      }

      loader = false;
      update(['home']);
    }
  }

  /*addSelfTask(BuildContext context, String projectId) async {
    if(validateTaskForm()){
      FocusManager.instance.primaryFocus?.unfocus();
      loader = true;
      update(['home']);
      Map<String,String> addTaskBody = {
        "project_id": projectId,
        "task_name": taskTitle.trim(),
        "start_date": startDate.toString().trim(),
        "end_date": dueDate.toString().trim(),
        "task_description": taskDescription.toString().trim(),
      };

      debugPrint("Sending task data: $addTaskBody");

      try {
        SaveTaskModel? model = await AuthApi.addSelfTask(addTaskBody);

        if (model != null) {
          if (model.status == "success") {
            toastMsg(model.message.toString());
            Navigator.pop(context);
            fetchSelfTasks();
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

  void resetTaskForm() {
    taskTitle = '';
    //selectedProjectId = '';
    selectedMilestoneId = '';
    selectedMemberId = '';
    priority = null;
    taskDescription = '';
    startDate = null;
    dueDate = null;
    midTermDeliverables = '';
    actualAchievement ='';

    // Reset error texts
    taskTitleError = null;
    startDateError = null;
    dueDateError = null;
    selectedProjectError= null;
    priorityError=null;
    assignedMembersError = null;
    taskDescriptionError = null;
    midTermDeliverablesError=null;
    actualAchievementError = null;
    update(['add_dialog']);
  }







  String workDone = '';
  String skills = '';
  String exceptionWork = '';
  String improvingSkills = '';
  String helpNeeded = '';
  String professionalGoals = '';
  String measureProgress = '';
  String alignWithTeamGoals = '';

  //section 3
  String strength = '';
  String weaknesses = '';
  String utilization = '';
  String goalMeasure = '';
  String goalProgressMeasure = '';
  String goalStatus = '';
  String upskillRecommend = '';


  TextEditingController strengthController = TextEditingController();
  TextEditingController weaknessesController = TextEditingController();
  TextEditingController utilizationController = TextEditingController();
  TextEditingController goalMeasureController = TextEditingController();
  TextEditingController goalProgressMeasureController = TextEditingController();
  TextEditingController goalStatusController = TextEditingController();
  TextEditingController upskillRecommendController = TextEditingController();

  TextEditingController reviewDifferenceController = TextEditingController();
  TextEditingController reviewCommentsController = TextEditingController();
  TextEditingController reviewOverallController = TextEditingController();

  String role = PrefService.getString(PrefKeys.role);

// Error texts
  String utilizationErrorText='';
  String goalMeasureErrorText='';
  String goalProgressMeasureErrorText='';
  String strengthsErrorText='';
  String integrityErrorText='';
  String goalStatusErrorText='';
  String upskillRecommendErrorText='';


  String alignWithTeamGoalsErrorText = '';
  String workDoneErrorText = '';
  String exceptionWorkErrorText = '';
  String skillsErrorText = '';
  String improvingSkillsErrorText = '';
  String helpNeededErrorText = '';
  String professionalGoalsErrorText = '';
  String measureProgressErrorText = '';
  String strengthErrorText = '';
  String weaknessesErrorText = '';
  String reviewDifferenceErrorText = '';
  String reviewCommentsErrorText = '';
  String reviewOverallErrorText= '';

  int currentStep = 0;
  List<UserMetricsData> metricsList = [];
  Rx<String> reviewAgreement = 'Yes'.obs; // Default value is "Yes"
  List<FocusNode> focusNodes = [];
  List<TextEditingController> controllers = [];

  String reviewAgreementString = '';
  String reviewDifference = '';
  String reviewComments = '';
  String reviewOverall = '';


  @override
  void onClose() {
    for (var node in focusNodes) {
      node.dispose();
    }
    for (var controller in controllers) {
      controller.dispose();
    }
    super.onClose();
  }

  void initializeControllers() {
    controllers = List.generate(metricsList.length, (index) => TextEditingController());
    focusNodes = List.generate(metricsList.length, (index) => FocusNode());
  }

  void nextStep() {
    int? lastStep = 4;
    if(PrefService.getString(PrefKeys.userId) == reviewingOfficerId)
      lastStep = 5;

    print("last step: $lastStep");

    if (currentStep < lastStep) {
      currentStep++;
      update(['home']);
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      currentStep--;
      update(['home']);
    }
  }

  Future<void> submitAppraisalDataForm3(BuildContext context) async {
    if (!loader) {
      loader = true;
      update(['home']);
    }

    Map<String,String> body = {
      "section": "3",
      "appraisal_id": appraisalId,
      "strength": strengthController.text.trim(),
      "weaknesses": weaknessesController.text.trim(),
      "utilization": utilizationController.text.trim(),
      "goal_measure": goalMeasureController.text.trim(),
      "goal_progress_measure": goalProgressMeasureController.text.trim(),
      "goal_status": goalStatusController.text.trim(),
      "upskill_recommend": upskillRecommendController.text.trim(),
    };

    try {
      final response = await HttpService.postApi(url: '${EndPoints.saveSelfAppraisal}', body: body);

      print("Save data: ${response?.body}");

      final responseBody = jsonDecode(response!.body);

      if (response.statusCode == 200 && responseBody['status'] == 'success') {

        showSubmissionDialog(
          context: context,
          message: "Appraisal submitted successfully!",
          buttonText: "Done",
          onPressed: () {
            Navigator.of(context).pop();
            // Stop loader first
            loader = false;
            update(['home']);

            // Go to step 0 and update UI
            currentStep = 0;
            update(['home']);
          },
        );

      } else {
        toastMsg(responseBody['message'] ?? 'Failed to submit data');
      }

    } catch (e) {
      toastMsg('An error occurred: $e');
    }
  }

  bool SectionReportingValidation() {
    if (strengthController.text.isEmpty) {
      strengthErrorText = "Please enter strengths";
    } else {
      strengthErrorText = "";
    }

    if (weaknessesController.text.isEmpty) {
      weaknessesErrorText = "Please enter weaknesses";
    } else {
      weaknessesErrorText = "";
    }

    if (utilizationController.text.isEmpty) {
      utilizationErrorText = "Please explain utilization of your skills";
    } else {
      utilizationErrorText = "";
    }

    if (goalMeasureController.text.isEmpty) {
      goalMeasureErrorText = "Please describe how goals are measured";
    } else {
      goalMeasureErrorText = "";
    }

    if (goalProgressMeasureController.text.isEmpty) {
      goalProgressMeasureErrorText = "Please describe progress measurement";
    } else {
      goalProgressMeasureErrorText = "";
    }

    if (goalStatusController.text.isEmpty) {
      goalStatusErrorText = "Please provide goal status";
    } else {
      goalStatusErrorText = "";
    }

    if (upskillRecommendController.text.isEmpty) {
      upskillRecommendErrorText = "Please recommend upskilling options";
    } else {
      upskillRecommendErrorText = "";
    }

    update(['home']);

    return
        strengthErrorText.isEmpty &&
        weaknessesErrorText.isEmpty &&
        utilizationErrorText.isEmpty &&
        goalMeasureErrorText.isEmpty &&
        goalProgressMeasureErrorText.isEmpty &&
        goalStatusErrorText.isEmpty &&
        upskillRecommendErrorText.isEmpty;
  }

  bool sectionReviewValidation() {
    if (reviewAgreement.value.isEmpty) {
      toastMsg("Please select agreement option");
      return false;
    }

    if (reviewAgreement.value == "No" && reviewDifferenceController.text.isEmpty) {
      reviewDifferenceErrorText = "Please explain the reason for disagreement";
    } else {
      reviewDifferenceErrorText = "";
    }

    if (reviewCommentsController.text.isEmpty) {
      reviewCommentsErrorText = "Please enter review comments";
    } else {
      reviewCommentsErrorText = "";
    }

    if (reviewOverallController.text.isEmpty) {
      reviewOverallErrorText = "Please provide overall rating";
    } else {
      reviewOverallErrorText = "";
    }

    update(['home']);

    return reviewDifferenceErrorText.isEmpty &&
        reviewCommentsErrorText.isEmpty &&
        reviewOverallErrorText.isEmpty;
  }

  Future<void> submitAppraisalDataForm4(BuildContext context) async {
    if (!loader) {
      loader = true;
      update(['home']);
    }

    Map<String, String> body = {
      "section": "4",
      "appraisal_id": appraisalId,
      "review_agreement": reviewAgreement.value,
      "review_difference": reviewDifferenceController.text.trim(),
      "review_comments": reviewCommentsController.text.trim(),
      "review_overall": reviewOverallController.text.trim(),
    };

    try {
      final response = await HttpService.postApi(
        url: EndPoints.saveSelfAppraisal,
        body: body,
      );

      print("Save data (Section 4): ${response?.body}");

      final responseBody = jsonDecode(response!.body);

      if (response.statusCode == 200 && responseBody['status'] == 'success') {

        showSubmissionDialog(
          context: context,
          message: "Appraisal submitted successfully!",
          buttonText: "Done",
          onPressed: () {
            Navigator.of(context).pop();
            // Stop loader first
            loader = false;
            update(['home']);

            // Go to step 0 and update UI
            currentStep = 0;
            update(['home']);

          },
        );


      } else {
        toastMsg(responseBody['message'] ?? 'Failed to submit data');
      }

    } catch (e) {
      toastMsg('An error occurred: $e');
    }
  }

  bool Form2Validation(BuildContext context) {
    final userId = PrefService.getString(PrefKeys.userId);

    if (userId == reportingOfficerId) {
      for (var metric in metricsList) {
        if (metric.reportingOfficerRating == null || metric.reportingOfficerRating == 0) {
          toastMsg("Please fill all fields.");
          return false;
        }

        final maxMarks = int.tryParse(metric.maximumMarks ?? '0') ?? 0;
        if (metric.reportingOfficerRating! > maxMarks) {
          toastMsg("Rating cannot exceed the maximum marks");
          return false;
        }
      }
    } else if (userId == reviewingOfficerId) {
      for (var metric in metricsList) {
        if (metric.reviewingOfficerRating == null || metric.reviewingOfficerRating == 0) {
          toastMsg("Please fill all fields.");
          return false;
        }

        final maxMarks = int.tryParse(metric.maximumMarks ?? '0') ?? 0;
        if (metric.reviewingOfficerRating! > maxMarks) {
          toastMsg("Rating cannot exceed the maximum marks");
          return false;
        }
      }
    }

    return true;
  }

  Future<void> submitAppraisalDataForm2(BuildContext context) async {
    if(Form2Validation(context)){
      if (!loader) {
        loader = true;
        update(['home']);
      }

      try {
        final response = await HttpService.postJsonApi(
          url: EndPoints.saveSelfAppraisal,
          body: {
            "section": "2",
            "appraisal_id": appraisalId,
            "metrics_data": metricsList.map((e) => {
              "category": e.category,
              "description": e.description,
              "maximumMarks": e.maximumMarks,
              "fieldName": e.fieldName,
              "selfRating": e.selfRating ?? 0,
              "reportingOfficerRating": e.reportingOfficerRating ?? 0,
              "reviewingOfficerRating": e.reviewingOfficerRating ?? 0,
            }).toList(),
          },
        );

        print("Save table data: ${response?.body}");

        final responseBody = jsonDecode(response!.body);

        if (response.statusCode == 200 && responseBody['status'] == 'success') {
          toastMsg(responseBody['message'] ?? 'Appraisal submitted successfully!');
          nextStep();
        } else {
          toastMsg(responseBody['message'] ?? 'Failed to submit data');
        }

      } catch (e) {
        toastMsg('An error occurred: $e');
      }
    }
    }

}
