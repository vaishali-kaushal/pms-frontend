import 'package:performance_management_system/pms.dart';

class SelfAppraisalTable extends StatelessWidget {
  final SelfAppraisalController controller = Get.put(SelfAppraisalController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SelfAppraisalController>(
      id: 'home',
      initState: (_) async {
        controller.fetchSelfTasks(true);
      },
      builder: (_) {
        return StackedLoader(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                getStepWidget(context, controller),

                if (controller.currentStep > 0)
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
                              controller.nextStep();
                            }else if (controller.currentStep == 2) {
                              controller.nextStep();
                            } else if (controller.currentStep == 3) {
                              String userId = PrefService.getString(PrefKeys.userId);
                              String reportingOfficerId = controller.reportingOfficerId;
                              String reviewingOfficerId = controller.reviewingOfficerId;

                              if (userId == reportingOfficerId) {

                                if (controller.isReportingFilled || controller.isReviewingFilled) {
                                  controller.nextStep();
                                } else {
                                  controller.submitAppraisalDataForm2(context);
                                }

                              } else if (userId == reviewingOfficerId) {

                                if (controller.isReviewingFilled) {
                                  controller.nextStep();
                                } else {
                                  controller.submitAppraisalDataForm2(context);
                                }
                              }

                            } else if (controller.currentStep == 4) {
                              if(PrefService.getString(PrefKeys.userId) == controller.reportingOfficerId){
                                if (!controller.isReportingFormNotFilled){
                                  controller.currentStep = 0;
                                  controller.update(['home']);
                                }else{
                                  if(controller.SectionReportingValidation())
                                    controller.submitAppraisalDataForm3(context);
                                }
                              }else{
                                controller.nextStep();
                              }
                            }else if(controller.currentStep == 5){
                              if (!controller.isReviewingFormNotFilled){
                                controller.currentStep = 0;
                                controller.update(['home']);
                              }else{
                                if(controller.sectionReviewValidation())
                                  controller.submitAppraisalDataForm4(context);
                              }

                            }
                          },
                          buttonName: controller.currentStep != ((PrefService.getString(PrefKeys.userId) ?? '') == (controller.reviewingOfficerId ?? '') ? 5 : 4)
                              ? 'Next'
                              : controller.currentStep == 4
                              ? (controller.isReportingFormNotFilled
                              ? 'Submit'
                              : (controller.isReportingFilled ? 'Exit' : 'Submit'))
                              : (controller.isReviewingFormNotFilled
                              ? 'Submit'
                              : (controller.isReviewingFilled ? 'Exit' : 'Submit')),
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
  }
}

Widget getStepWidget(BuildContext context, SelfAppraisalController controller) {
  if (controller.currentStep == 0) {
    return RSectionSelfAppraisalTable();
  } else if (controller.currentStep == 1) {
    return RSectionBasicInfo();
  } else if (controller.currentStep == 2) {
    return RSectionSelfAppraisal();
  } else if (controller.currentStep == 3) {
    return RAppraisalMetricsTable(controller: controller,
        userId: int.parse(PrefService.getString(PrefKeys.userId)));
  } else if (controller.currentStep == 4) {
    if (PrefService.getString(PrefKeys.userId) == controller.reportingOfficerId) {
      if (!controller.isReportingFormNotFilled) {
        return RSectionReadOnlyReportingOfficer();
      } else {
        return RSectionReportingOfficer();
      }
    } else if (PrefService.getString(PrefKeys.userId) == controller.reviewingOfficerId) {
      return RSectionReadOnlyReportingOfficer();
    }
  } else if (controller.currentStep == 5) {
    if (!controller.isReviewingFormNotFilled)
        return RSectionReadOnlyReview ();
    else
      return RSectionReview();
  }
  return Container();
}

class RSectionSelfAppraisalTable extends StatelessWidget {
  const RSectionSelfAppraisalTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SelfAppraisalController>();

    return GetBuilder<SelfAppraisalController>(
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
                      title: "No Appraisals Found!",
                      subtitle: "Appraisals will appear here once received",
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

  TableRow _buildHeaderRow(SelfAppraisalController controller) {
    var style = styleW600S14;
    return TableRow(
      decoration: const BoxDecoration(color: Color(0xFFF0F0F0)),
      children: [
        _cell('#', style),
        _cell('Name', style),
        _cell('Role', style),
        _cell('Designation', style),
        _cell('Employer', style),
        _cell('Received On', style),
       // _cell('Profile', style),
        _cell('Action', style),
      ],
    );
  }

  TableRow _buildDataRow(SelfTaskData task, SelfAppraisalController controller, BuildContext context) {
    var style = styleW400S13;
    final index = controller.paginatedTasks.indexOf(task) + 1;
    final srNo = controller.currentPage * controller.rowsPerPage + index;

    return TableRow(
      children: [
        _cell(srNo.toString(), style),
        _cell(task.user?.name ?? '', style),
        _cell(task.user?.role ?? '', style),
        _cell(task.user?.designation ?? '', style),
        _cell(task.user?.employer ?? '', style),
        _cell('02-05-2025' ?? '', style),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                controller.appraisalId = task.appraisalId.toString();
                controller.nextStep();
                controller.update(['home']);
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

class RSectionSelfAppraisal extends StatelessWidget {
  const RSectionSelfAppraisal({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SelfAppraisalController>();

    return Column(
      children: [
        CommonSectionCard(
          sectionName: "Section II",
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

class RAppraisalMetricsTable extends StatelessWidget {
  final int userId;
  final SelfAppraisalController controller;

  RAppraisalMetricsTable({
    required this.controller,
    required this.userId,
  });

  List<Header> getHeaders() {
    List<Header> headers = [Header(title: 'Sr No', flex: 1)];

    headers.add(Header(title: 'Category', flex: 4));
    headers.add(Header(title: 'Max Marks', flex: 1));

    headers.add(Header(title: 'Self Rating', flex: 1));
    headers.add(Header(title: 'Reporting Officer Rating', flex: 1));
    if (userId == int.parse(controller.reviewingOfficerId)) {
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
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            "Section III",
            style: styleW500S18,
            textAlign: TextAlign.center,
          ),
        ),
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
                      )
                    );
                  })
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCellContent(BuildContext context, UserMetricsData row, int colIndex, int index) {
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
    if ((userId == int.parse(controller.reportingOfficerId) && colIndex == currentColumn) ||
        (userId == int.parse(controller.reviewingOfficerId) && colIndex == currentColumn)) {
      bool isEditable = userId != int.parse(controller.reportingOfficerId) &&
          userId != int.parse(controller.reviewingOfficerId);
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
    if ((userId == int.parse(controller.reportingOfficerId) && colIndex == currentColumn) ||
        (userId == int.parse(controller.reviewingOfficerId) && colIndex == currentColumn))  {

      bool isEditable = userId == int.parse(controller.reportingOfficerId);
      int rating = row.reportingOfficerRating ?? 0;

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
    }

    return const SizedBox.shrink();
  }

}

class RSectionReportingOfficer extends StatelessWidget {
  const RSectionReportingOfficer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SelfAppraisalController>();

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

class RSectionReview extends StatelessWidget {
  const RSectionReview({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SelfAppraisalController>();

    return CommonSectionCard(
      sectionName: "Section IV",
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

class RSectionReadOnlyReview extends StatelessWidget {
  const RSectionReadOnlyReview({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SelfAppraisalController>();

    return CommonSectionCard(
      sectionName: "Section IV",
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  ReadOnlyTextDisplay(
                    title: "Do you agree with the assessment made by the Reporting Officer?",
                    value: controller.reviewAgreementString,
                  ),
                  appSizedBox(height: 2.h),
                  // Read-only text field display
                  ReadOnlyTextDisplay(
                    title: "In case of difference of opinion, details / reasons for the same may be given:",
                    value: controller.reviewDifference,
                  ),
                ],
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                children: [
                  // Read-only text field display
                  ReadOnlyTextDisplay(
                    title: "Comments of Reviewing Authority (if any):",
                    value: controller.reviewComments,
                  ),
                  appSizedBox(height: 2.h),
                  // Read-only text field display
                  ReadOnlyTextDisplay(
                    title: "Overall Rating (out of 100)",
                    value: controller.reviewOverall,
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

class RSectionBasicInfo extends StatelessWidget {
  const RSectionBasicInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SelfAppraisalController>();

    return CommonSectionCard(
      sectionName: "Section I",
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildInfoTile("Resource Name", controller.resourceName),
                  appSizedBox(height: 2.h),
                 /* buildInfoTile("Resource ID", controller.resourceId),
                  appSizedBox(height: 2.h),*/
                  buildInfoTile("Date of Birth", formatDateStringFunc(controller.dob)),
                  appSizedBox(height: 2.h),
                  buildInfoTile("Current Office Location", 'Haryana Police')
                  /*appSizedBox(height: 2.h),
                  buildInfoTile("Academic Qualification", controller.qualification),*/
                ],
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildInfoTile("Designation", controller.positionName),
                  appSizedBox(height: 2.h),
                  buildInfoTile("Date of Joining (DITECH)", controller.dojDept),
                  appSizedBox(height: 2.h),
                  buildInfoTile("Date of Joining (Current Location)", formatDateStringFunc(controller.dojPresent)),

                  //appSizedBox(height: 2.h),
                  /*buildInfoTile("Reporting Officer Name & Designation", controller.reportingOfficer),
                  appSizedBox(height: 2.h),
                  buildInfoTile("Reviewing Authority Name & Designation", controller.reviewingOfficer),*/
                 // appSizedBox(height: 2.h),
                 // buildInfoTile("Accepting Authority Name & Designation", controller.acceptingOfficer),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildInfoTile(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: styleW500S13),
        appSizedBox(height: 0.5.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(value.isNotEmpty ? value : '-', style: styleW400S13),
        ),
      ],
    );
  }
}

class RSectionReadOnlyReportingOfficer extends StatelessWidget {
  const RSectionReadOnlyReportingOfficer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SelfAppraisalController>();

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



Widget _buildTopControls(
  SelfAppraisalController controller,
  BuildContext context,
) {
  return Row(
    children: [
      // Rows per page dropdown
      Row(
        children: [
          _yearFilter(controller),
          appSizedBox(width: 1.w),
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

Widget _yearFilter(SelfAppraisalController controller) {
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
          controller.availableYears.map((year) {
            return DropdownMenuItem(
              value: year,
              child: Text(year, style: styleW400S13),
            );
          }).toList(),
      onChanged: (val) => controller.setYearFilter(val),
    ),
  );
}

void showRightSideViewDialog(
  BuildContext context,
  SelfTaskData task,
  SelfAppraisalController controller, {
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Column
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _infoRow("Activity", task.user!.name.toString()),
                                _infoRow(
                                  "Project",
                                  task.user!.designation.toString(),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                      _infoRow("Description", task.user!.department.toString()),
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

Widget _buildPaginationControls(SelfAppraisalController controller) {
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

class AddSelfTaskDialog extends StatefulWidget {
  @override
  _AddSelfTaskDialogState createState() => _AddSelfTaskDialogState();
}

class _AddSelfTaskDialogState extends State<AddSelfTaskDialog> {
  final SelfAppraisalController controller =
      Get.find<SelfAppraisalController>();

  @override
  void initState() {
    super.initState();
    controller.resetTaskForm();
  }

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year.toString();
    final isCurrentYear = controller.selectedYear == currentYear;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;
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

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: SizedBox(
        width: isWeb ? 800 : double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: GetBuilder<SelfAppraisalController>(
              id: 'add_dialog',
              builder: (_) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Add Activity/ Task for ${controller.selectedYear}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    if (!isCurrentYear) ...[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Activity/ Task",
                          errorText: controller.taskTitleError,
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (val) => controller.taskTitle = val,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Mid-term deliverables",
                          errorText: controller.midTermDeliverablesError,
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 3,
                        onChanged:
                            (val) => controller.midTermDeliverables = val,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Actual Achievement",
                          errorText: controller.actualAchievementError,
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 3,
                        onChanged: (val) => controller.actualAchievement = val,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 60,
                        child: InkWell(
                          onTap: () => controller.pickFile(),
                          child: InputDecorator(
                            decoration: buildInputDecoration(
                              labelText: "Upload File (Optional)",
                              suffixIcon: const Icon(Icons.attach_file),
                            ),
                            child: Text(
                              controller.selectedFileModel?.fileName ??
                                  controller.selectedFileModel?.file?.path
                                      .split('/')
                                      .last ??
                                  "No file selected",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      // Current year form
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Activity/ Task",
                          errorText: controller.taskTitleError,
                          border: OutlineInputBorder(),
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
                          border: OutlineInputBorder(),
                        ),
                        items:
                            controller.fetchedProjects.map((project) {
                              return DropdownMenuItem<String>(
                                value: project['id'].toString(),
                                child: Text(project['name']),
                              );
                            }).toList(),
                        onChanged: (val) => controller.selectedProjectId = val!,
                      ),

                      const SizedBox(height: 20),
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
                                    border: OutlineInputBorder(),
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
                              onTap:
                                  () => controller.selectDate(context, false),
                              child: AbsorbPointer(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: "Completion Date",
                                    errorText: controller.dueDateError,
                                    border: OutlineInputBorder(),
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
                      SizedBox(
                        height: 60,
                        child: InkWell(
                          onTap: () => controller.pickFile(),
                          child: InputDecorator(
                            decoration: buildInputDecoration(
                              labelText: "Upload File (Optional)",
                              suffixIcon: const Icon(Icons.attach_file),
                            ),
                            child: Text(
                              controller.selectedFileModel?.fileName ??
                                  controller.selectedFileModel?.file?.path
                                      .split('/')
                                      .last ??
                                  "No file selected",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: "Activity/ Task Description",
                          errorText: controller.taskDescriptionError,
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                        onChanged: (val) => controller.taskDescription = val,
                      ),
                    ],

                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (!isCurrentYear) {
                            print("ifff");
                            // Submit previous year task
                            controller.addSelfTask(context, '');
                          } else {
                            print("else");
                            controller.addSelfTask(
                              context,
                              controller.selectedProjectId,
                            );
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

void showAddSelfTaskModal(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Add Activity/ Task",
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
            child: AddSelfTaskDialog(),
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
