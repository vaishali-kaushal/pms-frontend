import 'dart:convert';
import 'package:performance_management_system/pms.dart';

class RolesController extends GetxController {
  bool loader = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  List<TechStackData> techStacksList = [];
  List<RolesData> rolesList = [];
  List<DesignationData> designationList = [];
  List<EmployerData> employerList = [];
  List<DepartmentData> departmentList = [];
  List<DivisionData> divList = [];
  List<UsersData> usersList = [];
  List<UsersData> reviewingOfficerList = [];
  List<Skills> skillsList = [];
  List<DomainData> domainList = [];
  List<SubDomains> subDomainList = [];
  List<QualificationData> qualifications = [];
  List<DistrictData> locations = [];

  List<UserRolesData> allrolesList = [];

  // Form Fields
  String name = '';
  String email = '';
  String password = '';
  String employer = '';
  String mobile = '';
  String salary = '';
  String? selectedDesignation;
  String? selectedDesignationId;
  String? selectedEmployer;
  String? selectedEmployerId;
  String? selectedRole;
  String? selectedDepartmentId;
  String? selectedReportingOfficerId;
  String? selectedReportingOfficer;
  String? selectedReviewingOfficerId;
  String? selectedReviewingOfficer;
  String? selectedDomain;
  String? selectedSubDomain;
  String? selectedSubDomainId;
  String? selectedRoleId;
  String? selectedDomainId;
  String? selectedTechStack;
  String? selectedTechStackId;
  String? selectedlocationId;
  String? selectedLocation;
  int? selectedExperienceYears;
  int? selectedExperienceMonths;
  DateTime? selectedDOB;
  String? dobError;
  DateTime? selectedDOJ;
  String? dojError;
  TextEditingController searchController = TextEditingController();


  // Error fields
  String? nameError;
  String? emailError;
  String? employerError;
  String? passwordError;
  String? experienceError;
  String? mobileError;
  String? designationError;
  String? reviewingOfficerError;
  String? reportingOfficerError;
  String? skillsError;
  String? domainError;
  String? subDomainError;
  String? roleError;
  String? techStackError;
  String? locationError;
  List<String> selectedQualifications = [];
  List<String> selectedSkills = [];
  List<String> selectedDivisons = [];
  List<String> selectedDepartment = [];

  FileModel? selectedFileModel;

  Future<void> pickFile() async {
    final file = await FilePickerHelper.pickSingleFile(
      keyName: "resume", // dynamic key here
    );

    if (file != null) {
      selectedFileModel = file;
      update(['add_dialog']);
    }
  }

/*  List<Map<String, dynamic>> getOptions(String type) {
    if (type == "Skills") {
      return allSubSkills.map((sub) => {
        "id": sub.id,
        "name": sub.name,
      }).toList();
    }else if (type == "Skills") {
      return [
        // TeamMemberData(id: 1, name: "Flutter"),
        // TeamMemberData(id: 2, name: "Dart"),
        // TeamMemberData(id: 3, name: "Firebase"),
      ];
    }
    return [];
  }*/

  Future<void> addUserRole(BuildContext context) async {
      FocusManager.instance.primaryFocus?.unfocus();
      loader = true;
      update(['home']);

      Map<String, String> roleData = {
        "name": name.trim(),
        "email": email.trim(),
        "password": password.trim(),
        "employer": selectedEmployerId.toString().trim(),
        "designation": selectedDesignationId!,
        "department": selectedDepartment.toString(),
        "role": selectedRoleId!,
        "mobile_number": mobile.trim(),
        "dob": selectedDOB!.toString(),
        "reporting_officer": selectedReportingOfficerId.toString(),
        "reviewing_officer": selectedReviewingOfficerId.toString(),
        "qualification": selectedQualifications.toString(),
        "domain": selectedSubDomainId.toString(),
        "sub_domain": selectedSubDomainId.toString(),
        "skills": selectedSkills.toString(),
        "exp_year": selectedExperienceYears.toString(),
        "exp_month": selectedExperienceMonths.toString(),
        "doj": selectedDOJ!.toString(),
        "division": selectedDivisons.toString(),
        "salary": salary.toString(),
        "location": selectedlocationId.toString()
      };

      debugPrint("Sending role data: $roleData");

      try {
        final response = await HttpService.postMultipartApi(
          url: EndPoints.addUserRole,
          body: roleData,
          files: selectedFileModel != null ? [selectedFileModel!] : [],
        );

        if (response != null && response.statusCode == 200) {
          final result = jsonDecode(response.body);
          if (result["status"] == "success") {
            toastMsg(result["message"] ?? "User role added successfully.");
            Navigator.pop(context);
            fetchUsers();
          } else {
            toastMsg(result["message"] ?? 'Something went wrong');
          }
        } else {
          toastMsg('Server error. Please try again.');
        }
      } catch (e) {
        debugPrint("Add role error: ${e.toString()}");
        toastMsg("Upload error: ${e.toString()}");
      }

      loader = false;
      update(['home']);
  }

  /*Future<void> addUserRole(BuildContext context) async {
    if (validateRoleForm()) {
      FocusManager.instance.primaryFocus?.unfocus();
      loader = true;
      update(['home']);

      Map<String, String> roleData = {
        "name": name.trim(),
        "email": email.trim(),
        "password": password.trim(),
        "employer": employer.trim(),
        "designation": selectedDesignationId!,
        "department": selectedDepartmentId!,
        "role": selectedRoleId!,
        "mobile_number": mobile.trim(),
        "tech_stack": selectedTechStackId!,
      };
      debugPrint("Sending role data: $roleData");

      try {
        final response = await HttpService.postApi(
          url: EndPoints.addUserRole,
          body: roleData,
        );

        if (response != null && response.statusCode == 200) {
          final result = jsonDecode(response.body);
          if (result["status"] == "success") {
            toastMsg(result["message"]);
            Navigator.pop(context);
            fetchUsers();
          } else {
            toastMsg(result["message"] ?? 'Something went wrong');
          }
        } else {
          toastMsg('Server error. Please try again.');
        }
      } catch (e) {
        debugPrint("Add role error: \${e.toString()}");
      }

      loader = false;
      update(['home']);
    }
  }
*/
  /*Future fetchTechStack() async {
    if (!loader) {
      loader = true;
      update(['home']);
    }

    try {
      final response = await HttpService.getApi(url: EndPoints.getTechStacks);
      print("Tech Stack List: ${response?.body}");
      if (response != null && response.statusCode == 200) {
        final techStackModel = techStackModelFromJson(response.body);
        techStacksList = techStackModel.data ?? [];
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
*/
  Future fetchRoles() async {
    if (!loader) {
      loader = true;
      update(['home']);
    }

    try {
      final response = await HttpService.getApi(url: EndPoints.getUserRoles);
      print("Roles List: ${response?.body}");
      if (response != null && response.statusCode == 200) {
        final rolesModel = rolesModelFromJson(response.body);
        rolesList = rolesModel.data ?? [];
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

  Future fetchDesignation() async {
    if (!loader) {
      loader = true;
      update(['home']);
    }

    try {
      final response = await HttpService.getApi(url: EndPoints.getDesignation);
      print("Designation List: \${response?.body}");
      if (response != null && response.statusCode == 200) {
        final designationModel = designationModelFromJson(response.body);
        designationList = designationModel.data ?? [];
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

  Future fetchDepartments() async {
    if (!loader) {
      loader = true;
      update(['home']);
    }

    try {
      final response = await HttpService.getApi(url: EndPoints.departmentList);
      print("Depart List: \${response?.body}");
      if (response != null && response.statusCode == 200) {
        final departmentModel = departmentModelFromJson(response.body);
        departmentList = departmentModel.data ?? [];
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

  Future fetchDivisions() async {
    if (!loader) {
      loader = true;
      update(['home']);
    }

    try {
      final response = await HttpService.getApi(url: EndPoints.divisionsList);
      print("Div List: \${response?.body}");
      if (response != null && response.statusCode == 200) {
        final model = divisionModelFromJson(response.body);
        divList = model.data ?? [];
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

  Future fetchEmployer() async {
    if (!loader) {
      loader = true;
      update(['home']);
    }

    try {
      final response = await HttpService.getApi(url: EndPoints.employerList);
      print("Employer List: \${response?.body}");
      if (response != null && response.statusCode == 200) {
        final model = employerModelFromJson(response.body);
        employerList = model.data ?? [];
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

  Future reportingOfficer() async {
    String secureId = PrefService.getString(PrefKeys.secureId);
    if (!loader) {
      loader = true;
      update(['home']);
    }

    Map<String, String> body = {
      "type": "reporting_officer_list",
    };

    try {
      final response = await HttpService.getApi( url: '${EndPoints.userList}/$secureId', queryParams: body);
      print("user List: \${response?.body}");
      if (response != null && response.statusCode == 200) {
        final model = usersListModelModelFromJson(response.body);
        usersList = model.data ?? [];
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

  Future reviewingOfficer() async {
      String secureId = PrefService.getString(PrefKeys.secureId);
      if (!loader) {
        loader = true;
        update(['home']);
      }

      Map<String, String> body = {
        "type": "reviewing_officer_list",
      };

      try {
        final response = await HttpService.getApi( url: '${EndPoints.userList}/$secureId', queryParams: body);
        print("user List: \${response?.body}");
        if (response != null && response.statusCode == 200) {
          final model = usersListModelModelFromJson(response.body);
          reviewingOfficerList = model.data ?? [];
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

  Future fetchDomain() async {
    if (!loader) {
      loader = true;
      update(['home']);
    }

      try {
        final response = await HttpService.getApi(url: EndPoints.skillsList);
        print("Domain List: \${response?.body}");
        if (response != null && response.statusCode == 200) {
          final model = domainModelFromJson(response.body);
          domainList = model.data ?? [];

        /*  // Subdomain List
          subDomainList = model.data!
              .expand((domain) => domain.subDomains ?? [])
              .cast<SubDomains>()
              .toList();

          // Skills List
          skillsList = model.data!
              .expand((domain) => domain.subDomains ?? [])
              .expand((subdomain) => subdomain.skills ?? [])
              .cast<Skills>()
              .toList();*/

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

  void filterSubDomainsByDomainId(int? domainId) {
    if (domainId == null) return;

    final selectedDomain = domainList.firstWhere(
          (d) => d.id == domainId,
    );

    subDomainList = selectedDomain.subDomains ?? [];
    print("subDomainList $subDomainList");
    update(["add_dialog"]);
  }
  void filterSkillsBySubDomainId(int? subDomainId) {
    if (subDomainId == null) return;

    final selectedDomain = subDomainList.firstWhere(
          (d) => d.id == subDomainId,
    );

    skillsList = selectedDomain.skills ?? [];
    print("Skills List: ${skillsList.map((s) => s.name).toList()}");
    update(["add_dialog"]);
  }

  Future fetchQualifications() async {
    if (!loader) {
      loader = true;
      update(['home']);
    }

    try {
      final response = await HttpService.getApi(url: EndPoints.qualificationsList);
      print("Skill List: \${response?.body}");
      if (response != null && response.statusCode == 200) {
        final model = qualificationModelFromJson(response.body);
        qualifications = model.data ?? [];
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

  Future fetchDistrict() async {
    if (!loader) {
      loader = true;
      update(['home']);
    }

      try {
        final response = await HttpService.getApi(url: EndPoints.districtList);
        print("District List: \${response?.body}");
        if (response != null && response.statusCode == 200) {
          final model = districtModelFromJson(response.body);
          locations = model.data ?? [];
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

  Future fetchUsers() async {
    String secureId = PrefService.getString(PrefKeys.secureId);
    if (!loader) {
      loader = true;
      update(['home']);
    }
    Map<String, String> body = {
      "type": "userlist",
    };

    try {
      final response = await HttpService.getApi( url: '${EndPoints.userList}/$secureId', queryParams: body);
      print("Users List: ${response?.body}");
      if (response != null && response.statusCode == 200) {
        final userRolesModel = userRolesModelFromJson(response.body);
        ///allrolesList = userRolesModel.data ?? [];
        final fetched = userRolesModel.data ?? [];
        setTasks(fetched);
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


  String searchQuery = '';       // All fetched tasks
  List<UserRolesData> paginatedRoles = []; // Final data for UI
  int currentPage = 0;
  List<int> rowsPerPageOptions = [5, 10, 20, 50];
  int rowsPerPage = 10;


  // Get filtered tasks based on search query
  List<UserRolesData> get filteredRoles {
    if (searchQuery.isEmpty) return allrolesList;
    return allrolesList.where((role) =>
    (role.name ?? '').toLowerCase().contains(searchQuery) ||
        (role.role ?? '').toLowerCase().contains(searchQuery) ||
        (role.designation ?? '').toLowerCase().contains(searchQuery)
       // ||(role.department ?? '').toLowerCase().contains(searchQuery)
    ).toList();
  }

  // Get total number of pages based on filtered tasks
  int get totalPages {
    final totalItems = filteredRoles.length;
    return (totalItems / rowsPerPage).ceil().clamp(1, double.infinity).toInt();
  }

  // Filter tasks based on search
  void filterRoles(String query) {
    searchQuery = query.toLowerCase();
    currentPage = 0;
    _applySearchAndPagination();
    update(['home']);
  }

  // Change rows per page
  void changeRowsPerPage(int? value) {
    rowsPerPage = value ?? 0;
    currentPage = 0;
    _applySearchAndPagination();
    update(['home']);
  }

  // Apply filtering and pagination
  void _applySearchAndPagination() {
    final filtered = filteredRoles;
    final start = currentPage * rowsPerPage;
    final end = (start + rowsPerPage).clamp(0, filtered.length);
    paginatedRoles = filtered.sublist(start, end);
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
  void setTasks(List<UserRolesData> roles) {
    allrolesList = roles;
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

