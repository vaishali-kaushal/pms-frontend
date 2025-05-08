import 'package:performance_management_system/pms.dart';

class NavigationMenu extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const NavigationMenu({
    required this.selectedIndex,
    required this.onItemSelected,
    super.key,
  });

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  bool isCollapsed = false;
  bool isPerformanceExpanded = false;

  @override
  Widget build(BuildContext context) {
    final String userRole = PrefService.getString(PrefKeys.role);

    return Container(
      width: isCollapsed ? 80 : 280,
      color: ColorRes.lightBlueColor,
      child: Column(
        children: [
          // Logo & Collapse Button
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment:
              isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                if (!isCollapsed) const SizedBox(width: 10),
                if (!isCollapsed) Image.asset(AssetRes.dashboardLogo, height: 30),
                if (!isCollapsed) const SizedBox(width: 6),
                if (!isCollapsed)
                  Text("Performance Monitoring System", style: styleW500S13),
                if (!isCollapsed) Spacer(),
                IconButton(
                  icon: Image.asset(
                    AssetRes.expand, // Use same asset or separate icons if needed
                    width: 20,
                    height: 20,
                    color: ColorRes.greyColor,
                  ),
                  onPressed: () {
                    setState(() {
                      isCollapsed = !isCollapsed;
                    });
                  },
                ),
              ],
            ),
          ),

          Divider(color: Colors.grey.shade300),
          const SizedBox(height: 12),

          // Menu Items
          MenuItem(
            icon: Icons.dashboard,
            title: "Dashboard",
            isSelected: widget.selectedIndex == 0,
            onTap: () => widget.onItemSelected(0),
            isCollapsed: isCollapsed,
          ),
          if (userRole.toLowerCase() == "admin")
            MenuItem(
              icon: Icons.people,
              title: "Users",
              isSelected: widget.selectedIndex == 1,
              onTap: () => widget.onItemSelected(1),
              isCollapsed: isCollapsed,
            ),
          MenuItem(
            icon: Icons.folder_open,
            title: "Projects",
            isSelected: widget.selectedIndex == 2,
            onTap: () => widget.onItemSelected(2),
            isCollapsed: isCollapsed,
          ),
          if (userRole.toLowerCase() != "team member")
            MenuItem(
              icon: Icons.flag,
              title: "Milestones",
              isSelected: widget.selectedIndex == 3,
              onTap: () => widget.onItemSelected(3),
              isCollapsed: isCollapsed,
            ),
          MenuItem(
            icon: Icons.task,
            title: "Tasks",
            isSelected: widget.selectedIndex == 4,
            onTap: () => widget.onItemSelected(4),
            isCollapsed: isCollapsed,
          ),

          // Expandable Performance Menu
          // Performance Section (Only show if user is Team Member or has access to Overview)
          if (userRole.toLowerCase() == "team member" || true) // 'true' allows others to see Overview
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      isPerformanceExpanded = !isPerformanceExpanded;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: isCollapsed ? 0 : 20),
                    margin: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: (widget.selectedIndex == 5 || widget.selectedIndex == 6)
                          ? Colors.blue.shade100
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
                      children: [
                        Icon(Icons.trending_up,
                            color: (widget.selectedIndex == 5 || widget.selectedIndex == 6)
                                ? Colors.blue
                                : Colors.black54),
                        if (!isCollapsed) const SizedBox(width: 10),
                        if (!isCollapsed)
                          Text(
                            "Performance",
                            style: TextStyle(
                              color: (widget.selectedIndex == 5 || widget.selectedIndex == 6)
                                  ? Colors.blue
                                  : Colors.black54,
                            ),
                          ),
                        if (!isCollapsed) Spacer(),
                        if (!isCollapsed)
                          Icon(
                            isPerformanceExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            size: 18,
                            color: Colors.black54,
                          ),
                      ],
                    ),
                  ),
                ),

                // Submenu
                if (isPerformanceExpanded && !isCollapsed)
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Column(
                      children: [
                        // Everyone sees this
                        MenuItem(
                          icon: Icons.bar_chart,
                          title: "Project Overview",
                          isSelected: widget.selectedIndex == 5,
                          onTap: () => widget.onItemSelected(5),
                          isCollapsed: isCollapsed,
                        ),

                        // Only team members see this
                        if( userRole.toLowerCase() != "admin")
                          MenuItem(
                            icon: Icons.people,
                            title: "Self Appraisal",
                            isSelected: widget.selectedIndex == 6,
                            onTap: () => widget.onItemSelected(6),
                            isCollapsed: isCollapsed,
                          ),

                          if((userRole.toLowerCase() != "team member"))
                            MenuItem(
                              icon: LucideIcons.clipboardList,
                              title: "Review Appraisal",
                              isSelected: widget.selectedIndex == 7,
                              onTap: () => widget.onItemSelected(7),
                              isCollapsed: isCollapsed,
                            ),
                      ],
                    ),
                  ),
              ],
            ),
          MenuItem(
            icon: Icons.person,
            title: "My Profile",
            isSelected: widget.selectedIndex == 8,
            onTap: () => widget.onItemSelected(8),
            isCollapsed: isCollapsed,
          ),
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isCollapsed;

  const MenuItem({
    required this.icon,
    required this.title,
    this.isSelected = false,
    this.onTap,
    this.isCollapsed = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade100 : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment:
          isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Icon(icon, color: isSelected ? Colors.blue : Colors.black54),
            if (!isCollapsed) const SizedBox(width: 10),
            if (!isCollapsed)
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.black54,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

