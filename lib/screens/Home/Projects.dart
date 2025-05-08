import 'package:performance_management_system/pms.dart';

class ProjectTable extends StatelessWidget {
  final ProjectController controller = Get.put(ProjectController());

  final Function(ProjectsData project) onViewTasksPressed;

  ProjectTable({Key? key, required this.onViewTasksPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectController>(
      id: 'home',
      initState: (_) {
        controller.fetchProjects();
        controller.fetchTechLead();
        controller.fetchMembers();
      },
      builder: (_) {
        if (controller.loader) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Center(child: CircularProgressIndicator()),
          );
        } else {
          final paginatedTasks = controller.paginatedProjects;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _buildTopControls(controller, context),
                const SizedBox(height: 10),
                Table(
                  border: TableBorder.all(color: Colors.grey),
                  columnWidths: const {
                    0: FixedColumnWidth(60),
                    8: FixedColumnWidth(120),
                  },
                  children: [
                    _buildHeaderRow(),
                    ...paginatedTasks
                        .map((task) => _buildDataRow(task, controller, context))
                        .toList(),
                  ],
                ),
                if (paginatedTasks.isEmpty)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: NoDataWidget(
                    title: "No Projects Available!",
                    subtitle: "Projects will appear here once added",
                    icon: Icons.task_alt_outlined,
                  ),
                  ),
                if (paginatedTasks.isNotEmpty) const SizedBox(height: 10),
                if (paginatedTasks.isNotEmpty)
                  _buildPaginationControls(controller),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildTopControls(ProjectController controller, BuildContext context) {
    return Row(
      children: [
        // Rows per page dropdown
        Row(
          children: [
            Text('Show'),
            appSizedBox(width: 0.5.w),
            Theme(
              data: Theme.of(context).copyWith(
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    dropdownColor: Colors.white,
                    // Optional: set to match your UI
                    value: controller.rowsPerPage,
                    isDense: true,
                    onChanged: (value) {
                      if (value != null) {
                        controller.changeRowsPerPage(value);
                      }
                    },
                    items:
                        controller.rowsPerPageOptions.toSet().toList().map((
                          int value,
                        ) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                  ),
                ),
              ),
            ),
            appSizedBox(width: 0.5.w),
            Text('entries'),
          ],
        ),

        /*// Export Buttons (functionality can be added later)
        // ⬇️ CSV Export
        IconButton(
          icon: const Icon(Icons.download, color: Colors.blueAccent),
          tooltip: "Export CSV",
          onPressed: (){

          },
        ),

        // 🖨 Print
        IconButton(
          icon: const Icon(Icons.print, color: Colors.green),
          tooltip: "Print Table",
          onPressed: (){

          },
        ),*/
        const Spacer(),
        // Search Field
        SizedBox(
          width: 250,
          child: TextField(
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 12,
              ),
              hintText: "Search...",
              prefixIcon: const Icon(Icons.search, size: 20),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade600),
              ),
            ),
            onChanged: controller.filterTasks,
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  TableRow _buildHeaderRow() {
    var style = styleW600S14;
    return TableRow(
      decoration: const BoxDecoration(color: Color(0xFFF0F0F0)),
      children: [
        _cell('#', style),
        _cell('Project', style),
        _cell('Tasks', style),
        _cell('Milestones', style),
        _cell('Responsible Executor', style),
        _cell('Status', style),
        _cell('Start Date', style),
        _cell('Expected Completion Date', style),
        _cell('Action', style),
      ],
    );
  }

  TableRow _buildDataRow(
    ProjectsData data,
    ProjectController controller,
    BuildContext context,
  ) {
    var style = styleW400S13;
    final index = controller.paginatedProjects.indexOf(data) + 1;
    final srNo = controller.currentPage * controller.rowsPerPage + index;
    return TableRow(
      children: [
        _cell(srNo.toString(), style),
        _cell(data.name?.toString().capitalizeFirst ?? '', style),
        _cell(data.taskCount.toString(), style),
        _cell(data.milestoneCount.toString(), style),
        _cell(data.teamLeadName?.toString().capitalizeFirst ?? '', style),
        _cell(data.status ?? "New", style),
        _cell(formatDateString(data.startDate!), style),
        _cell(formatDateString(data.dateCompletion!), style),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: () {
              return ElevatedButton(
                onPressed: () => onViewTasksPressed(data),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorRes.appBlueColor,
                ),
                child: const Text(
                  "View",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }(),
          ),
        ),
      ],
    );
  }

  Widget _buildPaginationControls(ProjectController controller) {
    final totalPages =
        ((controller.filteredTasks.length / controller.rowsPerPage).ceil())
            .clamp(1, double.infinity)
            .toInt();
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed:
              controller.currentPage > 0 ? controller.previousPage : null,
          icon: const Icon(Icons.chevron_left),
        ),
        Text("Page ${controller.currentPage + 1} of $totalPages"),
        IconButton(
          onPressed:
              (controller.currentPage + 1) * controller.rowsPerPage <
                      controller.filteredTasks.length
                  ? controller.nextPage
                  : null,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }

  static Widget _cell(String text, [TextStyle? style]) {
    return Container(
      height: 60, // You can adjust the height as needed
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      child: Text(text, style: style,
          textAlign: TextAlign.center,
        softWrap: true,
        overflow: TextOverflow.visible,
        maxLines: null),
    );
  }
}

class AddProjectDialog extends StatefulWidget {
  @override
  _AddProjectDialogState createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  final ProjectController controller = Get.put(ProjectController());
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
  void initState() {
    super.initState();
    controller.resetForm();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: SizedBox(
        width: isWeb ? 600 : double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: GetBuilder<ProjectController>(
              id: 'add_dialog',
              builder: (_) {
                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "New Project",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: ColorRes.appBlueColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: buildInputDecoration(
                                labelText: "Project Title",
                                errorText: controller.projectTitleError,
                              ),
                              onChanged: (val) => controller.projectTitle = val,
                              validator:
                                  (val) =>
                                      val == null || val.isEmpty
                                          ? 'Please enter project title'
                                          : null,
                            ),
                          ),
                          const SizedBox(width: 25),
                          Expanded(
                            child: DropdownButtonFormField2<TeamMemberData>(
                              isExpanded: true,
                              decoration: buildInputDecoration(
                                labelText: "Team Lead",
                                errorText: controller.teamLeadError,
                              ),
                              items:
                                  controller.teamMemberList.map((
                                      TeamMemberData user,
                                  ) {
                                    return DropdownMenuItem<TeamMemberData>(
                                      value: user,
                                      child: Text('${user.name.toString()} (${user.designation.toString()})'),
                                    );
                                  }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  controller.selectedTeamLead = val?.id.toString();
                                });
                              },
                              validator:
                                  (val) =>
                                      val == null
                                          ? 'Please select team lead'
                                          : null,
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      MultiSelectDropdown(
                        allMembers: controller.teamMemberList,
                        selectedMemberIds: controller.selectedMembers,
                        onSelectionChanged: (selectedIds) {
                          setState(() {
                            controller.selectedMembers = selectedIds;
                          });
                          print("Selected Member IDs: $selectedIds");
                        },
                      ),
                      const SizedBox(height: 25),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField2<String>(
                              isExpanded: true,
                              decoration: buildInputDecoration(
                                labelText: "Department Type",
                                errorText: controller.departmentTypeError,
                              ),
                              value: controller.departmentType,
                              items:
                                  controller.departmentData.keys.map((type) {
                                    return DropdownMenuItem<String>(
                                      value: type,
                                      child: Text(type),
                                    );
                                  }).toList(),
                              onChanged: (val) async {
                                setState(() {
                                  controller.departmentType = val;
                                  controller.departmentName = null;
                                });
                                await controller.fetchDepartments(val!);
                              },
                              validator:
                                  (val) =>
                                      val == null
                                          ? 'Please select department type'
                                          : null,
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonFormField2<String>(
                              isExpanded: true,
                              decoration: buildInputDecoration(
                                labelText: "Department Name",
                                errorText: controller.departmentNameError,
                              ),
                              value: controller.departmentName,

                              items:
                                  controller.fetchedDepartments.map((name) {
                                    return DropdownMenuItem<String>(
                                      value: name,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 12,
                                        ),
                                        constraints: const BoxConstraints(
                                          minHeight: 60,
                                        ),
                                        child: Text(
                                          name,
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),

                              // 👇 Add this section to control selected value view in field
                              selectedItemBuilder: (context) {
                                return controller.fetchedDepartments.map((
                                  name,
                                ) {
                                  return Text(
                                    name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 14),
                                  );
                                }).toList();
                              },

                              onChanged: (val) {
                                setState(() {
                                  controller.departmentName = val;
                                });
                              },
                              validator:
                                  (val) =>
                                      val == null
                                          ? 'Please select department name'
                                          : null,

                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 300,
                                width: 350,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              dropdownSearchData: DropdownSearchData(
                                searchController: controller.searchController,
                                searchInnerWidget: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: TextField(
                                    controller: controller.searchController,
                                    decoration: InputDecoration(
                                      hintText: 'Search department...',
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 8,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                                searchInnerWidgetHeight: 50,
                                searchMatchFn: (item, searchValue) {
                                  return item.value!.toLowerCase().contains(
                                    searchValue.toLowerCase(),
                                  );
                                },
                              ),
                              onMenuStateChange: (isOpen) {
                                if (!isOpen) {
                                  controller.searchController.clear();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => controller.selectDate(context, true),
                              child: InputDecorator(
                                decoration: buildInputDecoration(
                                  labelText: "Start Date",
                                  errorText: controller.startDateError,
                                  suffixIcon: Icon(Icons.calendar_today),
                                ),
                                child: Text(
                                  controller.startDate == null
                                      ? ""
                                      : "${controller.startDate!.day}/${controller.startDate!.month}/${controller.startDate!.year}",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: InkWell(
                              onTap:
                                  () => controller.selectDate(context, false),
                              child: InputDecorator(
                                decoration: buildInputDecoration(
                                  labelText: "Expected date of completion",
                                  errorText: controller.endDateError,
                                  suffixIcon: Icon(Icons.calendar_today),
                                ),
                                child: Text(
                                  controller.endDate == null
                                      ? ""
                                      : "${controller.endDate!.day}/${controller.endDate!.month}/${controller.endDate!.year}",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        height: 60,
                        child: InkWell(
                          onTap: () => controller.pickFile(),
                          child: InputDecorator(
                            decoration: buildInputDecoration(
                              labelText: "Upload File (Optional)",
                              suffixIcon: const Icon(Icons.attach_file),
                            ),child: Text(
                            controller.selectedFileModel?.fileName ??
                                controller.selectedFileModel?.file?.path.split('/').last ??
                                "No file selected",
                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                            overflow: TextOverflow.ellipsis,
                          ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
                        maxLines: 3,
                        decoration: buildInputDecoration(
                          labelText: "Project Overview",
                          errorText: controller.projectOverviewError,
                        ).copyWith(
                          hintText:
                              "Submit Your Project Information - Project Name, Due Date and any other details",
                          alignLabelWithHint: true,
                        ),
                        onChanged: (val) => controller.projectOverview = val,
                        validator:
                            (val) =>
                                val == null || val.trim().isEmpty
                                    ? 'Please enter project description'
                                    : null,
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              controller.addProject(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorRes.appBlueColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text("Submit"),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class MultiSelectDropdown extends StatefulWidget {
  final List<TeamMemberData> allMembers;
  final List<String> selectedMemberIds;
  final Function(List<String>) onSelectionChanged;
  final String? errorText;
  final String labelText;

  MultiSelectDropdown({
    required this.allMembers,
    required this.selectedMemberIds,
    required this.onSelectionChanged,
    this.errorText,
    this.labelText = "Assign Members",
  });

  @override
  _MultiSelectDropdownState createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
  final TextEditingController _controller = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final GlobalKey _key = GlobalKey();

  late List<String> _tempSelected;

  @override
  void initState() {
    super.initState();
    _tempSelected = List.from(widget.selectedMemberIds);
    _updateControllerText();
  }

  void _updateControllerText() {
    _controller.text = widget.allMembers
        .where((member) => _tempSelected.contains(member.id.toString()))
        .map((member) => member.name ?? '')
        .join(', ');
  }

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  void _closeDropdown() {
    widget.onSelectionChanged(_tempSelected);
    _updateControllerText();
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) {
        return Positioned(
          left: offset.dx,
          top: offset.dy + size.height + 5,
          width: size.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0.0, size.height + 5),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: StatefulBuilder(
                builder: (context, setOverlayState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 250),
                        child: ListView(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          children:
                              widget.allMembers.map((member) {
                                final id = member.id.toString();
                                final name = member.name ?? '';
                                final designation = member.designation ?? '';
                                final isSelected = _tempSelected.contains(id);

                                return CheckboxListTile(
                                  title: Text('$name ($designation)', style: styleW400S14),
                                  value: isSelected,
                                  onChanged: (bool? value) {
                                    setOverlayState(() {
                                      if (value == true) {
                                        _tempSelected.add(id);
                                      } else {
                                        _tempSelected.remove(id);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(8),
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: _closeDropdown,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorRes.appBlueColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            elevation: 2,
                          ),
                          child: const Text(
                            "Done",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: AbsorbPointer(
          child: TextFormField(
            key: _key,
            controller: _controller,
            readOnly: true,
            decoration: InputDecoration(
              labelText: widget.labelText,
              errorText: widget.errorText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              suffixIcon: Icon(Icons.arrow_drop_down),
            ),
          ),
        ),
      ),
    );
  }
}
