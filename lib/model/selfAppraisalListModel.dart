import 'dart:convert';

SelfAppraisalListModel selfAppraisalListModelFromJson(String str) => SelfAppraisalListModel.fromJson(json.decode(str));

class SelfAppraisalListModel {
  String? status;
  String? message;
  List<SelfAppraisalListData>? data;

  SelfAppraisalListModel({this.status, this.message, this.data});

  SelfAppraisalListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SelfAppraisalListData>[];
      json['data'].forEach((v) {
        data!.add(new SelfAppraisalListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SelfAppraisalListData {
  int? id;
  String? startDate;
  String? endDate;
  SelfAppraisalListUser? user;
  SelfAppraisalListSection1? section1;
  SelfAppraisalListSection2? section2;
  SelfAppraisalListSection3? section3;
  SelfAppraisalListSection4? section4;
  String? status;
  CurrentlyWith? currentlyWith;

  SelfAppraisalListData(
      {this.id,
        this.startDate,
        this.endDate,
        this.user,
        this.section1,
        this.section2,
        this.section3,
        this.section4,
        this.status,
        this.currentlyWith});

  SelfAppraisalListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    user = json['user'] != null ? new SelfAppraisalListUser.fromJson(json['user']) : null;
    section1 = json['section1'] != null
        ? new SelfAppraisalListSection1.fromJson(json['section1'])
        : null;
    section2 = json['section2'] != null
        ? new SelfAppraisalListSection2.fromJson(json['section2'])
        : null;
    section3 = json['section3'] != null
        ? new SelfAppraisalListSection3.fromJson(json['section3'])
        : null;
    section4 = json['section4'] != null
        ? new SelfAppraisalListSection4.fromJson(json['section4'])
        : null;
    status = json['status'];
    currentlyWith = json['currently_with'] != null
        ? new CurrentlyWith.fromJson(json['currently_with'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.section1 != null) {
      data['section1'] = this.section1!.toJson();
    }
    if (this.section2 != null) {
      data['section2'] = this.section2!.toJson();
    }
    if (this.section3 != null) {
      data['section3'] = this.section3!.toJson();
    }
    if (this.section4 != null) {
      data['section4'] = this.section4!.toJson();
    }
    data['status'] = this.status;
    if (this.currentlyWith != null) {
      data['currently_with'] = this.currentlyWith!.toJson();
    }
    return data;
  }
}

class SelfAppraisalListUser {
  int? id;
  String? secureId;
  String? name;
  String? role;
  String? designation;
  List<String>? department;
  int? reportingOfficerId;
  String? reportingOfficer;
  String? employer;
  String? dob;
  int? reviewingOfficerId;
  String? reviewingOfficer;
  String? doj;

  SelfAppraisalListUser(
      {this.id,
        this.secureId,
        this.name,
        this.role,
        this.designation,
        this.department,
        this.reportingOfficerId,
        this.reportingOfficer,
        this.employer,
        this.dob,
        this.reviewingOfficerId,
        this.reviewingOfficer,
        this.doj});

  SelfAppraisalListUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    secureId = json['secure_id'];
    name = json['name'];
    role = json['role'];
    designation = json['designation'];
    department = json['department'].cast<String>();
    reportingOfficerId = json['reporting_officer_id'];
    reportingOfficer = json['reporting_officer'];
    employer = json['employer'];
    dob = json['dob'];
    reviewingOfficerId = json['reviewing_officer_id'];
    reviewingOfficer = json['reviewing_officer'];
    doj = json['doj'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['secure_id'] = this.secureId;
    data['name'] = this.name;
    data['role'] = this.role;
    data['designation'] = this.designation;
    data['department'] = this.department;
    data['reporting_officer_id'] = this.reportingOfficerId;
    data['reporting_officer'] = this.reportingOfficer;
    data['employer'] = this.employer;
    data['dob'] = this.dob;
    data['reviewing_officer_id'] = this.reviewingOfficerId;
    data['reviewing_officer'] = this.reviewingOfficer;
    data['doj'] = this.doj;
    return data;
  }
}

class SelfAppraisalListSection1 {
  String? startDate;
  String? endDate;
  String? workDone;
  String? skillsUpgrade;
  String? exceptionalWork;
  String? improvementPlan;
  String? helpNeeded;
  String? professionalGoals;
  String? measureProgress;
  String? alignWithTeamGoals;

  SelfAppraisalListSection1(
      {this.startDate,
        this.endDate,
        this.workDone,
        this.skillsUpgrade,
        this.exceptionalWork,
        this.improvementPlan,
        this.helpNeeded,
        this.professionalGoals,
        this.measureProgress,
        this.alignWithTeamGoals});

  SelfAppraisalListSection1.fromJson(Map<String, dynamic> json) {
    startDate = json['start_date'];
    endDate = json['end_date'];
    workDone = json['work_done'];
    skillsUpgrade = json['skills_upgrade'];
    exceptionalWork = json['exceptional_work'];
    improvementPlan = json['improvement_plan'];
    helpNeeded = json['help_needed'];
    professionalGoals = json['professional_goals'];
    measureProgress = json['measure_progress'];
    alignWithTeamGoals = json['alignWithTeamGoals'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['work_done'] = this.workDone;
    data['skills_upgrade'] = this.skillsUpgrade;
    data['exceptional_work'] = this.exceptionalWork;
    data['improvement_plan'] = this.improvementPlan;
    data['help_needed'] = this.helpNeeded;
    data['professional_goals'] = this.professionalGoals;
    data['measure_progress'] = this.measureProgress;
    data['alignWithTeamGoals'] = this.alignWithTeamGoals;
    return data;
  }
}

class SelfAppraisalListSection2 {
  List<SelfAppraisalListMetricsData>? metricsData;

  SelfAppraisalListSection2({this.metricsData});

  SelfAppraisalListSection2.fromJson(Map<String, dynamic> json) {
    if (json['metrics_data'] != null) {
      metricsData = <SelfAppraisalListMetricsData>[];
      json['metrics_data'].forEach((v) {
        metricsData!.add(new SelfAppraisalListMetricsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.metricsData != null) {
      data['metrics_data'] = this.metricsData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SelfAppraisalListMetricsData {
  String? category;
  String? description;
  String? maximumMarks;
  String? fieldName;
  int? selfRating;
  int? reportingOfficerRating;
  int? reviewingOfficerRating;

  SelfAppraisalListMetricsData(
      {this.category,
        this.description,
        this.maximumMarks,
        this.fieldName,
        this.selfRating,
        this.reportingOfficerRating,
        this.reviewingOfficerRating});

  SelfAppraisalListMetricsData.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    description = json['description'];
    maximumMarks = json['maximumMarks'];
    fieldName = json['fieldName'];
    selfRating = json['selfRating'];
    reportingOfficerRating = json['reportingOfficerRating'];
    reviewingOfficerRating = json['reviewingOfficerRating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    data['description'] = this.description;
    data['maximumMarks'] = this.maximumMarks;
    data['fieldName'] = this.fieldName;
    data['selfRating'] = this.selfRating;
    data['reportingOfficerRating'] = this.reportingOfficerRating;
    data['reviewingOfficerRating'] = this.reviewingOfficerRating;
    return data;
  }
}

class SelfAppraisalListSection3 {
  String? strength;
  String? weaknesses;
  String? utilization;
  String? goalMeasure;
  String? goalProgressMeasure;
  String? goalStatus;
  String? upskillRecommend;

  SelfAppraisalListSection3(
      {this.strength,
        this.weaknesses,
        this.utilization,
        this.goalMeasure,
        this.goalProgressMeasure,
        this.goalStatus,
        this.upskillRecommend});

  SelfAppraisalListSection3.fromJson(Map<String, dynamic> json) {
    strength = json['strength'];
    weaknesses = json['weaknesses'];
    utilization = json['utilization'];
    goalMeasure = json['goal_measure'];
    goalProgressMeasure = json['goal_progress_measure'];
    goalStatus = json['goal_status'];
    upskillRecommend = json['upskill_recommend'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['strength'] = this.strength;
    data['weaknesses'] = this.weaknesses;
    data['utilization'] = this.utilization;
    data['goal_measure'] = this.goalMeasure;
    data['goal_progress_measure'] = this.goalProgressMeasure;
    data['goal_status'] = this.goalStatus;
    data['upskill_recommend'] = this.upskillRecommend;
    return data;
  }
}

class SelfAppraisalListSection4 {
  String? reviewAgreement;
  String? reviewDifference;
  String? reviewComments;
  String? reviewOverall;

  SelfAppraisalListSection4(
      {this.reviewAgreement,
        this.reviewDifference,
        this.reviewComments,
        this.reviewOverall});

  SelfAppraisalListSection4.fromJson(Map<String, dynamic> json) {
    reviewAgreement = json['review_agreement'];
    reviewDifference = json['review_difference'];
    reviewComments = json['review_comments'];
    reviewOverall = json['review_overall'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['review_agreement'] = this.reviewAgreement;
    data['review_difference'] = this.reviewDifference;
    data['review_comments'] = this.reviewComments;
    data['review_overall'] = this.reviewOverall;
    return data;
  }
}

class CurrentlyWith {
  String? name;
  String? designation;

  CurrentlyWith({this.name, this.designation});

  CurrentlyWith.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    designation = json['designation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['designation'] = this.designation;
    return data;
  }
}