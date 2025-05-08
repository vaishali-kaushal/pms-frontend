import 'package:performance_management_system/pms.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    final rawValue = PrefService.getString(PrefKeys.department);
    String departmentText = '';

    if (rawValue.isNotEmpty) {
      if (rawValue.startsWith('[') && rawValue.endsWith(']')) {
        // Looks like a list — strip brackets and spaces
        departmentText = rawValue
            .substring(1, rawValue.length - 1) // remove [ and ]
            .split(',')
            .map((e) => e.trim()) // clean up whitespace
            .where((e) => e.isNotEmpty) // ignore empty strings
            .join(', ');
      } else {
        // It's just a plain string
        departmentText = rawValue;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.8),
      body: GetBuilder<DashboardController>(
        id: 'home',
        builder: (controller) {
          return Row(
            children: [
              // Sidebar
              NavigationMenu(
                selectedIndex: controller.selectedIndex,
                onItemSelected: (index) {
                  setState(() {
                    // controller.selectedIndex = index;
                    controller.changeTab(index);
                  });
                },
              ),
              // Main Content
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderSection(
                      title: controller.menuTitles[controller.selectedIndex],
                    ),
                    //Dashboard Part
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (controller.selectedIndex == 0) ...[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Department",
                                    style: styleW500S14.copyWith(
                                      color: ColorRes.greyColor,
                                    ),
                                  ),
                                  appSizedBox(height: 1.h),
                                  Text(
                                    departmentText,
                                    style: styleW500S20,
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              TaskStats(),
                              if (PrefService.getString(PrefKeys.role).toLowerCase() != "admin")
                                SizedBox(height: 20),
                              if (PrefService.getString(
                                    PrefKeys.role,
                                  ).toLowerCase() !=
                                  "admin")
                                TaskList(),
                            ] else if (controller.selectedIndex == 1) ...[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Users", style: styleW600S20),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          showRightSlideDialog(
                                            context: context,
                                            child: AddRolesDialog(),
                                            widthFactor: 0.4,
                                            barrierLabel: "Add New User",
                                          );
                                        },
                                        icon: Icon(Icons.add),
                                        label: Text("Add User"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorRes.appBlueColor,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              appSizedBox(height: 1.5.h),
                              RolesTable(),
                            ]
                            else if (controller.selectedIndex == 2) ...[
                              if (!controller.showTaskList) ...[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("All Projects", style: styleW600S20),
                                    if (PrefService.getString(
                                          PrefKeys.role,
                                        ).toLowerCase() ==
                                        "project manager")
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          showRightSlideDialog(
                                            context: context,
                                            child: AddProjectDialog(),
                                            widthFactor: 0.4,
                                            barrierLabel: "Add Project",
                                          );
                                        },
                                        icon: Icon(Icons.add),
                                        label: Text("Add Project"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              ColorRes.appBlueColor,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                ProjectTable(
                                  onViewTasksPressed: (data) {
                                    setState(() {
                                      controller.showTaskList = true;
                                      controller.selectedProjectId =
                                          data.id.toString();
                                      controller.projectDetails = data;
                                      print("Project  selected: $data");
                                    });
                                  },
                                ),
                              ] else ...[
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.arrow_back),
                                      onPressed: () {
                                        setState(() {
                                          controller.showTaskList = false;
                                        });
                                      },
                                    ),
                                    Text(
                                      "Project Details",
                                      style: styleW600S20,
                                    ),
                                    /*Spacer(),
                                    if (PrefService.getString(
                                              PrefKeys.role,
                                            ).toLowerCase() != "admin" &&
                                        PrefService.getString(PrefKeys.role,).toLowerCase() != "team member")
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          showRightSlideDialog(
                                            context: context,
                                            child: AddTaskDialog(),
                                            widthFactor: 0.4,
                                            barrierLabel: "Add Task",
                                          );
                                        },
                                        icon: Icon(Icons.add),
                                        label: Text("Add New Task"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              ColorRes.appBlueColor,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                      ),*/
                                  ],
                                ),
                                SizedBox(height: 20),

                                ProjectDetailsCard(
                                  projectId: controller.selectedProjectId,
                                ),
                              ],
                            ]
                              else if (controller.selectedIndex == 3) ...[
                              if (!controller.showTaskList) ...[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Milestones", style: styleW600S20),
                                    if (PrefService.getString(
                                              PrefKeys.role,
                                            ).toLowerCase() !=
                                            "admin" &&
                                        PrefService.getString(
                                              PrefKeys.role,
                                            ).toLowerCase() !=
                                            "team member")
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          showAddMilestoneModal(context);
                                        },
                                        icon: Icon(Icons.add),
                                        label: Text("Add Milestone"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              ColorRes.appBlueColor,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 30),
                                MilestoneListTable(
                                  onViewMilestonePressed: (data) {
                                    setState(() {
                                      controller.showTaskList = true;
                                      controller.selectedProjectId =
                                          data!.id.toString();
                                      controller.projectDetails = data;
                                      print(
                                        "Project  selected: ${data.id.toString()}",
                                      );
                                    });
                                  },
                                ),
                              ] else ...[
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.arrow_back),
                                      onPressed: () {
                                        setState(() {
                                          controller.showTaskList = false;
                                        });
                                      },
                                    ),
                                    Text(
                                      "Project Details",
                                      style: styleW600S20,
                                    ),
                                    /*Spacer(),
                                    if (PrefService.getString(PrefKeys.role).toLowerCase() != "admin" &&
                                        PrefService.getString(PrefKeys.role).toLowerCase() != "team member")
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          showRightSlideDialog(
                                            context: context,
                                            child: AddTaskDialog(),
                                            widthFactor: 0.4,
                                            barrierLabel: "Add Task",
                                          );
                                        },
                                        icon: Icon(Icons.add),
                                        label: Text("Add New Task"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              ColorRes.appBlueColor,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                      ),*/
                                  ],
                                ),

                                SizedBox(height: 20),

                                ProjectDetailsCard(
                                  projectId: controller.selectedProjectId,
                                ),
                              ],
                            ]
                                else if (controller.selectedIndex == 4) ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("All Tasks", style: styleW600S20),
                                  if (PrefService.getString(
                                            PrefKeys.role,
                                          ).toLowerCase() !=
                                          "admin" &&
                                      PrefService.getString(
                                            PrefKeys.role,
                                          ).toLowerCase() !=
                                          "team member")
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        showRightSlideDialog(
                                          context: context,
                                          child: AddTaskDialog(),
                                          widthFactor: 0.4,
                                          barrierLabel: "Add Task",
                                        );
                                      },
                                      icon: Icon(Icons.add),
                                      label: Text("Add New Task"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ColorRes.appBlueColor,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              TaskListTable(projectId: ""),
                            ]
                                  else if (controller.selectedIndex == 5) ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Project Overview",
                                    style: styleW600S20,
                                  ),
                                  // You can optionally add filter, export, etc.
                                ],
                              ),
                              SizedBox(height: 20),
                              PerformanceTable(projectId: ''),
                            ]
                                    else if (controller.selectedIndex == 6) ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Self Appraisal", style: styleW600S20),
                                  Spacer(),
                                  Text("01 Apr 2024 - 31 Mar 2025", style: styleW500S14),
                                  /*if (PrefService.getString(PrefKeys.role).toLowerCase() != "admin")
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        AppraisalFormScreen(initialStep: 1);
                                      },
                                      icon: Icon(Icons.add),
                                      label: Text("Add Self Appraisal"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ColorRes.appBlueColor,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    ),*/
                                ],
                              ),
                              SizedBox(height: 1.h),
                              AppraisalFormScreen(initialStep: 0),
                            ]
                                      else if (controller.selectedIndex == 7) ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Review Appraisal", style: styleW600S20),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              SelfAppraisalTable(),
                            ]
                          else if (controller.selectedIndex == 8) ...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("My Profile", style: styleW600S20),
                                  ],
                                ),
                                SizedBox(height: 1.h), ProfileScreen(secureId: '')
                              ]

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Header Section
class HeaderSection extends StatelessWidget {
  final String title;

  HeaderSection({required this.title});

  @override
  Widget build(BuildContext context) {
    final role = PrefService.getString(PrefKeys.role);
    final name = PrefService.getString(PrefKeys.userName);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: styleW500S14.copyWith(color: ColorRes.greyColor),
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  popupMenuTheme: PopupMenuThemeData(
                    color: Colors.white, // or your desired menu background
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: styleW500S13, // Optional: apply your own style
                  ),
                ),
                child: PopupMenuButton<String>(
                  offset: Offset(0, 40),
                  onSelected: (value) {
                    if (value == 'logout') {
                      PrefService.clear();
                      Get.offAll(() => LoginScreen());
                    }
                  },
                  itemBuilder:
                      (context) => [
                        PopupMenuItem(
                          enabled: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name, style: styleW500S13),
                              SizedBox(height: 2),
                              Text(
                                role,
                                style: styleW400S12.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              appSizedBox(height: 1.h),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'logout',
                          padding: EdgeInsets.zero,
                          child: Container(
                            color: Colors.red.withOpacity(0.1),
                            // Light red background
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    LucideIcons.logOut,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Logout",
                                  style: styleW500S13.copyWith(
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.orange.shade100,
                        child: Icon(
                          Icons.person,
                          size: 18,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(name, style: styleW400S13),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: Colors.blueGrey,
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
        Container(
          height: 1,
          width: double.infinity,
          color: Colors.grey.shade300,
        ),
      ],
    );
  }
}

// Task Statistics Section
class TaskStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TaskStatCard(
              title: "Total Projects",
              value: "05",
              color: Colors.purple,
              icon: Icons.folder,
            ),
            TaskStatCard(
              title: "Ongoing Projects",
              value: "02",
              color: Colors.orange,
              icon: LucideIcons.hammer,
            ),
            TaskStatCard(
              title: "Completed Projects",
              value: "01",
              color: Colors.green,
              icon: Icons.check_circle,
            ),
            TaskStatCard(
              title: "Project Milestones",
              value: "07",
              color: Colors.blueGrey,
              icon: LucideIcons.milestone,
            ),
          ],
        ),
        appSizedBox(height: 3.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TaskStatCard(
              title: "Total Tasks",
              value: "10",
              color: Colors.blue,
              icon: Icons.list_alt,
            ),
            TaskStatCard(
              title: "Completed Tasks",
              value: "04",
              color: Colors.green,
              icon: Icons.task_alt,
            ),
            TaskStatCard(
              title: "Pending Tasks",
              value: "03",
              color: Colors.red,
              icon: Icons.pending_actions,
            ),
            TaskStatCard(
              title: "Under Review Tasks",
              value: "03",
              color: Colors.amber,
              icon: LucideIcons.fileSearch,
            ),
          ],
        ),
      ],
    );
  }
}

// Single Task Stat Card
class TaskStatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  TaskStatCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: styleW400S12.copyWith(color: ColorRes.greyColor),
                  ),
                  SizedBox(height: 5),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
            Icon(icon, size: 32, color: color),
          ],
        ),
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  final List<Map<String, String>> tasks = List.generate(
    10,
    (index) => {
      "name": "Haryana Drug Abuse Portal",
      "members": "Integrate api",
      "startDate": "04/04/2025",
    },
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: TaskCard(title: "My Tasks", tasks: tasks)),
        SizedBox(width: 20),
        Expanded(child: TaskCard(title: "Overdue Tasks", tasks: tasks)),
      ],
    );
  }
}

class TaskCard extends StatelessWidget {
  final String title;
  final List<Map<String, String>> tasks;

  TaskCard({required this.title, required this.tasks});

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final bool isOverdue = title == "Overdue Tasks";

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 270,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  // Header
                  appSizedBox(height: 1.h),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            isOverdue ? "Pending Actions" : "Project",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            isOverdue ? "Urgent Tasks" : "Task",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            isOverdue ? "Late Date" : "Date",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(thickness: 2.5, color: Colors.grey.shade600),

                  // Scrollable List
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      child: Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        thickness: 6,
                        radius: Radius.circular(10),
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      isOverdue
                                          ? "Important"
                                          : task["name"] ?? "",
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      isOverdue
                                          ? "Immediate"
                                          : task["members"] ?? "",
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      isOverdue
                                          ? "Late by 28 days"
                                          : task["startDate"] ?? "",
                                      style: TextStyle(color: Colors.grey[700]),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Task Item
class TaskItem extends StatelessWidget {
  final Map<String, String> task;
  final bool isOverdue;

  TaskItem({required this.task, required this.isOverdue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              isOverdue ? task["pendingActions"]! : task["name"]!,
              style: styleW400S14,
            ),
          ),
          Expanded(
            child: Text(
              isOverdue ? task["urgentTasks"]! : task["members"]!,
              style: styleW400S14,
            ),
          ),
          Expanded(
            child: Text(
              isOverdue ? task["lateDate"]! : task["startDate"]!,
              style: styleW400S14,
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectDetailsCard extends StatefulWidget {
  final String projectId;

  const ProjectDetailsCard({super.key, required this.projectId});

  @override
  State<ProjectDetailsCard> createState() => _ProjectDetailsCardState();
}

class _ProjectDetailsCardState extends State<ProjectDetailsCard> {
  final DashboardController controller = Get.find<DashboardController>();

  @override
  void initState() {
    super.initState();
    controller.loadProjectDetails(widget.projectId);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      id: 'home',
      builder: (controller) {
        if (controller.isProjectLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.projectDetails == null) {
          return const Center(child: Text("No project data found."));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              // Project Info Cards
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left Card
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(16),
                        decoration: _boxDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow(
                              "Project",
                              controller.model!.projectName.toString(),
                            ),
                            _buildInfoRow(
                              "Team Lead",
                              controller.model!.teamLeadName.toString(),
                            ),
                            _buildInfoRow(
                              "Start Date",
                              formatDateString(
                                controller.model!.startDate.toString(),
                              ),
                            ),
                            _buildInfoRow(
                              "Department",
                              controller.model!.departmentName.toString(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Right Card
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(16),
                        decoration: _boxDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Team Members", style: styleW500S13),
                            appSizedBox(height: 1.h),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children:
                                  controller.model?.projectMembers
                                      ?.map(
                                        (member) => _memberChip(
                                          member.memberName ?? '',
                                        ),
                                      )
                                      .toList() ??
                                  [],
                            ),
                            appSizedBox(height: 1.h),
                            _buildInfoRow(
                              "End Date",
                              formatDateString(
                                controller.model!.dateCompletion.toString(),
                              ),
                            ),
                            _buildInfoRow(
                              "Description",
                              controller.model!.description.toString(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Milestones List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.model.projectMilestones?.length,
                itemBuilder: (context, index) {
                  final milestone = controller.model.projectMilestones![index];
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    padding: const EdgeInsets.all(16),
                    decoration: _boxDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top Row: Number, Title, Status
                            Row(
                              children: [
                                // Milestone number box
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade700,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${index + 1}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),

                                // Milestone Title
                                Expanded(
                                  child: Text(
                                    "Milestone ${index + 1}: ${milestone.name.toString()}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),

                                /* // Status Badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade600,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'Status',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),*/
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Date Range
                            Text(
                              "${formatDateString(milestone.startDate)} - ${formatDateString(milestone.endDate)}",
                              style: const TextStyle(color: Colors.black54),
                            ),
                            const SizedBox(height: 6),

                            // Description
                            Text(
                              milestone.description.toString(),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),

                        appSizedBox(height: 2.h),

                        Table(
                          border: TableBorder.all(color: Colors.grey),
                          columnWidths: const {
                            0: FixedColumnWidth(60),
                            8: FixedColumnWidth(120),
                          },
                          children: [
                            _buildHeaderRow(),
                            // Generate a row for each task in the milestone
                            ...List.generate(milestone.tasks?.length ?? 0, (
                              taskIndex,
                            ) {
                              final task = milestone.tasks![taskIndex];
                              return _buildDataRow(
                                task,
                                controller,
                                context,
                                taskIndex,
                              );
                            }),
                          ],
                        ),

                        /*DataTable(
                          headingRowColor: MaterialStateProperty.all(Colors.blue.shade50),
                          columns: const [
                            DataColumn(label: Text("#")),
                            DataColumn(label: Text("Task")),
                            DataColumn(label: Text("Assigned To")),
                            DataColumn(label: Text("Priority")),
                            DataColumn(label: Text("Status")),
                          ],
                          rows: List.generate(milestone.tasks.length, (taskIndex) {
                            final task = milestone.tasks[taskIndex];
                            return DataRow(cells: [
                              DataCell(Text('${taskIndex + 1}')),
                              DataCell(Text(task.title)),
                              DataCell(Text(task.assignedTo)),
                              DataCell(_priorityBadge(task.priority)),
                              DataCell(_statusBadge(task.status)),
                            ]);
                          }),
                        ),*/
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget _memberChip(String name) {
  return Chip(
    label: Text(name),
    backgroundColor: Colors.white,
    shape: StadiumBorder(side: BorderSide(color: Colors.blueGrey.shade200)),
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
              ),
            )
            : Text(text, style: style, textAlign: TextAlign.center),
  );
}

TableRow _buildHeaderRow() {
  var style = styleW600S14;
  return TableRow(
    decoration: const BoxDecoration(color: Color(0xFFF0F0F0)),
    children: [
      _cell('#', style),
      _cell('Task', style),
      //_cell('Project', style),
      if (PrefService.getString(PrefKeys.role).toLowerCase() != "team member")
        _cell('Assigned To', style),
      _cell('Designation', style),
      _cell('Priority', style),
      _cell('Timelines', style),
      _cell('Status', style),
      _cell('Action', style),
    ],
  );
}

TableRow _buildDataRow(
  DetailTasks task,
  DashboardController controller,
  BuildContext context,
  int index,
) {
  var style = styleW400S13;
  final srNo = index + 1;

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
      // _cell(task.projectName ?? '', style),
      if (PrefService.getString(PrefKeys.role).toLowerCase() != "team member")
        _cell("${task.assignedTo}" ?? '', style),
      _cell(task.designation ?? '', style),
      _cell(task.priority ?? '', style, priorityColor), // priority bg

      _cell(
        "${formatDateString(task.startDate)} - ${formatDateString(task.endDate)}",
        style?.copyWith(fontSize: 12),
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
                    () => {
                      showDashboardRightSideVerifyDialog(
                        context,
                        task,
                        controller,
                        status: 'Initiate',
                        role: role,
                      ),

                    },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text(
                  "Initiate Task",
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else if (role == "team member" && status == "In Progress") {
              return ElevatedButton(
                onPressed:
                    () => {
                      showDashboardRightSideVerifyDialog(
                        context,
                        task,
                        controller,
                        status: 'Under Review',
                        role: role,
                      ),
                    },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text(
                  "Submit Task",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              );
            } else if (role == "project manager" && status == "Completed") {
              return ElevatedButton(
                onPressed:
                    () => {
                      showDashboardRightSideVerifyDialog(
                        context,
                        task,
                        controller,
                        status: 'Verify',
                        role: role,
                      ),
                    },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                child: const Text(
                  "Verify Task",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return ElevatedButton(
              onPressed:
                  () => {
                    showDashboardRightSideVerifyDialog(
                      context,
                      task,
                      controller,
                      status: 'View',
                      role: role,
                    ),
                  },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorRes.appBlueColor,
              ),
              child: const Text("View", style: TextStyle(color: Colors.white)),
            );
          }(),
        ),
      ),
    ],
  );
}

void showDashboardRightSideVerifyDialog(
  BuildContext context,
  DetailTasks task,
  DashboardController controller, {
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
                                constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight,
                                ),
                                child: IntrinsicHeight(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Left Column
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _infoRow(
                                                  "Project",
                                                  controller.model.projectName
                                                      .toString(),
                                                ),
                                                _infoRow(
                                                  "Task",
                                                  task.name.toString(),
                                                ),
                                                _infoRow(
                                                  "Milestone",
                                                  task.milestone ?? '',
                                                ),
                                                _infoRow(
                                                  "Priority",
                                                  task.priority.toString(),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 20),

                                          // Right Column
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _infoRow(
                                                  "Assigned To",
                                                  "${task.assignedTo} ( ${task.designation})",
                                                ),
                                                _infoRow(
                                                  "Start Date",
                                                  formatDateString(
                                                    task.startDate,
                                                  ),
                                                ),
                                                _infoRow(
                                                  "Target Date",
                                                  formatDateString(
                                                    task.endDate,
                                                  ),
                                                ),
                                                _infoRow(
                                                  "Status",
                                                  task.status.toString(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      if (task.statusLogs != null && task.statusLogs!.isNotEmpty)
                                        StatusTimeline<DetailStatusLogs>(
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
            style:
                title == "Status"
                    ? styleW400S14.copyWith(color: getStatusColor(value))
                    : styleW400S14,
          ),
        ],
      ),
    ),
  );
}

BoxDecoration _boxDecoration() => BoxDecoration(
  color: Colors.grey.shade100,
  borderRadius: BorderRadius.circular(12),
  boxShadow: const [
    BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 2),
  ],
);

Widget _buildInfoRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            value,
            style: const TextStyle(color: Colors.black87, fontSize: 14),
            softWrap: true,
            textAlign: TextAlign.left,
          ),
        ),
      ],
    ),
  );
}

