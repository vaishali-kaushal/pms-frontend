import 'package:performance_management_system/pms.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  final String secureId; // Declare secureId

  // Add secureId to the constructor
  ProfileScreen({Key? key, required this.secureId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      id: 'home',
      initState: (_) {
        controller.fetchProfileDetail();
      },
      builder: (_) {
        final data = controller.profileData;
        if (controller.loader || data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade900,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, size: 50, color: Colors.blue),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.name.toString(),
                              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              data.designation.toString(),
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  CommonSectionCard(
                    title: "Contact details",
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          double fieldWidth = (constraints.maxWidth - 16) / 2; // 2 columns with 16 spacing
                          return Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: [
                              _buildField("Name", value: data.name.toString()),
                              _buildField("Email", value: data.email.toString()),
                              _buildField("Mobile no.", value: data.mobileNumber.toString()),
                              _buildDropdown("Qualification", value: data.qualification?.join(", ") ?? ""),
                              _buildDateField("Date of Birth", value: formatDateStringFunc(data.dob)),
                              _buildDateField("Date of Joining", value: formatDateStringFunc(data.doj)),
                              _buildField("Deployment Location", value: data.department?.join((", ") ?? "")),
                              _buildDropdown("Designation", value: data.designation),
                              _buildDropdown("Employer", value: data.employer),
                              _buildDropdown("Domain", value: data.domain.toString()),
                              _buildDropdown("Sub Domain", value: data.subDomain.toString()),
                              _buildDropdown("Skills", value: data.skills?.join(", ") ?? ""),
                              _buildDropdown("Role", value: data.role.toString()),
                              _buildDropdown("Reporting Officer", value: data.reportingOfficer.toString()),
                              _buildDropdown("Reviewing Officer", value: data.reviewingOfficer.toString()),
                              _buildDropdown("Office Location", value: data.location),
                              _buildDropdown("Division", value: data.division?.join(", ") ?? ""),
                              _buildField("Salary", value: data.salary.toString()),
                              _buildFileUpload(
                                "Upload CV",
                                value: controller.resume,
                                url: controller.resume,
                              ),
                            ].map((widget) => SizedBox(
                              width: fieldWidth,
                              child: widget,
                            )).toList(),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  CommonSectionCard(
                    title: "Experience",
                    children: [

                      LayoutBuilder(
                        builder: (context, constraints) {
                          double fieldWidth = (constraints.maxWidth - 16) / 2; // 2 columns with 16 spacing
                          return Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: [
                              _buildDropdown("Years", value: controller.years),
                              _buildDropdown("Months", value: controller.months),
                            ].map((widget) => SizedBox(
                              width: fieldWidth,
                              child: widget,
                            )).toList(),
                          );
                        },
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        );
      },
    );
  }


  Widget _buildField(String label, {String? value}) {
    return SizedBox(
      width: 220,
      child: TextField(
        controller: TextEditingController(text: value ?? ''),
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }
  Widget _buildDropdown(String label, {String? value}) {
    return SizedBox(
      width: 220,
      child: TextField(
        controller: TextEditingController(text: value ?? ''),
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
          suffixIcon: Icon(
            Icons.arrow_drop_down,
            color: Colors.grey, // 👈 makes arrow icon gray
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(String label, {String? value}) {
    return SizedBox(
      width: 220,
      child: TextField(
        controller: TextEditingController(text: value ?? ''),
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildFileUpload(String label, {String? value, String? url}) {
    return GestureDetector(
      onTap: () async {
        if (url != null && await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        }
      },
      child: SizedBox(
        width: 220,
        child: AbsorbPointer( // prevents actual editing
          child: TextField(
            controller: TextEditingController(text: value ?? 'Uploaded CV.pdf'),
            readOnly: true,
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
              suffixIcon: const Icon(Icons.upload_file, color: Colors.blue),
              isDense: true,
            ),
          ),
        ),
      ),
    );
  }

}


