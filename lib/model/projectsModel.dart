import 'dart:convert';

ProjectsModel projectsModelFromJson(String str) => ProjectsModel.fromJson(json.decode(str));

class ProjectsModel {
  String? status;
  String? message;
  dynamic count;
  List<ProjectsData>? data;

  ProjectsModel({this.status, this.message, this.count, this.data});

  ProjectsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    count = json['count'];
    if (json['data'] != null) {
      data = <ProjectsData>[];
      json['data'].forEach((v) {
        data!.add(new ProjectsData.fromJson(v));
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

class ProjectsData {
  dynamic id;
  String? name;
  String? startDate;
  String? description;
  String? createdBy;
  String? teamLeadName;
  String? dateCompletion;
  String? departmentName;
  String? createdAt;
  dynamic taskCount;
  dynamic milestoneCount;
  dynamic status;

  ProjectsData(
      {this.id,
        this.name,
        this.startDate,
        this.description,
        this.createdBy,
        this.teamLeadName,
        this.dateCompletion,
        this.departmentName,
        this.createdAt,
        this.taskCount,
        this.milestoneCount,
        this.status});

  ProjectsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    startDate = json['start_date'];
    description = json['description'];
    createdBy = json['created_by'];
    teamLeadName = json['team_lead_name'];
    dateCompletion = json['date_completion'];
    departmentName = json['department_name'];
    createdAt = json['created_at'];
    taskCount = json['task_count'];
    milestoneCount = json['milestone_count'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['start_date'] = this.startDate;
    data['description'] = this.description;
    data['created_by'] = this.createdBy;
    data['team_lead_name'] = this.teamLeadName;
    data['date_completion'] = this.dateCompletion;
    data['department_name'] = this.departmentName;
    data['created_at'] = this.createdAt;
    data['task_count'] = this.taskCount;
    data['milestone_count'] = this.milestoneCount;
    data['status'] = this.status;
    return data;
  }
}

