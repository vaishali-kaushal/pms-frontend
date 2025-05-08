import 'package:performance_management_system/pms.dart';

class PerformanceTable extends StatelessWidget {
  final String projectId;
  final TaskController controller = Get.put(TaskController());

  PerformanceTable({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(
      id: 'home',
      initState: (_) {
        controller.fetchTasks(projectId);
        controller.fetchMembers('');
        controller.fetchProjects();
        if (projectId.trim().isNotEmpty) {
          controller.selectedProjectId = projectId;
        }
        controller.selectedFilterType = 'Monthly'; // default
        controller.setFilterDateRange(DateTime.now());
      },
      builder: (_) {
        if (controller.loader) {
          return SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Center(child: CircularProgressIndicator())
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
                    ...paginatedTasks.map((task) => _buildDataRow(task, controller, context)).toList(),
                  ],
                ),
                if(paginatedTasks.isEmpty)
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: NoDataWidget(
                        title: "No Task Available!",
                        subtitle: "Tasks will appear here once added",
                        icon: Icons.task_alt_outlined,
                      )),
                if(paginatedTasks.isNotEmpty)
                  const SizedBox(height: 10),
                if(paginatedTasks.isNotEmpty)
                  _buildPaginationControls(controller),
              ],
            ),
          );
        }
      },
    );
  }

  TableRow _buildHeaderRow() {
    var style = styleW600S14;
    return TableRow(
      decoration: const BoxDecoration(color: Color(0xFFF0F0F0)),
      children: [
        _cell('#', style),
        _cell('Project', style),
        _cell('Milestone', style),
        _cell('Task', style),
        if (PrefService.getString(PrefKeys.role).toLowerCase() != "team member")
          _cell('Assigned To', style),
        _cell('Priority', style),
        _cell('Start Date', style),
        _cell('Target Date', style),
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
        _cell(task.projectName ?? '', style),
        _cell(task.milestoneName ?? '', style),
        _cell(task.name ?? '', style),
        if (PrefService.getString(PrefKeys.role).toLowerCase() != "team member")
          _cell("${task.assignedTo}( ${task.designation})" ?? '', style),//( ${task.designation})
        _cell(task.priority ?? '', style, priorityColor), // priority bg
        _cell("${formatDateString(task.startDate)}", style),
        _cell("${formatDateString(task.endDate)}", style),
        _cell(task.status ?? '', styleW500S13, statusBgColor), // status bg
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: () {
              final role = PrefService.getString(PrefKeys.role).toLowerCase();
              return ElevatedButton(
                onPressed:
                    () => showRightSideVerifyDialogg(
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

  Widget _assignedUserFilter(TaskController controller) {
    return SizedBox(
      width: 200,
      child: DropdownButtonFormField<String>(
        value: controller.selectedUser,
        decoration: InputDecoration(
          labelText: "Assigned User",
          labelStyle: styleW500S13,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          isDense: true,
        ),
        style: styleW400S13,
        dropdownColor: Colors.white,
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down, color: Colors.grey, size: 20),
        iconEnabledColor: Colors.grey,
        items: controller.teamMemberList.map((user) {
          return DropdownMenuItem<String>(
            value: user.name,
            child: Text(
              user.name.toString(),
              style: styleW400S13,
            ),
          );
        }).toList(),
        onChanged: (val) {
          controller.selectedUser = val!;
          controller.update(['home']);
        },
      ),
    );
  }

  Widget _projectFilter(TaskController controller) {
    return SizedBox(
      width: 200,
      child: DropdownButtonFormField<String>(
        value: controller.selectedProjectName,
        decoration: InputDecoration(
          labelText: "Project",
          labelStyle: styleW500S13,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          isDense: true,
        ),
        style: styleW400S13,
        dropdownColor: Colors.white,
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down, color: Colors.grey, size: 20),
        iconEnabledColor: Colors.grey,
        items: controller.projectsList.map((proj) {
          return DropdownMenuItem<String>(
            value: proj.name,
            child: Text(
              proj.name.toString(),
              style: styleW400S13,
            ),
          );
        }).toList(),
        onChanged: (val) {
          controller.selectedProjectName = val!;
          controller.update(['home']);
        },
      ),
    );
  }

  Widget _yearFilter(TaskController controller) {
    return SizedBox(
      width: 120,
      child: DropdownButtonFormField<String>(
        value: controller.selectedYear,
        decoration: InputDecoration(
          labelText: 'Year',
          labelStyle: styleW500S13,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          isDense: true,
        ),
        style: styleW400S13,
        dropdownColor: Colors.white,
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down, color: Colors.grey, size: 20),
        iconEnabledColor: Colors.grey,
        items: controller.availableYears.map((year) {
          return DropdownMenuItem(value: year, child: Text(year, style: styleW400S13));
        }).toList(),
        onChanged: (val) => controller.setYearFilter(val),
      ),
    );
  }

  Widget _monthFilter(TaskController controller, String label) {
    final String? selectedValue =
    label == "From Month" ? controller.selectedFromMonth : controller.selectedToMonth;

    return SizedBox(
      width: 140,
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: styleW500S13,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          isDense: true,
        ),
        style: styleW400S13,
        dropdownColor: Colors.white,
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down, color: Colors.grey, size: 20),
        iconEnabledColor: Colors.grey,
        items: controller.months.map((month) {
          return DropdownMenuItem(value: month, child: Text(month, style: styleW400S13));
        }).toList(),
        onChanged: (val) {
          if (label == "From Month") {
            controller.setFromMonthFilter(val);
          } else {
            controller.setToMonthFilter(val);
          }
        },
      ),
    );
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

  static Widget _cell(String text, [TextStyle? style, Color? backgroundColor]) {
    return Container(
      constraints: const BoxConstraints(minHeight: 60),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      child: backgroundColor != null
          ? Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          text,
          style: style?.copyWith(color: Colors.white) ?? const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
          softWrap: true,
          overflow: TextOverflow.visible,
          maxLines: null,
        ),
      )
          : Text(
        text,
        style: style,
        textAlign: TextAlign.center,
        softWrap: true,
        overflow: TextOverflow.visible,
        maxLines: null,
      ),
    );
  }

  Widget _rowsPerPageDropdown(TaskController controller, BuildContext context) {
    return Theme(
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
            value: controller.rowsPerPage,
            isDense: true,
            onChanged: (value) {
              if (value != null) {
                controller.changeRowsPerPage(value);
              }
            },
            items: controller.rowsPerPageOptions.map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTopControls(TaskController controller, BuildContext context) {
    final userRole = PrefService.getString(PrefKeys.role).toLowerCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // const Icon(Icons.filter_alt_sharp, color: Colors.grey, size: 20),
            // const SizedBox(width: 6),
            Text('Filter', style: styleW500S15),
          ],
        ),
        appSizedBox(height: 1.h),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            if (userRole == "project manager" || userRole == "admin") ...[
              _assignedUserFilter(controller), // 👤 User
              _projectFilter(controller),      // 📁 Project
            ],
            _yearFilter(controller),           // 📅 Year
            _monthFilter(controller, "From Month"), // ⬅️ From Month
            _monthFilter(controller, "To Month"), // ➡️ To Month
            appSizedBox(width: 1.w),
            AppButton(
                buttonName: 'Apply',
                onButtonTap: controller.applyFilters,
                buttonHeight: 30,
                buttonWidth: 80,
                fontSize: 13),
            AppButton(
                buttonName: 'Clear',
                onButtonTap: controller.resetFilters,
                buttonHeight: 30,
                buttonWidth: 80,
                backgroundColor: ColorRes.appRedColor,
                fontSize: 13),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Text('Show'),
            const SizedBox(width: 8),
            _rowsPerPageDropdown(controller, context),
            const SizedBox(width: 8),
            const Text('entries'),
            const Spacer(),
            SizedBox(
              width: 250,
              child: TextField(
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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
          ],
        ),
      ],
    );
  }

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


void showRightSideVerifyDialogg(
  BuildContext context,
  TaskData task,
  TaskController controller, {
  required String status, // "View" or "Verify"
  required String role,
}) {
  controller.remarks = null;
  controller.nextDueDate = null;

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
              padding: const EdgeInsets.all(20),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Fixed header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Task Details", style: styleW600S18),
                          IconButton(
                            icon: const Icon(Icons.close),
                            hoverColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Scrollable content
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return SingleChildScrollView(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                                child: IntrinsicHeight(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Left Column
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

                                          // Right Column
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                _infoRow("Assigned To", "${task.assignedTo}( ${task.designation})"),
                                                _infoRow("Start Date", formatDateString(task.startDate)),
                                                _infoRow("Target Date", formatDateString(task.endDate)),
                                                _infoRow("Status", task.status.toString()),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

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

                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              )
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
class CalendarDateRangePicker extends StatefulWidget {
  final DateTimeRange initialDateRange;
  final void Function(DateTimeRange) onChanged;

  const CalendarDateRangePicker({
    Key? key,
    required this.initialDateRange,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CalendarDateRangePicker> createState() =>
      _CalendarDateRangePickerState();
}

class _CalendarDateRangePickerState extends State<CalendarDateRangePicker> {
  DateTime? _start;
  DateTime? _end;

  @override
  void initState() {
    super.initState();
    _start = widget.initialDateRange.start;
    _end = widget.initialDateRange.end;
  }

  void _onSelectDate(DateTime date) {
    setState(() {
      if (_start == null || (_start != null && _end != null)) {
        _start = date;
        _end = null;
      } else {
        if (date.isBefore(_start!)) {
          _end = _start;
          _start = date;
        } else {
          _end = date;
        }

        if (_start != null && _end != null) {
          widget.onChanged(DateTimeRange(start: _start!, end: _end!));
        }
      }
    });
  }

  bool _isSelected(DateTime day) {
    if (_start != null && _end != null) {
      return !day.isBefore(_start!) && !day.isAfter(_end!);
    } else if (_start != null) {
      return day == _start;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return CalendarDatePicker(
      initialDate: _start ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      onDateChanged: _onSelectDate,
    );
  }
}
