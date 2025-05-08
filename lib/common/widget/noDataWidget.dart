import 'package:performance_management_system/pms.dart';

class NoDataWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final double iconSize;

  const NoDataWidget({
    Key? key,
    this.title = "No Data Available!",
    this.subtitle = "Data will appear here once added",
    this.icon = Icons.hourglass_empty,
    this.iconSize = 80,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: Colors.grey[400]),
          const SizedBox(height: 10),
          Text(
            title,
            style: styleW500S18.copyWith(color: Colors.grey[600])
          ),
          appSizedBox(height: 4),
          Text(
            subtitle,
            style: styleW400S13.copyWith(color: Colors.grey[500])
          ),
        ],
      ),
    );
  }
}
