import 'dart:convert';
import 'package:performance_management_system/pms.dart';

class AppraisalFormController extends GetxController {
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

  bool loader = false;
  String selectedYear = '01-04-2024 - 31-03-2025';

  List<String> availableFinancialYears = [
    '01-04-2024 - 31-03-2025'
  ];


  String searchQuery = '';
  int currentPage = 0;
  List<int> rowsPerPageOptions = [5, 10, 20, 50];
  int rowsPerPage = 10;

  Future<void> initialize() async {
    setYearFilter(DateTime.now().year.toString());
  }

  void setYearFilter(String? year) {
    selectedYear = year!;
    currentPage = 0;
    // applyFilters();
    fetchSelfTasks(false);
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
  List<SelfAppraisalListData> get filteredTasks {
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
  void setTasks(List<SelfAppraisalListData> tasks) {
    allTasks = tasks;
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


  List<SelfAppraisalListData> allTasks = [];       // All fetched tasks
  List<SelfAppraisalListData> paginatedTasks = []; // Final data for UI


  List<SelfTaskModel> allSelfTasks = [];
  List<SelfTaskModel> filteredSelfTasks = [];

  TextEditingController workDoneController = TextEditingController();
  TextEditingController skillsController = TextEditingController();
  TextEditingController exceptionWorkController = TextEditingController();
  TextEditingController improvingSkillsController = TextEditingController();
  TextEditingController helpNeededController = TextEditingController();
  TextEditingController professionalGoalsController = TextEditingController();
  TextEditingController measureProgressController = TextEditingController();
  TextEditingController alignWithTeamGoalsController = TextEditingController();
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
  bool viewOnly = false;
  List<SelfAppraisalListMetricsData> filledmetricsList = [];
  List<MetricsData> metricsList = [];
  Rx<String> reviewAgreement = 'Yes'.obs; // Default value is "Yes"
  List<FocusNode> focusNodes = [];
  List<TextEditingController> controllers = [];

  String appraisalId = '';

  String reviewingOfficerId = '0';

  String reportingOfficerId = '0';

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
    print("currentStep::::: $currentStep");
    if (currentStep < 3) {
      currentStep++;
      update(['home']);
    }
    print("currentSteppp::::: $currentStep");
  }

  void previousStep() {
    if (currentStep > 0) {
      currentStep--;
      update(['home']);
    }
  }

  Future getAppraisalMetrics() async {
    fetchSelfTasks(false);

   if (!loader) {
      loader = true;
      update(['home']);
    }

   String designationId = PrefService.getString(PrefKeys.designationId);

    try {
      final response = await HttpService.getApi( url: '${EndPoints.appraisalFormsList}/$designationId');
      print("metrics List: ${response?.body}");
      if (response != null && response.statusCode == 200) {
        final model = metricsModelFromJson(response.body);
        metricsList = model.data ?? [];
      }
    } catch (e) {
      throw Exception(e.toString());
    }

    if (loader) {
      loader = false;
      update(['home']);
    }

    return [];
  }

  SectionSelfAppraisalValidation() {
    if (workDoneController.text.isEmpty) {
      workDoneErrorText = "Please enter brief description of work";
    } else {
      workDoneErrorText = "";
    }

    if (skillsController.text.isEmpty) {
      skillsErrorText = "Please eter skill upgradation areas";
    } else {
      skillsErrorText = "";
    }
    if (exceptionWorkController.text.isEmpty) {
      exceptionWorkErrorText = "Please enter exceptional work details";
    } else {
      exceptionWorkErrorText = "";
    }
    if (improvingSkillsController.text.isEmpty) {
      improvingSkillsErrorText = "Please enter plan on improving skills";
    } else {
      improvingSkillsErrorText = "";
    }
    if (professionalGoalsController.text.isEmpty) {
      professionalGoalsErrorText = "Please enter professional goals";
    } else {
      professionalGoalsErrorText = "";
    }
    if (helpNeededController.text.isEmpty) {
      helpNeededErrorText = "Please enter improvement help details";
    } else {
      helpNeededErrorText = "";
    }
    if (measureProgressController.text.isEmpty) {
      measureProgressErrorText = "Please enter progress measurement details";
    } else {
      measureProgressErrorText = "";
    }
    if (alignWithTeamGoalsController.text.isEmpty) {
      alignWithTeamGoalsErrorText = "Please enter alignment details";
    } else {
      alignWithTeamGoalsErrorText = "";
    }

    update(['home']);
    return workDoneErrorText.isEmpty && skillsErrorText.isEmpty && exceptionWorkErrorText.isEmpty && improvingSkillsErrorText.isEmpty
        && professionalGoalsErrorText.isEmpty && helpNeededErrorText.isEmpty && measureProgressErrorText.isEmpty
        && alignWithTeamGoalsErrorText.isEmpty;
  }

  // Submit data to API
  Future<void> submitAppraisalDataForm1(BuildContext context) async {
    if (!loader) {
      loader = true;
      update(['home']);
    }

    Map<String,String> body = {
      "section": "1",
      "start_date": "01-04-2024",
      "end_date": "31-03-2025",
      "work_done": workDoneController.text.toString() ?? '',
      "skills_upgrade": skillsController.text.toString() ?? '',
      "exceptional_work": exceptionWorkController.text.toString() ?? '',
      "improvement_plan": improvingSkillsController.text.toString() ?? '',
      "help_needed": helpNeededController.text.toString() ?? '',
      "professional_goals": professionalGoalsController.text.toString() ?? '',
      "measure_progress": measureProgressController.text.toString() ?? '',
      "alignWithTeamGoals": alignWithTeamGoalsController.text.toString() ?? ''
    };

    try {
      final response = await HttpService.postApi(url: '${EndPoints.saveSelfAppraisal}', body: body);

      print("Save data: ${response?.body}");

      final responseBody = jsonDecode(response!.body);

      if (response.statusCode == 200 && responseBody['status'] == 'success') {
        nextStep();
      } else {
        toastMsg(responseBody['message'] ?? 'Failed to submit data');
      }

    } catch (e) {
      toastMsg('An error occurred: $e');
    }
    if (loader) {
      loader = false;
      update(['home']);
    }
  }

  Future<void> submitAppraisalDataForm2(BuildContext context) async {

    // Validation: Ensure all self ratings are entered and within limits
    for (var metric in metricsList) {
      if (metric.selfRating == null) {
        toastMsg("Please fill all fields.");
        return;
      }

      final maxMarks = int.tryParse(metric.maximumMarks ?? '0') ?? 0;
      if (metric.selfRating! > maxMarks) {
        toastMsg("Rating can not exceed the maximum marks");
        return;
      }
    }

    if (!loader) {
      loader = true;
      update(['home']);
    }

    try {
      final response = await HttpService.postJsonApi(
        url: EndPoints.saveSelfAppraisal,
        body: {
          "section": "2",
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
        // Stop loader first
        loader = false;
        update(['home']);

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

            fetchSelfTasks(false);
          },
        );

      } else {
        toastMsg(responseBody['message'] ?? 'Failed to submit data');
      }

    } catch (e) {
      toastMsg('An error occurred: $e');
    }
  }

  Future fetchSelfTasks(bool isload) async {
    loader = isload;
    update(['home']);
   /* Map<String,String> taskBody = {
      "year": selectedYear.toString().trim(),
    };*/

    try {
      final response = await HttpService.getApi(url: EndPoints.selfAppraisalList);
      print("response: $response");
      if (response != null && response.statusCode == 200) {
        final tasksModel = selfAppraisalListModelFromJson(response.body);
        final fetched = tasksModel.data ?? [];
        setTasks(fetched); // <- Use new method to set tasks and paginate

        final model = selfAppraisalListModelFromJson(response.body);
        filledmetricsList = model.data
            ?.expand<SelfAppraisalListMetricsData>((task) => task.section2?.metricsData ?? [])
            .toList() ?? [];


        if (model.data != null && model.data!.isNotEmpty) {

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

          strength = section3?.strength ?? '';
          weaknesses = section3?.weaknesses ?? '';
          utilization = section3?.utilization ?? '';
          goalMeasure = section3?.goalMeasure ?? '';
          goalProgressMeasure = section3?.goalProgressMeasure ?? '';
          goalStatus = section3?.goalStatus ?? '';
          upskillRecommend = section3?.upskillRecommend ?? '';

        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }

    loader = false;
    update(['home']);
  }

}

