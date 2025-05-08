import 'package:performance_management_system/pms.dart';

class RolesTable extends StatelessWidget {
  final RolesController controller = Get.put(RolesController());

  RolesTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RolesController>(
      id: 'home',
      initState: (_) {
        controller.fetchUsers();
        controller.fetchRoles();
        controller.fetchDesignation();
        controller.fetchDepartments();
        controller.fetchDivisions();
        controller.fetchEmployer();
        controller.reportingOfficer();
        controller.reviewingOfficer();
        controller.fetchDomain();
        controller.fetchQualifications();
        controller.fetchDistrict();
      },
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              CommonPaginatedTable<UserRolesData>(
                data: controller.paginatedRoles,
                isLoading: controller.loader,
                headers: [
                  TableColumnConfig('#', flex: 1), // ~5%
                  TableColumnConfig('Name', flex: 2),
                  TableColumnConfig('Role', flex: 2),
                  TableColumnConfig('Designation', flex: 2),
                  TableColumnConfig('Department', flex: 2),
                  TableColumnConfig('Mobile Number', flex: 2),
                  TableColumnConfig('Action', flex: 1),
                ],
                rowBuilder: (role, index) {
                  final srNo = controller.currentPage * controller.rowsPerPage + index + 1;
                  return TableRow(children: [
                    commonTableCell(srNo.toString()),
                    commonTableCell(role.name ?? ''),
                    commonTableCell(role.role ?? ''),
                    commonTableCell(role.designation ?? ''),
                    commonTableCell(role.department?.join(', ') ?? ''),
                    commonTableCell(role.mobileNumber ?? ''),
                   /* commonDeleteButtonCell(
                      context: context,
                      onConfirm: () {
                        // controller.deleteRole(role.id);
                      },
                    ),*/
                    ViewActionButton(
                      data: role,
                      controller: controller,
                      onPressed: () {
                        showCommonSideDialog<UserRolesData>(
                          context: context,
                          dataModel: role,
                          title: "User Details",
                          buildInfoWidgets: (role) => [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CommonInfoRow(title: "User Name", value: role.name ?? ''),
                                      CommonInfoRow(title: "Role", value: role.role ?? ''),
                                      CommonInfoRow(title: "Mobile Number", value: role.mobileNumber ?? ''),
                                      CommonInfoRow(title: "Designation", value: role.designation ?? ''),
                                      CommonInfoRow(title: "Department", value: role.department?.join(', ')?? ''),
                                      CommonInfoRow(title: "Employer", value: role.employer ?? ''),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        );
                      },
                    )

                  ]);
                },
                rowsPerPage: controller.rowsPerPage,
                rowsPerPageOptions: controller.rowsPerPageOptions,
                onRowsPerPageChanged: controller.changeRowsPerPage,
                onSearchChanged: controller.filterRoles,
                onPreviousPage: controller.previousPage,
                onNextPage: controller.nextPage,
                currentPage: controller.currentPage,
                totalItems: controller.filteredRoles.length,
                emptyTitle: "No User Found!",
                emptySubtitle: "Users will appear here once added",
                emptyIcon: LucideIcons.userX,
              ),
            ],
          ),
        );
      },
    );
  }
}

class AddRolesDialog extends StatefulWidget {
  @override
  _AddRolesDialogState createState() => _AddRolesDialogState();
}

class _AddRolesDialogState extends State<AddRolesDialog> {
  final RolesController controller = Get.put(RolesController());
  final _formKey = GlobalKey<FormState>();

  InputDecoration buildInputDecoration({
    required String labelText,
    String? errorText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      errorText: errorText,
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.zero,
        child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: true),
        child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    child:GetBuilder<RolesController>(
                      id: 'add_dialog',
                      builder: (controller) {
                        return Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(child: headerText("Add New User")),
                              appSizedBox(height: 2.h),

                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10.0), // Added padding to reduce space between fields
                                      child: CommonTextFormField(
                                        label: "Name",
                                        value: controller.name,
                                        errorText: controller.nameError,
                                        onChanged: (val) => controller.name = val,
                                        validator: (val) => val == null || val.isEmpty ? 'Please enter name' : null,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0), // Reduced padding on the right side
                                      child: CommonTextFormField(
                                        label: "Email",
                                        value: controller.email,
                                        errorText: controller.emailError,
                                        onChanged: (val) => controller.email = val,
                                        validator: (val) {
                                          if (val == null || val.isEmpty) return 'Please enter email';
                                          final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
                                          if (!emailRegex.hasMatch(val)) return 'Enter a valid email';
                                          return null;
                                        },
                                        keyboardType: TextInputType.emailAddress,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              appSizedBox(height: 2.h),

                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10.0),
                                      child: CommonTextFormField(
                                        label: "Mobile Number",
                                        value: controller.mobile,
                                        errorText: controller.mobileError,
                                        onChanged: (val) => controller.mobile = val,
                                        validator: (val) {
                                          if (val == null || val.isEmpty) return 'Please enter mobile number';
                                          if (val.length != 10) return 'Mobile number must be 10 digits';
                                          return null;
                                        },
                                        keyboardType: TextInputType.phone,
                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: CommonTextFormField(
                                        label: "Password",
                                        errorText: controller.passwordError,
                                        obscureText: true,
                                        onChanged: (val) => controller.password = val,
                                        validator: (val) => val == null || val.isEmpty ? 'Please enter password' : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              appSizedBox(height: 2.h),

                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10.0),
                                      child: FormField<List<String>>(
                                        validator: (val) {
                                          return controller.selectedQualifications.isEmpty && true
                                              ? 'Please select at least one Qualification'
                                              : null;
                                        },
                                        builder: (formFieldState) {
                                          return CommonMultiSelectDropdown<QualificationData>(
                                            items: controller.qualifications,
                                            selectedIds: controller.selectedQualifications,
                                            getId: (member) => member.id.toString(),
                                            getLabel: (member) => member.name ?? '',
                                            labelText: "Qualification",
                                            errorText: formFieldState.errorText,
                                            onSelectionChanged: (selected) {
                                              controller.selectedQualifications = selected;
                                              formFieldState.didChange(selected);
                                            },
                                            isRequired: true,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: FormField<DateTime>(
                                        validator: (val) {
                                          if (controller.selectedDOB == null) {
                                            return 'Please select Date of Birth';
                                          }
                                          return null;
                                        },
                                        builder: (state) {
                                          return GetBuilder<RolesController>(
                                            id: 'dob',
                                            builder: (controller) {
                                              return DatePickerFormField(
                                                label: "Date of Birth",
                                                selectedDate: controller.selectedDOB,
                                                errorText: state.errorText,
                                                onDateSelected: (val) {
                                                  controller.selectedDOB = val;
                                                  controller.update(['dob']);
                                                  state.didChange(val); // Triggers validation
                                                },
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              appSizedBox(height: 2.h),

                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10.0),
                                      child: FormField<DateTime>(
                                        validator: (val) {
                                          if (controller.selectedDOJ == null) {
                                            return 'Please select Date of Joining';
                                          }
                                          return null;
                                        },
                                        builder: (state) {
                                          return GetBuilder<RolesController>(
                                            id: 'doj',
                                            builder: (controller) {
                                              return DatePickerFormField(
                                                label: "Date of Joining",
                                                selectedDate: controller.selectedDOJ,
                                                errorText: state.errorText,
                                                onDateSelected: (val) {
                                                  controller.selectedDOJ = val;
                                                  controller.update(['doj']);
                                                  state.didChange(val); // Triggers validation
                                                },
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: FormField<List<String>>(
                                        validator: (val) {
                                          return controller.selectedSkills
                                              .isEmpty
                                              ? 'Please select at least one Deployment location'
                                              : null;
                                        },
                                        builder: (formFieldState) {
                                          return CommonMultiSelectDropdown<
                                              DepartmentData>(
                                            items: controller.departmentList,
                                            selectedIds: controller
                                                .selectedDepartment,
                                            getId: (member) =>
                                                member.id.toString(),
                                            getLabel: (member) =>
                                            member.name ?? '',
                                            labelText: "Deployment Location",
                                            errorText: formFieldState.errorText,
                                            onSelectionChanged: (selected) {
                                              controller.selectedDepartment =
                                                  selected;
                                              formFieldState.didChange(
                                                  selected);
                                            },
                                            isRequired: true,
                                          );
                                        },
                                      ),

                                    ),
                                  ),
                                ],
                              ),

                              appSizedBox(height: 2.h),

                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10.0),
                                      child: CommonSearchableDropdown<DesignationData>(
                                        items: controller.designationList,
                                        getItemLabel: (d) => d.name.toString(),
                                        getItemValue: (d) => d.id.toString(),
                                        valueId: controller.selectedDesignation,
                                        labelText: "Designation",
                                        searchController: controller.searchController,
                                        onChanged: (val) {
                                          controller.selectedDesignationId = val?.id.toString();
                                          controller.selectedDesignation = val?.name;
                                        },
                                        validator: (val) => val == null ? 'Please select designation' : null,
                                        errorText: controller.designationError,
                                      )
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child:
                                      CommonSearchableDropdown<EmployerData>(
                                        items: controller.employerList,
                                        getItemLabel: (d) => d.name.toString(),
                                        getItemValue: (d) => d.id.toString(),
                                        valueId: controller.selectedEmployer,
                                        labelText: "Employer",
                                        searchController: controller.searchController,
                                        onChanged: (val) {
                                          controller.selectedEmployerId = val?.id.toString();
                                          controller.selectedEmployer = val?.name;
                                        },
                                        validator: (val) => val == null ? 'Please select employer' : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              appSizedBox(height: 2.h),

                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10.0),
                                      child: CommonSearchableDropdown<DomainData>(
                                        items: controller.domainList,
                                        getItemLabel: (d) => d.name.toString(),
                                        getItemValue: (d) => d.id.toString(),
                                        valueId: controller.selectedDomain,
                                        labelText: "Domain",
                                        searchController: controller.searchController,
                                        onChanged: (val) {
                                          controller.selectedSubDomain = null;
                                          controller.selectedSubDomainId = null;
                                          controller.subDomainList = [];
                                          controller.skillsList = [];
                                          controller.selectedSkills = [];

                                          controller.update(["add_dialog"]);

                                          controller.selectedDomainId = val?.id.toString();
                                          controller.selectedDomain = val?.name;

                                          if (val != null) {
                                            controller.filterSubDomainsByDomainId(val.id);
                                          }
                                        },
                                        validator: (val) => val == null ? 'Please select Domain' : null,
                                        errorText: controller.selectedDomain == null ? controller.domainError : null,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: CommonSearchableDropdown<SubDomains>(
                                        items: controller.subDomainList,
                                        getItemLabel: (d) => d.name.toString(),
                                        getItemValue: (d) => d.id.toString(),
                                        valueId: controller.selectedSubDomainId,
                                        labelText: "Sub Domain",
                                        searchController: controller.searchController,
                                        onChanged: (val) {
                                          controller.selectedSubDomainId = val?.id.toString();
                                          controller.selectedSubDomain = val?.name;

                                          controller.skillsList = [];
                                          controller.selectedSkills = [];
                                          controller.update(["add_dialog"]);

                                          if (val != null) {
                                            controller.filterSkillsBySubDomainId(val.id);
                                          }
                                        },
                                        validator: (val) => val == null ? 'Please select Sub Domain' : null,
                                        errorText: controller.selectedSubDomainId == null ? controller.domainError : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              appSizedBox(height: 2.h),

                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10.0),
                                      child: GetBuilder<RolesController>(
                                        id: "skills_dropdown",
                                        builder: (controller) {
                                          return FormField<List<String>>(
                                            validator: (val) {
                                              return controller.selectedSkills.isEmpty ? 'Please select at least one Skill' : null;
                                            },
                                            builder: (formFieldState) {
                                              return CommonMultiSelectDropdown<Skills>(
                                                items: controller.skillsList,
                                                selectedIds: controller.selectedSkills,
                                                getId: (member) => member.id.toString(),
                                                getLabel: (member) => member.name ?? '',
                                                labelText: "Skills",
                                                errorText: formFieldState.errorText,
                                                onSelectionChanged: (selected) {
                                                  controller.selectedSkills = selected;
                                                  formFieldState.didChange(selected);
                                                },
                                                isRequired: true,
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: CommonSearchableDropdown<RolesData>(
                                        items: controller.rolesList,
                                        getItemLabel: (r) => r.name.toString(),
                                        getItemValue: (d) => d.id.toString(),
                                        valueId: controller.selectedRole,
                                        labelText: "Role",
                                        searchController: controller.searchController,
                                        onChanged: (val) {
                                          controller.selectedRoleId = val?.id.toString();
                                          controller.selectedRole = val?.name;
                                        },
                                        validator: (val) => val == null ? 'Please select role' : null,
                                        errorText: controller.roleError,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              appSizedBox(height: 2.h),

                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10.0),
                                      child: CommonSearchableDropdown<UsersData>(
                                        items: controller.usersList,
                                        getItemLabel: (d) => "${d.name.toString()} (${d.designation.toString()})",
                                        getItemValue: (d) => d.id.toString(),
                                        valueId: controller.selectedReportingOfficer,
                                        labelText: "Reporting Officer",
                                        searchController: controller.searchController,
                                        onChanged: (val) {
                                          controller.selectedReportingOfficerId = val?.id.toString();
                                          controller.selectedReportingOfficer = val?.name;
                                        },
                                        validator: (val) => val == null ? 'Please select Reporting Officer' : null,
                                        errorText: controller.selectedReportingOfficer == null
                                            ? controller.reportingOfficerError
                                            : null,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: CommonSearchableDropdown<UsersData>(
                                        items: controller.reviewingOfficerList,
                                        getItemLabel: (d) => d.name.toString(),
                                        getItemValue: (d) => d.id.toString(),
                                        valueId: controller.selectedReviewingOfficer,
                                        labelText: "Reviewing Officer",
                                        searchController: controller.searchController,
                                        onChanged: (val) {
                                          controller.selectedReviewingOfficerId = val?.id.toString();
                                          controller.selectedReviewingOfficer = val?.name;
                                        },
                                        validator: (val) => val == null ? 'Please select Reviewing Officer' : null,
                                        errorText: controller.selectedReviewingOfficer == null
                                            ? controller.reviewingOfficerError
                                            : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              appSizedBox(height: 2.h),

                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10.0),
                                      child: CommonSearchableDropdown<DistrictData>(
                                        items: controller.locations,
                                        getItemLabel: (d) => d.name.toString(),
                                        getItemValue: (d) => d.id.toString(),
                                        valueId: controller.selectedLocation,
                                        labelText: "Office Location",
                                        searchController: controller.searchController,
                                        onChanged: (val) {
                                          controller.selectedlocationId = val?.id.toString();
                                          controller.selectedLocation = val?.name;
                                        },
                                        validator: (val) => val == null ? 'Please select office location' : null,
                                        errorText: controller.locationError,
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0, top: 8),
                                      child: FormField<List<String>>(
                                        validator: (val) {
                                          return controller.selectedDivisons.isEmpty ? 'Please select at least one Division' : null;
                                        },
                                        builder: (formFieldState) {
                                          return CommonMultiSelectDropdown<DivisionData>(
                                            items: controller.divList,
                                            selectedIds: controller.selectedDivisons,
                                            getId: (member) => member.id.toString(),
                                            getLabel: (member) => member.name ?? '',
                                            labelText: "Division",
                                            errorText: formFieldState.errorText,
                                            onSelectionChanged: (selected) {
                                              controller.selectedDivisons = selected;
                                              formFieldState.didChange(selected);
                                            },
                                            isRequired: true,
                                          );
                                        },
                                      )
                                    ),
                                  ),
                                ],
                              ),
                              appSizedBox(height: 2.h),

                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10.0),
                                      child: CommonTextFormField(
                                        label: "Salary",
                                        value: controller.salary,
                                        // errorText: controller.nameError,
                                        onChanged: (val) => controller.salary = val,
                                        validator: (val) => val == null || val.isEmpty ? 'Please enter salary' : null,
                                      )
                                    ),
                                  ),

                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0, top: 8),
                                      child: CommonFilePickerField(
                                        labelText: "Upload CV (Optional)",
                                        selectedFileName: controller.selectedFileModel?.fileName ??
                                            controller.selectedFileModel?.file?.path.split('/').last,
                                        onTap: () => controller.pickFile(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              FormField<bool>(
                                validator: (val) {
                                  if ((controller.selectedExperienceYears == 0 || controller.selectedExperienceYears == null) &&
                                      (controller.selectedExperienceMonths == 0 || controller.selectedExperienceMonths == null)) {
                                    return 'Please enter valid experience';
                                  }
                                  return null;
                                },
                                builder: (state) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ExperienceDropdown(
                                        selectedYears: controller.selectedExperienceYears,
                                        selectedMonths: controller.selectedExperienceMonths,
                                        onYearsChanged: (val) {
                                          controller.selectedExperienceYears = val ?? 0;
                                          state.didChange(true); // triggers validation
                                        },
                                        onMonthsChanged: (val) {
                                          controller.selectedExperienceMonths = val ?? 0;
                                          state.didChange(true); // triggers validation
                                        },
                                        errorText: state.errorText,
                                      ),
                                    ],
                                  );
                                },
                              ),

                              appSizedBox(height: 8.h),

                              Center(
                                child: AppButton(
                                  buttonName: 'Submit',
                                  buttonWidth: 250,
                                  onButtonTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      controller.addUserRole(context);
                                    }
                                  },
                                ),
                              ),
                              appSizedBox(height: 3.h),

                            ],
                          )
                          /*
                                                    Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Center(
                                                            child: headerText("Add New User")
                                                        ),
                                                        appSizedBox(height: 2.h),

                                                        CommonTextFormField(
                                                          label: "Name",
                                                          value: controller.name,
                                                          errorText: controller.nameError,
                                                          onChanged: (val) => controller.name = val,
                                                          validator: (val) => val == null || val.isEmpty ? 'Please enter name' : null,
                                                        ),

                                                        appSizedBox(height: 2.h),

                                                        CommonTextFormField(
                                                          label: "Email",
                                                          value: controller.email,
                                                          errorText: controller.emailError,
                                                          onChanged: (val) => controller.email = val,
                                                          validator: (val) {
                                                            if (val == null || val.isEmpty) return 'Please enter email';
                                                            final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
                                                            if (!emailRegex.hasMatch(val)) return 'Enter a valid email';
                                                            return null;
                                                          },
                                                          keyboardType: TextInputType.emailAddress,
                                                        ),

                                                        appSizedBox(height: 2.h),

                                                        CommonTextFormField(
                                                          label: "Mobile Number",
                                                          value: controller.mobile,
                                                          errorText: controller.mobileError,
                                                          onChanged: (val) => controller.mobile = val,
                                                          validator: (val) {
                                                            if (val == null || val.isEmpty) return 'Please enter mobile number';
                                                            if (val.length != 10) return 'Mobile number must be 10 digits';
                                                            return null;
                                                          },
                                                          keyboardType: TextInputType.phone,
                                                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                        ),

                                                        appSizedBox(height: 2.h),

                                                        CommonTextFormField(
                                                          label: "Password",
                                                          errorText: controller.passwordError,
                                                          obscureText: true,
                                                          onChanged: (val) => controller.password = val,
                                                          validator: (val) => val == null || val.isEmpty ? 'Please enter password' : null,
                                                        ),

                                                        appSizedBox(height: 2.h),

                                                        FormField<List<String>>(
                                                          validator: (val) {
                                                            return controller.selectedQualifications.isEmpty && true
                                                                ? 'Please select at least one Qualification'
                                                                : null;
                                                          },
                                                          builder: (formFieldState) {
                                                            return CommonMultiSelectDropdown<QualificationData>(
                                                              items: controller.qualifications,
                                                              selectedIds: controller.selectedQualifications,
                                                              getId: (member) => member.id.toString(),
                                                              getLabel: (member) => member.name ?? '',
                                                              labelText: "Qualification",
                                                              errorText: formFieldState.errorText,
                                                              onSelectionChanged: (selected) {
                                                                controller.selectedQualifications = selected;
                                                                formFieldState.didChange(selected);
                                                              },
                                                              isRequired: true,
                                                            );
                                                          },
                                                        ),

                                                        appSizedBox(height: 2.h),

                                                        FormField<DateTime>(
                                                          validator: (val) {
                                                            if (controller.selectedDOB == null) {
                                                              return 'Please select Date of Birth';
                                                            }
                                                            return null;
                                                          },
                                                          builder: (state) {
                                                            return GetBuilder<RolesController>(
                                                              id: 'dob',
                                                              builder: (controller) {
                                                                return DatePickerFormField(
                                                                  label: "Date of Birth",
                                                                  selectedDate: controller.selectedDOB,
                                                                  errorText: state.errorText,
                                                                  onDateSelected: (val) {
                                                                    controller.selectedDOB = val;
                                                                    controller.update(['dob']);
                                                                    state.didChange(val); // Triggers validation
                                                                  },
                                                                );
                                                              },
                                                            );
                                                          },
                                                        ),

                                                        appSizedBox(height: 2.h),

                                                        FormField<DateTime>(
                                                          validator: (val) {
                                                            if (controller.selectedDOJ == null) {
                                                              return 'Please select Date of Joining';
                                                            }
                                                            return null;
                                                          },
                                                          builder: (state) {
                                                            return GetBuilder<RolesController>(
                                                              id: 'doj',
                                                              builder: (controller) {
                                                                return DatePickerFormField(
                                                                  label: "Date of Joining",
                                                                  selectedDate: controller.selectedDOJ,
                                                                  errorText: state.errorText,
                                                                  onDateSelected: (val) {
                                                                    controller.selectedDOJ = val;
                                                                    controller.update(['doj']);
                                                                    state.didChange(val); // Triggers validation
                                                                  },
                                                                );
                                                              },
                                                            );
                                                          },
                                                        ),

                                                        appSizedBox(height: 2.h),

                                                        CommonSearchableDropdown<DepartmentData>(
                                                          items: controller.departmentList,
                                                          getItemLabel: (d) => d.name.toString(),
                                                          getItemValue: (d) => d.id.toString(),
                                                          valueId: controller.selectedDepartment,
                                                          labelText: "Deployment Location",
                                                          searchController: controller.searchController,
                                                          onChanged: (val) {
                                                            controller.selectedDepartmentId = val?.id.toString();
                                                            controller.selectedDepartment = val?.name;
                                                          },
                                                          validator: (val) => val == null ? 'Please select department' : null,
                                                        ),

                                                        appSizedBox(height: 2.h),

                                                        CommonSearchableDropdown<DesignationData>(
                                                          items: controller.designationList,
                                                          getItemLabel: (d) => d.name.toString(),
                                                          getItemValue: (d) => d.id.toString(),
                                                          valueId: controller.selectedDesignation,
                                                          labelText: "Designation",
                                                          searchController: controller.searchController,
                                                          onChanged: (val) {
                                                            controller.selectedDesignationId = val?.id.toString();
                                                            controller.selectedDesignation = val?.name;
                                                          },
                                                          validator: (val) => val == null ? 'Please select designation' : null,
                                                          errorText: controller.designationError,
                                                        ),

                                                        appSizedBox(height: 2.h),

                                                        CommonSearchableDropdown<EmployerData>(
                                                          items: controller.employerList,
                                                          getItemLabel: (d) => d.name.toString(),
                                                          getItemValue: (d) => d.id.toString(),
                                                          valueId: controller.selectedEmployer,
                                                          labelText: "Employer",
                                                          searchController: controller.searchController,
                                                          onChanged: (val) {
                                                            controller.selectedEmployerId = val?.id.toString();
                                                            controller.selectedEmployer = val?.name;
                                                          },
                                                          validator: (val) => val == null ? 'Please select employer' : null,
                                                          //errorText: controller.designationError,
                                                        ),

                                                        appSizedBox(height: 2.h),

                                                        CommonSearchableDropdown<DomainData>(
                                                          items: controller.domainList,
                                                          getItemLabel: (d) => d.name.toString(),
                                                          getItemValue: (d) => d.id.toString(), // 👈 how to compare
                                                          valueId: controller.selectedDomain,
                                                          labelText: "Domain",
                                                          searchController: controller.searchController,
                                                          onChanged: (val) {
                                                            // Reset subdomain and skills
                                                            controller.selectedSubDomain = null;
                                                            controller.selectedSubDomainId = null;
                                                            controller.subDomainList = [];
                                                            controller.skillsList = [];
                                                            controller.selectedSkills = [];

                                                            // Call update to refresh UI parts depending on subdomain/skills
                                                            controller.update(["add_dialog"]);

                                                            controller.selectedDomainId = val?.id.toString();
                                                            controller.selectedDomain = val?.name;

                                                            if (val != null) {
                                                              controller.filterSubDomainsByDomainId(val.id);
                                                            }
                                                          },
                                                          validator: (val) => val == null ? 'Please select Domain' : null,
                                                          errorText: controller.selectedDomain == null ? controller.domainError : null,
                                                        ),

                                                        appSizedBox(height: 2.h),

                                                        CommonSearchableDropdown<SubDomains>(
                                                          items: controller.subDomainList,
                                                          getItemLabel: (d) => d.name.toString(),
                                                          getItemValue: (d) => d.id.toString(), // 👈 how to compare
                                                          valueId: controller.selectedSubDomainId, // 👈 selected value's ID
                                                          labelText: "Sub Domain",
                                                          searchController: controller.searchController,
                                                          onChanged: (val) {
                                                            controller.selectedSubDomainId = val?.id.toString();
                                                            controller.selectedSubDomain = val?.name;

                                                            controller.skillsList = [];
                                                            controller.selectedSkills = [];
                                                            controller.update(["add_dialog"]);

                                                            if (val != null) {
                                                              controller.filterSkillsBySubDomainId(val.id);
                                                            }
                                                          },
                                                          validator: (val) => val == null ? 'Please select Sub Domain' : null,
                                                          errorText: controller.selectedSubDomainId == null ? controller.domainError : null,
                                                        ),

                                                        appSizedBox(height: 2.h),

                                                        GetBuilder<RolesController>(
                                                          id: "skills_dropdown",
                                                          builder: (controller) {
                                                            return FormField<List<String>>(
                                                              validator: (val) {
                                                                return controller.selectedSkills.isEmpty ? 'Please select at least one Skill' : null;
                                                              },
                                                              builder: (formFieldState) {
                                                                return CommonMultiSelectDropdown<Skills>(
                                                                  items: controller.skillsList,
                                                                  selectedIds: controller.selectedSkills,
                                                                  getId: (member) => member.id.toString(),
                                                                  getLabel: (member) => member.name ?? '',
                                                                  labelText: "Skills",
                                                                  errorText: formFieldState.errorText,
                                                                  onSelectionChanged: (selected) {
                                                                    controller.selectedSkills = selected;
                                                                    formFieldState.didChange(selected);
                                                                  },
                                                                  isRequired: true,
                                                                );
                                                              },
                                                            );
                                                          },
                                                        ),

                                                        appSizedBox(height: 2.h),

                                                        CommonSearchableDropdown<RolesData>(
                                                          items: controller.rolesList,
                                                          getItemLabel: (r) => r.name.toString(),
                                                          getItemValue: (d) => d.id.toString(),
                                                          valueId: controller.selectedRole,
                                                          labelText: "Role",
                                                          searchController: controller.searchController,
                                                          onChanged: (val) {
                                                            controller.selectedRoleId = val?.id.toString();
                                                            controller.selectedRole = val?.name;
                                                          },
                                                          validator: (val) => val == null ? 'Please select role' : null,
                                                          errorText: controller.roleError,
                                                        ),

                                                        appSizedBox(height: 2.h),

                                                        CommonSearchableDropdown<UsersData>(
                                                          items: controller.usersList,
                                                          getItemLabel: (d) => "${d.name.toString()} (${d.designation.toString()})",
                                                          getItemValue: (d) => d.id.toString(),
                                                          valueId: controller.selectedReportingOfficer,
                                                          labelText: "Reporting Officer",
                                                          searchController: controller.searchController,
                                                          onChanged: (val) {
                                                            controller.selectedReportingOfficerId = val?.id.toString();
                                                            controller.selectedReportingOfficer = val?.name;
                                                          },
                                                          validator: (val) => val == null ? 'Please select Reporting Officer' : null,
                                                          errorText: controller.selectedReportingOfficer == null
                                                              ? controller.reportingOfficerError
                                                              : null,
                                                        ),

                                                        appSizedBox(height: 2.h),

                                                        CommonSearchableDropdown<UsersData>(
                                                          items: controller.reviewingOfficerList,
                                                          getItemLabel: (d) => d.name.toString(),
                                                          getItemValue: (d) => d.id.toString(),
                                                          valueId: controller.selectedReviewingOfficer,
                                                          labelText: "Reviewing Officer",
                                                          searchController: controller.searchController,
                                                          onChanged: (val) {
                                                            controller.selectedReviewingOfficerId = val?.id.toString();
                                                            controller.selectedReviewingOfficer = val?.name;
                                                          },
                                                          validator: (val) => val == null ? 'Please select Reviewing Officer' : null,
                                                          errorText: controller.selectedReviewingOfficer == null
                                                              ? controller.reviewingOfficerError
                                                              : null,
                                                        ),

                                                        CommonSearchableDropdown<DistrictData>(
                                                          items: controller.locations,
                                                          getItemLabel: (d) => d.name.toString(),
                                                          getItemValue: (d) => d.id.toString(),
                                                          valueId: controller.selectedLocation,
                                                          labelText: "Office Location",
                                                          searchController: controller.searchController,
                                                          onChanged: (val) {
                                                            controller.selectedlocationId = val?.id.toString();
                                                            controller.selectedLocation = val?.name;
                                                          },
                                                          validator: (val) => val == null ? 'Please select office location' : null,
                                                          errorText: controller.locationError,
                                                        ),

                                                        const SizedBox(height: 10),

                                                        FormField<bool>(
                                                          validator: (val) {
                                                            if ((controller.selectedExperienceYears == 0 || controller.selectedExperienceYears == null) &&
                                                                (controller.selectedExperienceMonths == 0 || controller.selectedExperienceMonths == null)) {
                                                              return 'Please enter valid experience';
                                                            }
                                                            return null;
                                                          },
                                                          builder: (state) {
                                                            return Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                ExperienceDropdown(
                                                                  selectedYears: controller.selectedExperienceYears,
                                                                  selectedMonths: controller.selectedExperienceMonths,
                                                                  onYearsChanged: (val) {
                                                                    controller.selectedExperienceYears = val ?? 0;
                                                                    state.didChange(true); // triggers validation
                                                                  },
                                                                  onMonthsChanged: (val) {
                                                                    controller.selectedExperienceMonths = val ?? 0;
                                                                    state.didChange(true); // triggers validation
                                                                  },
                                                                  errorText: state.errorText,
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        ),

                                                        appSizedBox(height: 2.h),

                                                        CommonFilePickerField(
                                                          labelText: "Upload CV (Optional)",
                                                          selectedFileName: controller.selectedFileModel?.fileName ??
                                                              controller.selectedFileModel?.file?.path.split('/').last,
                                                          onTap: () => controller.pickFile(),
                                                        ),

                                                        const SizedBox(height: 30),

                                                        Center(
                                                          child: app_button.AppButton(
                                                            buttonName: 'Submit',
                                                            buttonWidth: 250,
                                                            onButtonTap: (){
                                                              if (_formKey.currentState!.validate()) {
                                                                controller.addUserRole(context);
                                                              }
                                                            },
                                                          )
                                                        )
                                                      ],
                                                    ),*/
                        );
                      },
                    )
                ),
              )
          ),
      )
    );
  }
}


