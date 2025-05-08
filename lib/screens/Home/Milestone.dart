import 'package:performance_management_system/pms.dart';

class MilestoneListTable extends StatelessWidget {
  final MilestoneController controller = Get.put(MilestoneController());

  final Function(ProjectsData? project) onViewMilestonePressed;

  MilestoneListTable({Key? key, required this.onViewMilestonePressed}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MilestoneController>(
      id: 'home',
      initState: (_) {
        controller.fetchProjects(null);
        controller.fetchMilestones("");
      },
      builder: (_) {
        if (controller.loader) {
          return  SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: const Center(child: CircularProgressIndicator())
          );
        } else {
          final paginatedTasks = controller.paginatedMilestones;

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
                        .map((data) => _buildDataRow(data, controller, context))
                        .toList(),
                  ],
                ),
                if(paginatedTasks.isEmpty)
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: NoDataWidget(
                        title: "No Milestone Available!",
                        subtitle: "Milestones will appear here once added",
                        icon: Icons.task_alt_outlined,
                      )
                  ),
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

  Widget _buildTopControls(MilestoneController controller, BuildContext context) {
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
        _cell('Milestone', style),
        _cell('Project', style),
        _cell('Start Date', style),
        _cell('Target Date', style),
        _cell('Status', style),
        _cell('Action', style),
      ],
    );
  }

  TableRow _buildDataRow(
      MilestoneData data,
      MilestoneController controller,
      BuildContext context,
      ) {
    var style = styleW400S13;
    final index = controller.paginatedMilestones.indexOf(data) + 1;
    final srNo = controller.currentPage * controller.rowsPerPage + index;

    // Status background color
    Color? statusBgColor;
    switch (data.status?.toLowerCase()) {
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
        _cell(data.name ?? '', style),
        _cell(data.projectName ?? '', style),
        _cell("${formatDateString(data.startDate)}", style),
        _cell("${formatDateString(data.endDate)}", style),
        _cell(data.status ?? 'New', styleW500S13, statusBgColor),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: () {
              final role = PrefService.getString(PrefKeys.role).toLowerCase();

              return ElevatedButton(
                onPressed:
                    () async {
                      await controller.fetchProjects(data.projectId); // Waits for completion
                      onViewMilestonePressed(controller.projectsData); // Runs only after fetch completes
                    },
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

  Widget _buildPaginationControls(MilestoneController controller) {
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

  Widget _cell(String text, [TextStyle? style, Color? backgroundColor]) {
    return Container(
      height: 60,
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
      ),
    );
  }

}

class AddMilestoneDialog extends StatefulWidget {
  @override
  _AddMilestoneDialogState createState() => _AddMilestoneDialogState();
}

class _AddMilestoneDialogState extends State<AddMilestoneDialog> {
  final MilestoneController controller = Get.find<MilestoneController>();

  @override
  void initState() {
    super.initState();
    controller.resetMilestoneForm(); // renamed from resetTaskForm
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: SizedBox(
        width: isWeb ? 800 : double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: GetBuilder<MilestoneController>(
              id: 'add_dialog',
              builder: (_) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Add Milestone",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Milestone Title
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Milestone",
                        errorText: controller.milestoneTitleError,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onChanged: (val) => controller.milestoneTitle = val,
                    ),
                    const SizedBox(height: 20),

                    // Project Dropdown
                    DropdownButtonFormField<String>(
                      value: controller.selectedProjectId.isEmpty ? null : controller.selectedProjectId,
                      decoration: InputDecoration(
                        labelText: "Select Project",
                        errorText: controller.selectedProjectError,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      items: controller.fetchedProjects.map((project) {
                        return DropdownMenuItem<String>(
                          value: project['id'].toString(),
                          child: Text(project['name']),
                        );
                      }).toList(),
                      onChanged: (val) {
                        controller.selectedProjectId = val!;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Start & Due Date
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
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  suffixIcon: Icon(Icons.calendar_today),
                                ),
                                controller: TextEditingController(
                                  text: controller.startDate == null
                                      ? ""
                                      : "${controller.startDate!.day}-${controller.startDate!.month}-${controller.startDate!.year}",
                                ),
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
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  suffixIcon: Icon(Icons.calendar_today),
                                ),
                                controller: TextEditingController(
                                  text: controller.dueDate == null
                                      ? ""
                                      : "${controller.dueDate!.day}-${controller.dueDate!.month}-${controller.dueDate!.year}",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Description
                    TextFormField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: "Milestone Description",
                        hintText: "Enter description",
                        errorText: controller.milestoneDescriptionError,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        alignLabelWithHint: true,
                      ),
                      onChanged: (val) => controller.milestoneDescription = val,
                    ),
                    const SizedBox(height: 20),

                    // Submit Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (controller.validateMilestoneForm()) {
                            controller.addMilestone(
                              context,
                              controller.selectedProjectId,
                            ).then((_) => Navigator.pop(context));
                          }
                        },
                        child: Text("Submit"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorRes.appBlueColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

void showAddMilestoneModal(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Add Task",
    barrierColor: Colors.black.withOpacity(0.2),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Align(
        alignment: Alignment.centerRight,
        child: Material(
          color: Colors.white,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height,
            child: AddMilestoneDialog(),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  );
}
