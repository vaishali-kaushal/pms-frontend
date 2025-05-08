import 'package:performance_management_system/pms.dart';

class TaskListTable extends StatelessWidget {
  final String projectId;
  final TaskController controller = Get.put(TaskController());

  TaskListTable({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(
      id: 'home',
      initState: (_) {
        controller.fetchTasks(projectId);
        controller.fetchProjects();
        if (projectId.trim().isNotEmpty) {
          controller.selectedProjectId = projectId;
        }
      },
      builder: (_) {
        if (controller.loader) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: const Center(child: CircularProgressIndicator()),
          );
        } else {
          final paginatedTasks = controller.paginatedTasks;

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
                      title: "No Tasks Available!",
                      subtitle: "Tasks will appear here once added",
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

  Widget _buildTopControls(TaskController controller, BuildContext context) {
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
              hintText: "Search tasks...",
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
        _cell('Task', style),
        _cell('Project', style),
        if (PrefService.getString(PrefKeys.role).toLowerCase() != "team member")
          _cell('Assigned To', style),
        _cell('Priority', style),
        _cell('Timelines', style),
        _cell('Status', style),
        _cell('Action', style),
      ],
    );
  }

  TableRow _buildDataRow(
    TaskData task,
    TaskController controller,
    BuildContext context,
  ) {
    var style = styleW400S13;
    final index = controller.paginatedTasks.indexOf(task) + 1;
    final srNo = controller.currentPage * controller.rowsPerPage + index;

    // Priority background color
    Color? priorityColor;
    switch (task.priority?.toLowerCase()) {
      case 'high':
        priorityColor = Colors.red.shade200;
        break;
      case 'medium':
        priorityColor = Colors.orange.shade200;
        break;
      case 'low':
        priorityColor = Colors.green.shade200;
        break;
      default:
        priorityColor = Colors.grey.shade200;
    }

    // Status background color
    Color? statusBgColor;
    switch (task.status?.toLowerCase()) {
      case 'completed':
        statusBgColor = Colors.green.shade200;
        break;
      case 'pending':
        statusBgColor = Colors.orange.shade200;
        break;
      case 'delayed':
        statusBgColor = Colors.red.shade200;
        break;
      case 'in progress':
        statusBgColor = Colors.blue.shade200;
        break;
      case 'verified':
        statusBgColor = Colors.purple.shade200;
        break;
      case 'under review':
        statusBgColor = Colors.red.shade200;
        break;
      case 'reviewed':
        statusBgColor = Colors.indigo.shade200;
        break;
      default:
        statusBgColor = Colors.teal.shade200; // updated from grey
    }

    return TableRow(
      children: [
        _cell(srNo.toString(), style),
        _cell(task.name ?? '', style),
        _cell(task.projectName ?? '', style),
        if (PrefService.getString(PrefKeys.role).toLowerCase() != "team member")
          _cell("${task.assignedTo} ( ${task.designation})" ?? '', style),
        _cell(task.priority ?? '', style, priorityColor), // priority bg
        _cell(
          "${formatDateString(task.startDate)} - ${formatDateString(task.endDate)}",
          style.copyWith(fontSize: 12)
        ),
        _cell(task.status ?? '', styleW500S13, statusBgColor),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: () {
              final role = PrefService.getString(PrefKeys.role).toLowerCase();
              final status = task.status;

              if (role == "team member" && status == "Pending") {
                return ElevatedButton(
                  onPressed:
                      () => showRightSideVerifyDialog(
                        context,
                        task,
                        controller,
                        status: 'Initiate',
                        role: role,
                      ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    "Initiate Task",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else if (role == "team member" && status == "In Progress") {
                return ElevatedButton(
                  onPressed:
                      () => showRightSideVerifyDialog(
                        context,
                        task,
                        controller,
                        status: 'Complete',
                        role: role,
                      ),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text(
                    "Submit Task",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                );
              } else if (role == "project manager" && status == "Completed") {
                return ElevatedButton(
                  onPressed:
                      () => showRightSideVerifyDialog(
                        context,
                        task,
                        controller,
                        status: 'Verify',
                        role: role,
                      ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                  child: const Text(
                    "Verify Task",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              return ElevatedButton(
                onPressed:
                    () => showRightSideVerifyDialog(
                      context,
                      task,
                      controller,
                      status: 'View',
                      role: role,
                    ),
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
}

Widget _buildPaginationControls(TaskController controller) {
  final totalPages =
      ((controller.filteredTasks.length / controller.rowsPerPage).ceil())
          .clamp(1, double.infinity)
          .toInt();
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      IconButton(
        onPressed: controller.currentPage > 0 ? controller.previousPage : null,
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

Widget _cell(String text, [TextStyle? style, Color? backgroundColor]) {
  return Container(
    height: 60,
    alignment: Alignment.center,
    padding: const EdgeInsets.all(8.0),
    child:
        backgroundColor != null
            ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                text,
                style:
                    style?.copyWith(color: Colors.white) ??
                    const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
                softWrap: true,
                overflow: TextOverflow.visible,
                maxLines: null,
              ),
            )
            : Text(text, style: style, textAlign: TextAlign.center),
  );
}

Widget _infoRow(String title, String value) {
  Color getStatusColor(String status) {
    switch (status) {
      case "Completed":
        return Colors.green;
      case "Pending":
        return Colors.orange;
      case "Delayed":
        return Colors.red;
      case "In Progress":
        return Colors.blueAccent;
      case "Verified":
        return Colors.blueAccent;
      default:
        return Colors.blueAccent;
    }
  }

  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 14, color: Colors.black),
        children: [
          TextSpan(
            text: "$title: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: value,
            style: title == "Status"
                    ? styleW400S14.copyWith(color: getStatusColor(value))
                    : styleW400S14,
          ),
        ],
      ),
    ),
  );
}

void showRightSideVerifyDialog(
  BuildContext context,
  TaskData task,
  TaskController controller, {
  required String status, // "View" or "Verify"
  required String role,
}) {
  print("status $status");
  controller.remarks = null;
  controller.nextDueDate = null;
  bool isNotVerified = false;

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Task Details",
    pageBuilder:
        (_, __, ___) => Align(
          alignment: Alignment.centerRight,
          child: Material(
            color: Colors.white,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: double.infinity,
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: constraints.maxHeight),
                          child: IntrinsicHeight(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Top Row (Header)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Task Details", style: styleW600S18),
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                                // Task Info
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          _infoRow("Project", task.projectName.toString()),
                                          _infoRow("Task", task.name.toString()),
                                          _infoRow("Milestone", task.milestoneName ?? ''),
                                          _infoRow("Priority", task.priority.toString()),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          _infoRow("Assigned To", task.assignedTo.toString()),
                                          _infoRow("Start Date", formatDateString(task.startDate)),
                                          _infoRow("Target Date", formatDateString(task.endDate)),
                                          _infoRow("Status", task.status.toString()),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                // Timeline
                                if (task.statusLogs != null && task.statusLogs!.isNotEmpty)
                                  StatusTimeline<StatusLogs>(
                                    logs: task.statusLogs!,
                                    getStatus: (log) => log.status,
                                    getStatusUpdatedAt: (log) => log.statusUpdatedAt,
                                    getRemarks: (log) => log.remarks,
                                    getDueDate: (log) => log.dueDate,
                                    titleStyle: styleW600S16,
                                    statusStyle: styleW500S15,
                                    dateStyle: styleW400S12.copyWith(color: ColorRes.greyColor),
                                    labelStyle: styleW500S13,
                                    valueStyle: styleW400S13,
                                  ),

                                if (status == "Verify" && isNotVerified)
                                  const SizedBox(height: 20),

                                if (status == "Verify" && isNotVerified)
                                  GestureDetector(
                                    onTap: () => controller.selectDate(context, false),
                                    child: AbsorbPointer(
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          labelText: "Next Review Date",
                                          errorText: controller.dueDateError,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          suffixIcon: const Icon(Icons.calendar_today),
                                        ),
                                        controller: TextEditingController(
                                          text: controller.nextDueDate == null
                                              ? ""
                                              : "${controller.nextDueDate!.day}-${controller.nextDueDate!.month}-${controller.nextDueDate!.year}",
                                        ),
                                        readOnly: true,
                                      ),
                                    ),
                                  ),

                                if (status == "Verify" || status == "Complete" || status == "Initiate")
                                  const SizedBox(height: 10),

                                if (status == "Verify" || status == "Complete" || status == "Initiate")
                                  TextFormField(
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      labelText: "Remarks",
                                      errorText: controller.remarksError,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      alignLabelWithHint: true,
                                    ),
                                    onChanged: (val) => controller.remarks = val,
                                  ),

                                const SizedBox(height: 30), // spacing before buttons

                                // --- Footer (appears at the bottom of content) ---
                                if (status == "Verify")
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                          onPressed: () async {
                                            await controller.updateTaskStatus(
                                              task.projectId.toString(),
                                              task.id.toString(),
                                              "Verified",
                                              '',
                                            );
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Approve", style: TextStyle(color: Colors.white)),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                          onPressed: () async {
                                            setState(() => isNotVerified = true);
                                            if (controller.nextDueDate == null) {
                                              final picked = await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime(2100),
                                                helpText: 'Select Next Review Date',
                                              );
                                              if (picked != null) {
                                                controller.nextDueDate = picked;
                                                setState(() {});
                                              }
                                            }
                                            if (controller.nextDueDate != null) {
                                              if (controller.remarks == null || controller.remarks!.isEmpty) {
                                                controller.remarksError = "Please enter remarks";
                                                setState(() {});
                                              } else {
                                                await controller.updateTaskStatus(
                                                  task.projectId.toString(),
                                                  task.id.toString(),
                                                  "Rejected",
                                                  controller.nextDueDate.toString().trim(),
                                                );
                                                Navigator.pop(context);
                                              }
                                            }
                                          },
                                          child: const Text("Reject", style: TextStyle(color: Colors.white)),
                                        ),
                                      ),
                                    ],
                                  ),

                                if (role == "team member" && status == "Initiate")
                                  Center(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        controller.updateTaskStatus(
                                          task.projectId.toString(),
                                          task.id.toString(),
                                          "In Progress",
                                          '',
                                        );
                                        Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                      child: const Text("Initiate Task", style: TextStyle(color: Colors.white)),
                                    ),
                                  ),

                                if (role == "team member" && status == "Complete")
                                  Center(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        controller.updateTaskStatus(
                                          task.projectId.toString(),
                                          task.id.toString(),
                                          "Under Review",
                                          '',
                                        );
                                        Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                      child: const Text(
                                          "Submit for Review",
                                          style: TextStyle(color: Colors.white, fontSize: 12)),
                                    ),
                                  ),
                                appSizedBox(height: 1.h),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

            ),
          ),
        ),
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(anim),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

class AddTaskDialog extends StatefulWidget {
  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TaskController controller = Get.find<TaskController>();

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
    controller.resetTaskForm();
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.zero,
      child: SizedBox(
        width: double.infinity,
        child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(scrollbars: true),
            child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: GetBuilder<TaskController>(
                    id: 'add_dialog',
                    builder: (_) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "Add New Task",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Task Title
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Task Title",
                              errorText: controller.taskTitleError,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: (val) => controller.taskTitle = val,
                          ),
                          const SizedBox(height: 20),

                          DropdownButtonFormField<String>(
                            value:
                            controller.selectedProjectId.isEmpty
                                ? null
                                : controller.selectedProjectId,
                            decoration: InputDecoration(
                              labelText: "Select Project",
                              errorText: controller.selectedProjectError,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items:
                            controller.fetchedProjects.map((project) {
                              return DropdownMenuItem<String>(
                                value:
                                project['id'].toString(), // should be String
                                child: Text(project['name']),
                              );
                            }).toList(),
                            onChanged: (val) {
                              controller.selectedProjectId = val!;
                              controller.fetchMilestones(val);
                              controller.fetchMembers(val);
                            },
                          ),
                          const SizedBox(height: 20),

                          DropdownButtonFormField<String>(
                            value:
                            controller.milestoneList.any(
                                  (m) =>
                              m.id.toString() ==
                                  controller.selectedMilestoneId,
                            )
                                ? controller.selectedMilestoneId
                                : null,
                            decoration: InputDecoration(
                              labelText: "Select Milestone",
                              errorText: controller.selectedMilestoneIdError,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items:
                            controller.milestoneList.map((milestone) {
                              return DropdownMenuItem<String>(
                                value: milestone.id.toString(),
                                child: Text(milestone.name.toString()),
                              );
                            }).toList(),
                            onChanged: (val) {
                              controller.selectedMilestoneId = val!;
                            },
                          ),

                          const SizedBox(height: 20),

                          // Single Member Dropdown
                          DropdownButtonFormField<String>(
                            value:
                            controller.selectedMemberId.isEmpty
                                ? null
                                : controller.selectedMemberId,
                            decoration: InputDecoration(
                              labelText: "Assign Member",
                              errorText: controller.assignedMembersError,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items:
                            controller.teamMemberList.map((member) {
                              return DropdownMenuItem<String>(
                                value: member.id.toString(), // should be String
                                child: Text('${member.name.toString()} (${member.designation.toString()})'),
                              );
                            }).toList(),
                            onChanged: (val) {
                              controller.selectedMemberId = val!;
                            },
                          ),

                          /*  MultiSelectDropdown(
                            allMembers: {
                              for (var e in controller.teamMemberList)
                                e.id!.toString(): e.name.toString() ?? '',
                            },
                            selectedMemberIds: controller.assignedMemberIds,
                            onSelectionChanged: (selectedIds) {
                              setState(() {
                                controller.assignedMemberIds = selectedIds;
                              });
                            },
                            errorText: controller.assignedMembersError,
                          ),*/
                          const SizedBox(height: 20),

                          // Start Date & Due Date (Fixed)
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => controller.selectDate(context, true),
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: "Start Date",
                                        errorText: controller.startDateError,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        suffixIcon: Icon(Icons.calendar_today),
                                      ),
                                      controller: TextEditingController(
                                        text:
                                        controller.startDate == null
                                            ? ""
                                            : "${controller.startDate!.day}-${controller.startDate!.month}-${controller.startDate!.year}",
                                      ),
                                      readOnly: true,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => controller.selectDate(context, false),
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: "Due Date",
                                        errorText: controller.dueDateError,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        suffixIcon: Icon(Icons.calendar_today),
                                      ),
                                      controller: TextEditingController(
                                        text:
                                        controller.dueDate == null
                                            ? ""
                                            : "${controller.dueDate!.day}-${controller.dueDate!.month}-${controller.dueDate!.year}",
                                      ),
                                      readOnly: true,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Priority
                          SizedBox(
                            height: 60,
                            child: DropdownButtonFormField2<String>(
                              isExpanded: true,
                              value: controller.priority,
                              decoration: InputDecoration(
                                labelText: "Priority",
                                errorText: controller.priorityError,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              items:
                              ['High', 'Medium', 'Low'].map((e) {
                                return DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(e),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  controller.priority = val!;
                                });
                              },
                              validator:
                                  (val) =>
                              val == null || val.isEmpty
                                  ? 'Please select priority'
                                  : null,
                            ),
                          ),

                          /* DropdownButtonFormField(
                            value: controller.priority,
                            decoration: InputDecoration(
                              labelText: "Priority",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items:
                                ['High', 'Medium', 'Low'].map((e) {
                                  return DropdownMenuItem(value: e, child: Text(e));
                                }).toList(),
                            onChanged: (val) {
                              setState(() {
                                controller.priority = val!;
                              });
                            },
                          ),*/
                          const SizedBox(height: 20),
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
                          const SizedBox(height: 20),
                          // Task Description
                          TextFormField(
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: "Task Description",
                              hintText: "Explain task details here",
                              errorText: controller.taskDescriptionError,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignLabelWithHint: true,
                            ),
                            onChanged: (val) => controller.taskDescription = val,
                          ),
                          const SizedBox(height: 20),

                          // Submit Button
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                if (controller.validateTaskForm()) {
                                  controller.addTask(
                                    context,
                                    controller.selectedProjectId,
                                  );
                                }
                              },
                              child: Text("Submit"),
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
                            ),
                          ),
                        ],
                      );
                    },
                  ),
              ),
            )
        ),
      ),
    );
  }
}

