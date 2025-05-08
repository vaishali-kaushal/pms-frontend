import 'dart:convert';

SelfTaskModel selfTasksModelFromJson(String str) => SelfTaskModel.fromJson(json.decode(str));

class SelfTaskModel {
  String? status;
  String? message;
  int? count;
  List<SelfTaskData>? data;

  SelfTaskModel({this.status, this.message, this.count, this.data});

  SelfTaskModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    count = json['count'];
    if (json['data'] != null) {
      data = <SelfTaskData>[];
      json['data'].forEach((v) {
        data!.add(new SelfTaskData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SelfTaskData {
  int? appraisalId;
  SelfTaskUser? user;
  Section1? section1;
  Section2? section2;
  Section3? section3;
  Section4? section4;

  SelfTaskData(
      {this.appraisalId,
        this.user,
        this.section1,
        this.section2,
        this.section3,
        this.section4});

  SelfTaskData.fromJson(Map<String, dynamic> json) {
    appraisalId = json['appraisal_id'];
    user = json['user'] != null ? new SelfTaskUser.fromJson(json['user']) : null;
    section1 = json['section1'] != null
        ? new Section1.fromJson(json['section1'])
        : null;
    section2 = json['section2'] != null
        ? new Section2.fromJson(json['section2'])
        : null;
    section3 = json['section3'] != null
        ? new Section3.fromJson(json['section3'])
        : null;
    section4 = json['section4'] != null
        ? new Section4.fromJson(json['section4'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appraisal_id'] = this.appraisalId;
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
    return data;
  }
}

class SelfTaskUser {
  int? id;
  String? secureId;
  String? name;
  String? role;
  String? designation;
  List<String>? department;
  String? reportingOfficer;
  String? employer;
  dynamic dob;
  String? reviewingOfficer;
  dynamic reportingOfficerId;
  dynamic reviewingOfficerId;
  dynamic doj;

  SelfTaskUser(
      {this.id,
        this.secureId,
        this.name,
        this.role,
        this.designation,
        this.department,
        this.reportingOfficer,
        this.employer,
        this.dob,
        this.reviewingOfficer,
        this.reportingOfficerId,
        this.reviewingOfficerId,
        this.doj});

  SelfTaskUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    secureId = json['secure_id'];
    name = json['name'];
    role = json['role'];
    designation = json['designation'];
    department = json['department'].cast<String>();
    reportingOfficer = json['reporting_officer'];
    employer = json['employer'];
    dob = json['dob'];
    reviewingOfficer = json['reviewing_officer'];
    reportingOfficerId = json['reporting_officer_id'];
    reviewingOfficerId = json['reviewing_officer_id'];
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
    data['reporting_officer'] = this.reportingOfficer;
    data['employer'] = this.employer;
    data['dob'] = this.dob;
    data['reviewing_officer'] = this.reviewingOfficer;
    data['reporting_officer_id'] = this.reportingOfficerId;
    data['reviewing_officer_id'] = this.reviewingOfficerId;
    data['doj'] = this.doj;
    return data;
  }
}

class Section1 {
  String? workDone;
  String? skillsUpgrade;
  String? exceptionalWork;
  String? improvementPlan;
  String? helpNeeded;
  String? professionalGoals;
  String? measureProgress;
  String? alignWithTeamGoals;

  Section1(
      {this.workDone,
        this.skillsUpgrade,
        this.exceptionalWork,
        this.improvementPlan,
        this.helpNeeded,
        this.professionalGoals,
        this.measureProgress,
        this.alignWithTeamGoals});

  Section1.fromJson(Map<String, dynamic> json) {
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

class Section2 {
  String? appraisalId;
  List<UserMetricsData>? metricsData;

  Section2({this.appraisalId, this.metricsData});

  Section2.fromJson(Map<String, dynamic> json) {
    appraisalId = json['appraisal_id'];
    if (json['metrics_data'] != null) {
      metricsData = <UserMetricsData>[];
      json['metrics_data'].forEach((v) {
        metricsData!.add(new UserMetricsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appraisal_id'] = this.appraisalId;
    if (this.metricsData != null) {
      data['metrics_data'] = this.metricsData!.map((v) => v?.toJson()).toList();
    }
    return data;
  }
}

class UserMetricsData {
  String? category;
  String? description;
  String? maximumMarks;
  String? fieldName;
  int? selfRating;
  int? reportingOfficerRating;
  int? reviewingOfficerRating;

  UserMetricsData(
      {this.category,
        this.description,
        this.maximumMarks,
        this.fieldName,
        this.selfRating,
        this.reportingOfficerRating,
        this.reviewingOfficerRating});

  UserMetricsData.fromJson(Map<String, dynamic> json) {
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

class Section3 {
  String? appraisalId;
  String? strength;
  String? weaknesses;
  String? utilization;
  String? goalMeasure;
  String? goalProgressMeasure;
  String? goalStatus;
  String? upskillRecommend;

  Section3(
      {this.appraisalId,
        this.strength,
        this.weaknesses,
        this.utilization,
        this.goalMeasure,
        this.goalProgressMeasure,
        this.goalStatus,
        this.upskillRecommend});

  Section3.fromJson(Map<String, dynamic> json) {
    appraisalId = json['appraisal_id'];
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
    data['appraisal_id'] = this.appraisalId;
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

class Section4 {
  String? reviewAgreement;
  String? reviewDifference;
  String? reviewComments;
  String? reviewOverall;

  Section4(
      {this.reviewAgreement,
        this.reviewDifference,
        this.reviewComments,
        this.reviewOverall});

  Section4.fromJson(Map<String, dynamic> json) {
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