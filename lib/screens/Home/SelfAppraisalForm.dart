import 'package:performance_management_system/pms.dart';

class AppraisalFormScreen extends StatelessWidget {
  final AppraisalFormController controller = Get.put(AppraisalFormController());
  final int initialStep;

  AppraisalFormScreen({Key? key, required this.initialStep}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set the initial step
    controller.currentStep = initialStep;
    return FutureBuilder(
      future: controller.getAppraisalMetrics(),
      builder: (context, snapshot) {
        return GetBuilder<AppraisalFormController>(
          id: 'home',
          builder: (_) {
            return StackedLoader(
              loading: controller.loader,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (controller.currentStep == 0)
                      SectionSelfAppraisalTable(),
                    if (controller.currentStep == 1)
                      controller.appraisalId.isNotEmpty
                          ? ReadOnlySectionSelfAppraisal()
                          : SectionSelfAppraisal(),
                    if (controller.currentStep == 2)
                      controller.appraisalId.isNotEmpty
                          ? ReadOnlyAppraisalMetricsTable(controller: controller, userId: 1)
                          : AppraisalMetricsTable(controller: controller, userId: 1),
                    //AppraisalMetricsTable(controller: controller, userId: 1),
                    if (controller.currentStep == 3)
                      SectionReportingOfficer(),
                    if (controller.currentStep == 4)
                      SectionReview(),
                    // Uncomment and use SectionAcceptance() if needed
                    // SectionAcceptance(),

                    appSizedBox(height: 2.h),

                    if (controller.currentStep > 0)
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Previous Button (Visible only on steps > 0)
                            if (controller.currentStep > 0)
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0), // Spacing between buttons
                                child: AppButton(
                                  onButtonTap: () => controller.previousStep(),
                                  buttonName: 'Previous',
                                  buttonWidth: 120,
                                ),
                              ),

                            // Next/Submit Button
                            AppButton(
                              onButtonTap: () {
                                print("Current Step:, ${controller.currentStep}");
                                if (controller.currentStep == 1) {
                                  if(controller.appraisalId.isNotEmpty){
                                    controller.nextStep();
                                  }else{
                                    if(controller.SectionSelfAppraisalValidation())
                                      controller.submitAppraisalDataForm1(context);
                                  }
                                } else if (controller.currentStep == 2) {
                                  if(controller.appraisalId.isEmpty)
                                    controller.submitAppraisalDataForm2(context);
                                  else{
                                    // Go to step 0 and update UI
                                    controller.currentStep = 0;
                                    controller.update(['home']);
                                  }
                                } else if (controller.currentStep == 3) {
                                  controller.nextStep();
                                }
                              },
                              buttonName: controller.currentStep == 2
                                  ? (controller.appraisalId.isEmpty ? 'Submit' : 'Exit')
                                  : 'Next',
                              buttonWidth: 120,
                            )
                          ],
                        ),
                      )
                  ],
                ),
              )
            );
          },
        );
      },
    );
  }
}

class SectionReadOnlyReportingOfficer extends StatelessWidget {
  const SectionReadOnlyReportingOfficer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppraisalFormController>();

    return Column(
      children: [
        CommonSectionCard(
          title: "Performance and achievements over the last year",
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      ReadOnlyTextDisplay(
                        title: "Resource’s strengths (with examples)",
                        value: controller.strength,
                      ),
                      appSizedBox(height: 2.h),
                      ReadOnlyTextDisplay(
                        title: "Comment on Resource’s financial and moral integrity.",
                        value: controller.utilization,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: [
                      ReadOnlyTextDisplay(
                        title: "Resource’s weakness (with examples)",
                        value: controller.weaknesses,
                      ),
                      appSizedBox(height: 2.h),
                      ReadOnlyTextDisplay(
                        title: "How can Resource’s use their positive attributes to excel?",
                        value: controller.goalMeasure,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        appSizedBox(height: 2.h),
        CommonSectionCard(
          title: "Goal achievement",
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ReadOnlyTextDisplay(
                    title: "Did resource manage to accomplish previously–set goals?",
                    value: controller.goalStatus,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: ReadOnlyTextDisplay(
                    title: "How did resource measure the progress of these goals?",
                    value: controller.goalProgressMeasure,
                  ),
                ),
              ],
            ),
          ],
        ),
        appSizedBox(height: 2.h),
        CommonSectionCard(
          children: [
            ReadOnlyTextDisplay(
              title: "What additional support/upskilling do you recommend for the resource?",
              value: controller.upskillRecommend,
            ),
          ],
        )
      ],
    );
  }
}

class SectionSelfAppraisalTable extends StatelessWidget {
  const SectionSelfAppraisalTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppraisalFormController>();

    return GetBuilder<AppraisalFormController>(
      id: 'home',
      builder: (_) {
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
                    _buildHeaderRow(controller),
                    ...paginatedTasks.map((task) =>
                        _buildDataRow(task, controller, context)).toList(),
                  ],
                ),
                if (!controller.loader && paginatedTasks.isEmpty)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: const NoDataWidget(
                      title: "No Appraisal Added!",
                      subtitle: "Self Appraisals will appear here once added",
                      icon: Icons.task_alt_outlined,
                    ),
                  ),
                if (paginatedTasks.isNotEmpty) const SizedBox(height: 10),
                if (paginatedTasks.isNotEmpty)
                  _buildPaginationControls(controller),
              ],
            ),
          );
      },
    );
  }

  Widget _buildPaginationControls(AppraisalFormController controller) {
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "completed":
        return Colors.green;
      case "pending":
        return Colors.orange;
      case "delayed":
        return Colors.red;
      case "under review":
        return Colors.blueAccent;
      default:
        return Colors.black87;
    }
  }


  TableRow _buildHeaderRow(AppraisalFormController controller) {
    var style = styleW600S14;
    return TableRow(
      decoration: const BoxDecoration(color: Color(0xFFF0F0F0)),
      children: [
        _cell('#', style),
        _cell('Start Date', style),
        _cell('End Date', style),
        _cell('Currently With', style),
        _cell('Status', style),
        _cell('Action', style),
      ],
    );
  }

  Widget _statusCell(String status, TextStyle style) {
    Color bgColor = _getStatusColor(status);

    return Container(
      height: 60,
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: bgColor.withOpacity(0.6),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          status,
          style: style.copyWith(color: ColorRes.white),
        ),
      ),
    );
  }


  TableRow _buildDataRow(
      SelfAppraisalListData task,
      AppraisalFormController controller,
      BuildContext context,
      ) {
    var style = styleW400S13;
    final index = controller.paginatedTasks.indexOf(task) + 1;
    final srNo = controller.currentPage * controller.rowsPerPage + index;

    return TableRow(
      children: [
        _cell(srNo.toString(), style),
        _cell(task.startDate ?? '', style),
        _cell(task.endDate ?? '', style),
        _cell("${task.currentlyWith?.name.toString() ?? ''} (${task.currentlyWith?.designation.toString() ?? ''})", style),
        _statusCell(task.status ?? '', styleW500S13),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                controller.appraisalId = task.id.toString();
                controller.nextStep();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorRes.appBlueColor,
              ),
              child: const Text("View", style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _cell(String text, TextStyle style) {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.center, // Centers text both vertically and horizontally
      child: Text(text, style: style,
        textAlign: TextAlign.center,
        softWrap: true,
        overflow: TextOverflow.visible,
        maxLines: null,
      ),
    );
  }
}

class SectionSelfAppraisal extends StatelessWidget {
  const SectionSelfAppraisal({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppraisalFormController>();

    return Column(
      children: [
        CommonSectionCard(
         children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      CommonTextField(
                        heading: "Brief description of work done during the period under review",
                        controller: controller.workDoneController,
                        textInputType: TextInputType.text,
                        errorText: controller.workDoneErrorText,
                        maxLines: 4,
                      ),
                      appSizedBox(height: 2.h),
                      CommonTextField(
                        heading: "Area if any, where skill upgradation is required.",
                        controller: controller.skillsController,
                        textInputType: TextInputType.text,
                        errorText: controller.skillsErrorText,
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: [
                      CommonTextField(
                        heading: "Exceptional work done during the year, if any.",
                        controller: controller.exceptionWorkController,
                        textInputType: TextInputType.text,
                        errorText: controller.exceptionWorkErrorText,
                        maxLines: 4,
                      ),
                      appSizedBox(height: 2.h),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
        appSizedBox(height: 2.h),
        CommonSectionCard(
          title: "Plans for the next year",
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      CommonTextField(
                        heading: "How do you plan on improving your skills sets in Specific area?",
                        controller: controller.improvingSkillsController,
                        textInputType: TextInputType.text,
                        errorText: controller.improvingSkillsErrorText,
                        maxLines: 4,
                      ),
                      appSizedBox(height: 2.h),
                      CommonTextField(
                        heading: "Do you need any help (from managers or other team members) where you want to improve?",
                        controller: controller.helpNeededController,
                        textInputType: TextInputType.text,
                        errorText: controller.helpNeededErrorText,
                        maxLines: 4,
                      ),
                      appSizedBox(height: 2.h),
                      CommonTextField(
                        heading: "How do your professional goals align with team goals and the Department’s mission?",
                        controller: controller.alignWithTeamGoalsController,
                        textInputType: TextInputType.text,
                        errorText: controller.alignWithTeamGoalsErrorText,
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: [
                      CommonTextField(
                        heading: "What are your professional goals for the next year?",
                        controller: controller.professionalGoalsController,
                        textInputType: TextInputType.text,
                        errorText: controller.professionalGoalsErrorText,
                        maxLines: 4,
                      ),
                      appSizedBox(height: 2.h),
                      CommonTextField(
                        heading: "How will your measure the progress of these goals?",
                        controller: controller.measureProgressController,
                        textInputType: TextInputType.text,
                        errorText: controller.measureProgressErrorText,
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),

      ],
    );
  }
}

class AppraisalMetricsTable extends StatelessWidget {
  final int userId;
  final AppraisalFormController controller;

  AppraisalMetricsTable({
    required this.controller,
    required this.userId,
  });

  List<Header> getHeaders() {
    List<Header> headers = [Header(title: 'Sr No', flex: 1)];

    headers.add(Header(title: 'Category', flex: 4));
    headers.add(Header(title: 'Max Marks', flex: 1));

    if (userId >= 1) {
      headers.add(Header(title: 'Self Rating', flex: 1));
    }
    if (userId >= 2) {
      headers.add(Header(title: 'Reporting Officer Rating', flex: 1));
    }
    if (userId == 3) {
      headers.add(Header(title: 'Reviewing Officer Rating', flex: 1));
    }

    return headers;
  }

  @override
  Widget build(BuildContext context) {
    final headers = getHeaders();
    final data = controller.metricsList;
    controller.initializeControllers();

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: Column(
            children: [
              // Header Row
              Row(
                children: headers.map((h) {
                  return Expanded(
                    flex: h.flex ?? 1,
                    child: Container(
                      height: 60,
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Colors.grey),
                          bottom: BorderSide(color: Colors.grey),
                        ),
                      ),
                      child: Text(
                        h.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }).toList(),
              ),
              // Data Rows
              ...List.generate(data.length, (index) {
                final row = data[index];
                return Row(
                  children: List.generate(headers.length, (colIndex) {
                    return Expanded(
                      flex: headers[colIndex].flex ?? 1,
                      child: Container(
                        height: 60,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.grey),
                            bottom: BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: _buildCellContent(context, row, colIndex, index),
                      ),
                    );
                  }),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCellContent(BuildContext context, MetricsData row, int colIndex, int index) {
    int currentColumn = 0;

    // Sr No
    if (colIndex == currentColumn++) {
      return Text('${index + 1}', textAlign: TextAlign.center);
    }

    // Category (category + subcategory)
    if (colIndex == currentColumn++) {
      return RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
          style: TextStyle(color: Colors.black, fontSize: 14),
          children: [
            TextSpan(
              text: '${row.category ?? ''} - ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: '${row.description ?? ''}',
            ),
          ],
        ),
      );
    }

    // Max Marks
    if (colIndex == currentColumn++) {
      return Text('${row.maximumMarks ?? ''}', textAlign: TextAlign.center);
    }

    // Self Rating
    if ((userId == 1 && colIndex == currentColumn) ||
        (userId == 2 && colIndex == currentColumn) ||
        (userId == 3 && colIndex == currentColumn)) {
      bool isEditable = userId == 1;
      return isEditable
          ?
      TextFormField(
        controller: controller.controllers[index], // optional if using controller
        focusNode: controller.focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        ),
        onChanged: (value) {
          int? enteredValue = int.tryParse(value);
          row.selfRating = enteredValue;

          /*if (enteredValue == null) {
            toastMsg("Please enter a valid self rating.");
          } else if (enteredValue <= int.tryParse(row.maximumMarks ?? '0')!) {
            row.selfRating = enteredValue;
          } else {
            toastMsg("Self Rating should be less than or equal to ${row.maximumMarks}");
          }*/
        },
        onFieldSubmitted: (value) {
          if (index < controller.focusNodes.length - 1) {
            controller.focusNodes[index + 1].requestFocus();
          } else {
            //FocusScope.of(context).unfocus();
          }
        },
      )

          : Text(
        row.selfRating.toString() ?? '',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14),
      );
    } else {
      currentColumn++;
    }

    // Reporting Officer Rating
    if ((userId == 2 && colIndex == currentColumn) ||
        (userId == 3 && colIndex == currentColumn)) {
      bool isEditable = userId == 2;
      return isEditable
          ? TextFormField(
        initialValue: '',//row.reportingRating?.toString() ?? '',
        enabled: true,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        ),
        //onChanged: (value) => row.reportingRating = int.tryParse(value),
      )
          : Text(
        row.reportingOfficerRating?.toString() ?? '',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14),
      );
    } else if (userId == 2 || userId == 3) {
      currentColumn++;
    }

    // Reviewing Officer Rating
    if (userId == 3 && colIndex == currentColumn) {
      bool isEditable = userId == 3;
      return TextFormField(
        initialValue: row.reviewingOfficerRating?.toString() ?? '',
        enabled: true,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        ),
        //onChanged: (value) => row.reviewingRating = int.tryParse(value),
      );
    }

    return const SizedBox.shrink();
  }

}

class ReadOnlyAppraisalMetricsTable extends StatelessWidget {
  final int userId;
  final AppraisalFormController controller;

  ReadOnlyAppraisalMetricsTable({
    required this.controller,
    required this.userId,
  });

  List<Header> getHeaders() {
    List<Header> headers = [Header(title: 'Sr No', flex: 1)];

    headers.add(Header(title: 'Category', flex: 4));
    headers.add(Header(title: 'Max Marks', flex: 1));

    headers.add(Header(title: 'Self Rating', flex: 1));
 /*   headers.add(Header(title: 'Reporting Officer Rating', flex: 1));
    if (userId == int.parse(controller.reviewingOfficerId)) {
      headers.add(Header(title: 'Reviewing Officer Rating', flex: 1));
    }*/

    return headers;
  }

  @override
  Widget build(BuildContext context) {
    final headers = getHeaders();
    final data = controller.filledmetricsList;
    controller.initializeControllers();

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: Column(
            children: [
              // Header Row
              Row(
                children: headers.map((h) {
                  return Expanded(
                    flex: h.flex ?? 1,
                    child: Container(
                      height: 60,
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Colors.grey),
                          bottom: BorderSide(color: Colors.grey),
                        ),
                      ),
                      child: Text(
                        h.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }).toList(),
              ),
              // Data Rows
              ...List.generate(data.length, (index) {
                final row = data[index];
                return Row(
                  children: List.generate(headers.length, (colIndex) {
                    return Expanded(
                      flex: headers[colIndex].flex ?? 1,
                      child: Container(
                        height: 60,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.grey),
                            bottom: BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: _buildCellContent(context, row, colIndex, index),
                      ),
                    );
                  }),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCellContent(BuildContext context, SelfAppraisalListMetricsData row, int colIndex, int index) {
    int currentColumn = 0;
print(" row.selfRating.toString(): ${ row.selfRating.toString()}");
    // Sr No
    if (colIndex == currentColumn++) {
      return Text('${index + 1}', textAlign: TextAlign.center);
    }

    // Category (category + subcategory)
    if (colIndex == currentColumn++) {
      return RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
          style: TextStyle(color: Colors.black, fontSize: 14),
          children: [
            TextSpan(
              text: '${row.category ?? ''} - ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: '${row.description ?? ''}',
            ),
          ],
        ),
      );
    }

    // Max Marks
    if (colIndex == currentColumn++) {
      return Text('${row.maximumMarks ?? ''}', textAlign: TextAlign.center);
    }

    if (colIndex == currentColumn++) {
      return Text('${row.selfRating.toString() ?? ''}', textAlign: TextAlign.center);
    }

//int.parse(controller.reportingOfficerId)
    // Self Rating
   /* if (//(userId == 1 && colIndex == currentColumn) ||
    (userId == int.parse(controller.reportingOfficerId) && colIndex == currentColumn) ||
        (userId == int.parse(controller.reviewingOfficerId) && colIndex == currentColumn)) {
      *//*bool isEditable = userId != int.parse(controller.reportingOfficerId) &&
          userId != int.parse(controller.reviewingOfficerId);*//*
      bool isEditable = false;
      return isEditable ?
      TextFormField(
        controller: controller.controllers[index],
        focusNode: controller.focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        ),
        onChanged: (value) {
          int? enteredValue = int.tryParse(value);
          row.selfRating = enteredValue;

          *//*if (enteredValue == null) {
            toastMsg("Please enter a valid self rating.");
          } else if (enteredValue <= int.tryParse(row.maximumMarks ?? '0')!) {
            row.selfRating = enteredValue;
          } else {
            toastMsg("Self Rating should be less than or equal to ${row.maximumMarks}");
          }*//*
        },
        onFieldSubmitted: (value) {
          if (index < controller.focusNodes.length - 1) {
            controller.focusNodes[index + 1].requestFocus();
          } else {
            //FocusScope.of(context).unfocus();
          }
        },
      )
          : Text(
        row.selfRating.toString() ?? '',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14),
      );
    } else {
      currentColumn++;
    }*/
/*
    // Reporting Officer Rating
    if ((userId == int.parse(controller.reportingOfficerId) && colIndex == currentColumn) ||
        (userId == int.parse(controller.reviewingOfficerId) && colIndex == currentColumn))  {

      bool isEditable = userId == int.parse(controller.reportingOfficerId);
      int rating = row.reportingOfficerRating ?? 0;
      print("row.reportingOfficerRating ${row.reportingOfficerRating.toString()}");

      // If rating is greater than 0 and user is reporting officer → editable field
      if (isEditable && rating <= 0) {
        return TextFormField(
          controller: controller.controllers[index],
          focusNode: controller.focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          ),
          onChanged: (value) => row.reportingOfficerRating = int.tryParse(value),
          onFieldSubmitted: (value) {
            if (index < controller.focusNodes.length - 1) {
              controller.focusNodes[index + 1].requestFocus();
            }
          },
        );
      } else {
        // Just display the rating if > 0, else empty
        return Text(
          rating > 0 ? rating.toString() : '',
          textAlign: TextAlign.center,
          style: styleW400S14,
        );
      }

    } else if (userId == int.parse(controller.reportingOfficerId) || userId == int.parse(controller.reviewingOfficerId)) {
      currentColumn++;
    }


    // Reviewing Officer Rating
    if (userId == int.parse(controller.reviewingOfficerId) && colIndex == currentColumn) {
      bool isEditable = userId == int.parse(controller.reviewingOfficerId);
      int rating = row.reviewingOfficerRating ?? 0;

      if (isEditable && rating <= 0) {
        return TextFormField(
          controller: controller.controllers[index],
          focusNode: controller.focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          ),
          onChanged: (value) => row.reviewingOfficerRating = int.tryParse(value),
          onFieldSubmitted: (value) {
            if (index < controller.focusNodes.length - 1) {
              controller.focusNodes[index + 1].requestFocus();
            }
          },
        );
      } else {
        return Text(
          rating > 0 ? rating.toString() : '',
          textAlign: TextAlign.center,
          style: styleW400S14,
        );
      }
    }*/

    return const SizedBox.shrink();
  }

}


class SectionReportingOfficer extends StatelessWidget {
  const SectionReportingOfficer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppraisalFormController>();

    return Column(
      children: [
        CommonSectionCard(
          title: "Performance and achievements over the last year",
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      CommonTextField(
                        heading: "Resource’s strengths (with examples)",
                        controller: controller.strengthController,
                        textInputType: TextInputType.text,
                        errorText: controller.strengthErrorText,
                        maxLines: 4,
                      ),
                      appSizedBox(height: 2.h),
                      CommonTextField(
                        heading: "Comment on Resource’s financial and moral integrity.",
                        controller: controller.utilizationController,
                        textInputType: TextInputType.text,
                        errorText: controller.utilizationErrorText,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: [
                      CommonTextField(
                        heading: "Resource’s weakness (with examples)",
                        controller: controller.weaknessesController,
                        textInputType: TextInputType.text,
                        errorText: controller.weaknessesErrorText,
                        maxLines: 4,
                      ),
                      appSizedBox(height: 2.h),
                      CommonTextField(
                        heading: "How can Resource’s use their positive attributes to excel?",
                        controller: controller.goalMeasureController,
                        textInputType: TextInputType.text,
                        errorText: controller.goalMeasureErrorText,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        appSizedBox(height: 2.h),
        CommonSectionCard(
          title: "Goal achievement",
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      CommonTextField(
                        heading: "Did resource manage to accomplish previously–set goals?",
                        controller: controller.goalStatusController,
                        textInputType: TextInputType.text,
                        errorText: controller.goalStatusErrorText,
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: [
                      CommonTextField(
                        heading: "How did resource measure the progress of these goals? ",
                        controller: controller.goalProgressMeasureController,
                        textInputType: TextInputType.text,
                        errorText: controller.goalProgressMeasureErrorText,
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        appSizedBox(height: 2.h),
        CommonSectionCard(
         children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      CommonTextField(
                        heading: "Did resource manage to accomplish previously–set goals?",
                        controller: controller.upskillRecommendController,
                        textInputType: TextInputType.text,
                        errorText: controller.upskillRecommendErrorText,
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}

class SectionReview extends StatelessWidget {
  const SectionReview({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppraisalFormController>();

    return CommonSectionCard(
      // title: "Section V – Review",
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title/Heading
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0), // Padding to separate title and dropdown
                        child: Text(
                          "Do you agree with the assessment made by the Reporting Officer?",
                          style: styleW500S14,
                        ),
                      ),

                      // Dropdown
                      commonDropdown(
                        '',
                        ["Yes", "No"],
                        controller.reviewAgreement.value,
                            (val) => controller.reviewAgreement.value = val ?? "Yes",
                      ),
                    ],
                  )),
                  appSizedBox(height: 2.h),
                  CommonTextField(
                    heading: "In case of difference of opinion, details / reasons for the same may be given:",
                    controller: controller.reviewDifferenceController,
                    textInputType: TextInputType.text,
                    errorText: controller.reviewDifferenceErrorText,
                    maxLines: 4,
                  ),
                ],
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                children: [
                  CommonTextField(
                    heading: "Comments of Reviewing Authority (if any):",
                    controller: controller.reviewCommentsController,
                    textInputType: TextInputType.text,
                    errorText: controller.reviewCommentsErrorText,
                    maxLines: 4,
                  ),
                  appSizedBox(height: 2.h),
                  CommonTextField(
                    heading: "Overall Rating (out of 100)",
                    controller: controller.reviewOverallController,
                    textInputType: TextInputType.number,
                    errorText: controller.reviewOverallErrorText,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ReadOnlySectionSelfAppraisal extends StatelessWidget {
  const ReadOnlySectionSelfAppraisal({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppraisalFormController>();

    return Column(
      children: [
        CommonSectionCard(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      ReadOnlyTextDisplay(
                        title: "Brief description of work done during the period under review",
                        value: controller.workDone,
                      ),
                      appSizedBox(height: 2.h),
                      ReadOnlyTextDisplay(
                        title: "Area if any, where skill upgradation is required.",
                        value: controller.skills,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: [
                      ReadOnlyTextDisplay(
                        title: "Exceptional work done during the year, if any.",
                        value: controller.exceptionWork,
                      ),
                      appSizedBox(height: 2.h),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
        appSizedBox(height: 2.h),
        CommonSectionCard(
          title: "Plans for the next year",
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      ReadOnlyTextDisplay(
                        title: "How do you plan on improving your skills sets in Specific area?",
                        value: controller.improvingSkills,
                      ),
                      appSizedBox(height: 2.h),
                      ReadOnlyTextDisplay(
                        title: "Do you need any help (from managers or other team members) where you want to improve?",
                        value: controller.helpNeeded,
                      ),
                      appSizedBox(height: 2.h),
                      ReadOnlyTextDisplay(
                        title: "How do your professional goals align with team goals and the Department’s mission?",
                        value: controller.alignWithTeamGoals,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: [
                      ReadOnlyTextDisplay(
                        title: "What are your professional goals for the next year?",
                        value: controller.professionalGoals,
                      ),
                      appSizedBox(height: 2.h),
                      ReadOnlyTextDisplay(
                        title: "How will your measure the progress of these goals?",
                        value: controller.measureProgress,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

/*
class SectionBasicInfo extends StatelessWidget {
  const SectionBasicInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppraisalFormController>();

    return CommonSectionCard(
    //  title: "Section I – Basic Information",
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonTextFormField(
                    label: "Resource Name",
                    value: controller.resourceName,
                    onChanged: (val) => controller.resourceName = val,
                    validator: (val) => val == null || val.isEmpty ? 'Please enter resource name' : null,
                  ),
                  appSizedBox(height: 2.h),

                  CommonTextFormField(
                    label: "Resource ID",
                    value: controller.resourceId,
                    onChanged: (val) => controller.resourceId = val,
                    validator: (val) => val == null || val.isEmpty ? 'Please enter resource ID' : null,
                  ),
                  appSizedBox(height: 2.h),

                  CommonTextFormField(
                    label: "Position Name",
                    value: controller.positionName,
                    onChanged: (val) => controller.positionName = val,
                    validator: (val) => val == null || val.isEmpty ? 'Please enter position name' : null,
                  ),
                  appSizedBox(height: 2.h),

                  CommonTextFormField(
                    label: "Date of Birth",
                    value: controller.dob,
                    onChanged: (val) => controller.dob = val,
                    validator: (val) => val == null || val.isEmpty ? 'Please enter date of birth' : null,
                  ),
                  appSizedBox(height: 2.h),

                  CommonTextFormField(
                    label: "Academic Qualification",
                    value: controller.qualification,
                    onChanged: (val) => controller.qualification = val,
                    validator: (val) => val == null || val.isEmpty ? 'Please enter academic qualification' : null,
                  ),

                ],
              ),
            ),
            SizedBox(width: 20), // Space between the two columns
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  CommonTextFormField(
                    label: "Date of Joining at the present Position",
                    value: controller.dojPresent,  // Use  to access the controller's text
                    onChanged: (val) => controller.dojPresent = val,  // Update the controller's text
                    validator: (val) => val == null || val.isEmpty ? 'Please enter date of joining (present position)' : null,
                  ),
                  appSizedBox(height: 2.h),

                  CommonTextFormField(
                    label: "Date of Joining in Department",
                    value: controller.dojDept,  // Use  to access the controller's text
                    onChanged: (val) => controller.dojDept = val,  // Update the controller's text
                    validator: (val) => val == null || val.isEmpty ? 'Please enter date of joining (department)' : null,
                  ),
                  appSizedBox(height: 2.h),

                  CommonTextFormField(
                    label: "Reporting Officer Name & Designation",
                    value: controller.reportingOfficer,  // Use  to access the controller's text
                    onChanged: (val) => controller.reportingOfficer = val,  // Update the controller's text
                    validator: (val) => val == null || val.isEmpty ? 'Please enter reporting officer name & designation' : null,
                  ),
                  appSizedBox(height: 2.h),

                  CommonTextFormField(
                    label: "Reviewing Authority Name & Designation",
                    value: controller.reviewingOfficer,  // Use  to access the controller's text
                    onChanged: (val) => controller.reviewingOfficer = val,  // Update the controller's text
                    validator: (val) => val == null || val.isEmpty ? 'Please enter reviewing authority name & designation' : null,
                  ),
                  appSizedBox(height: 2.h),

                  CommonTextFormField(
                    label: "Accepting Authority Name & Designation",
                    value: controller.acceptingOfficer,  // Use  to access the controller's text
                    onChanged: (val) => controller.acceptingOfficer = val,  // Update the controller's text
                    validator: (val) => val == null || val.isEmpty ? 'Please enter accepting authority name & designation' : null,
                  ),

                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
*/

/*
class SectionAcceptance extends StatelessWidget {
  const SectionAcceptance({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppraisalFormController>();

    return CommonSectionCard(
    //  title: "Section VI – Acceptance",
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  Obx(() => commonDropdown(
                    "Do you agree with Reviewing Officer?",
                    ["Yes", "No"],
                    controller.acceptanceAgreement.value,
                        (val) => controller.acceptanceAgreement.value = val ?? "Yes",
                  )),
                  appSizedBox(height: 2.h),
                  CommonTextFormField(
                    label: "Difference of opinion (if any)",
                    value: controller.acceptanceDifference,
                    onChanged: (val) => controller.acceptanceDifference = val,
                    validator: (val) => val == null || val.isEmpty ? 'Please enter difference of opinion' : null,
                    maxLines: 3,
                  ),
                  appSizedBox(height: 2.h),
                ],
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                children: [
                  CommonTextFormField(
                    label: "Comments of Accepting Authority",
                    value: controller.acceptanceComments,
                    onChanged: (val) => controller.acceptanceComments = val,
                    validator: (val) => val == null || val.isEmpty ? 'Please enter accepting authority comments' : null,
                    maxLines: 3,
                  ),
                  appSizedBox(height: 2.h),
                  CommonTextFormField(
                    label: "Overall Rating (out of 100)",
                    value: controller.acceptanceOverallRating,
                    onChanged: (val) => controller.acceptanceOverallRating = val,
                    validator: (val) => val == null || val.isEmpty ? 'Please enter overall rating' : null,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );

  }
}
*/

Widget _yearFilter(AppraisalFormController controller) {
  return SizedBox(
    width: 200,
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
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 12,
        ),
        isDense: true,
      ),
      style: styleW400S13,
      dropdownColor: Colors.white,
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.grey, size: 20),
      iconEnabledColor: Colors.grey,
      items:
      controller.availableFinancialYears.map((year) {
        return DropdownMenuItem(
          value: year,
          child: Text(year, style: styleW400S13),
        );
      }).toList(),
      onChanged: (val) => controller.setYearFilter(val),
    ),
  );
}

Widget _buildTopControls(
    AppraisalFormController controller,
    BuildContext context,
    ) {
  return Row(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Top Row: Year + Add Button (right aligned)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _yearFilter(controller),
                  appSizedBox(width: 40),
                  if (controller.selectedYear != null)
                    ElevatedButton.icon(
                      onPressed: () {
                        controller.appraisalId = '';
                        controller.nextStep();
                      },
                      icon: Icon(Icons.add),
                      label: Text("Add Self Appraisal"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorRes.appBlueColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(height: 1.5.h),

              /// 🔹 Bottom Row: Show Entries
              Row(
                children: [
                  Text('Show'),
                  appSizedBox(width: 0.5.w),
                  Container(
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
                        items: controller.rowsPerPageOptions
                            .toSet()
                            .toList()
                            .map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  appSizedBox(width: 0.5.w),
                  Text('entries'),
                ],
              ),
            ],
          )

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