import 'dart:convert';

projectDetailModel projectDetailModelFromJson(String str) => projectDetailModel.fromJson(json.decode(str));

class projectDetailModel {
  int? projectId;
  String? projectName;
  String? startDate;
  String? description;
  String? createdBy;
  String? teamLeadName;
  String? dateCompletion;
  String? departmentName;
  String? createdAt;
  String? status;
  List<ProjectMembers>? projectMembers;
  List<ProjectMilestones>? projectMilestones;

  projectDetailModel(
      {this.projectId,
        this.projectName,
        this.startDate,
        this.description,
        this.createdBy,
        this.teamLeadName,
        this.dateCompletion,
        this.departmentName,
        this.createdAt,
        this.status,
        this.projectMembers,
        this.projectMilestones});

  projectDetailModel.fromJson(Map<String, dynamic> json) {
    projectId = json['project_id'];
    projectName = json['project_name'];
    startDate = json['start_date'];
    description = json['description'];
    createdBy = json['created_by'];
    teamLeadName = json['team_lead_name'];
    dateCompletion = json['date_completion'];
    departmentName = json['department_name'];
    createdAt = json['created_at'];
    status = json['status'];
    if (json['project_members'] != null) {
      projectMembers = <ProjectMembers>[];
      json['project_members'].forEach((v) {
        projectMembers!.add(new ProjectMembers.fromJson(v));
      });
    }
    if (json['project_milestones'] != null) {
      projectMilestones = <ProjectMilestones>[];
      json['project_milestones'].forEach((v) {
        projectMilestones!.add(new ProjectMilestones.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['project_id'] = this.projectId;
    data['project_name'] = this.projectName;
    data['start_date'] = this.startDate;
    data['description'] = this.description;
    data['created_by'] = this.createdBy;
    data['team_lead_name'] = this.teamLeadName;
    data['date_completion'] = this.dateCompletion;
    data['department_name'] = this.departmentName;
    data['created_at'] = this.createdAt;
    data['status'] = this.status;
    if (this.projectMembers != null) {
      data['project_members'] =
          this.projectMembers!.map((v) => v.toJson()).toList();
    }
    if (this.projectMilestones != null) {
      data['project_milestones'] =
          this.projectMilestones!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProjectMembers {
  String? projectName;
  String? memberName;
  String? designation;

  ProjectMembers({this.projectName, this.memberName, this.designation});

  ProjectMembers.fromJson(Map<String, dynamic> json) {
    projectName = json['project_name'];
    memberName = json['member_name'];
    designation = json['designation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['project_name'] = this.projectName;
    data['member_name'] = this.memberName;
    data['designation'] = this.designation;
    return data;
  }
}

class ProjectMilestones {
  int? milestoneId;
  String? name;
  String? startDate;
  String? endDate;
  String? description;
  List<DetailTasks>? tasks;

  ProjectMilestones(
      {this.milestoneId,
        this.name,
        this.startDate,
        this.endDate,
        this.description,
        this.tasks});

  ProjectMilestones.fromJson(Map<String, dynamic> json) {
    milestoneId = json['milestone_id'];
    name = json['name'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    description = json['description'];
    if (json['tasks'] != null) {
      tasks = <DetailTasks>[];
      json['tasks'].forEach((v) {
        tasks!.add(new DetailTasks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['milestone_id'] = this.milestoneId;
    data['name'] = this.name;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['description'] = this.description;
    if (this.tasks != null) {
      data['tasks'] = this.tasks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DetailTasks {
  int? taskId;
  String? milestone;
  String? name;
  String? startDate;
  String? endDate;
  String? priority;
  String? status;
  String? assignedTo;
  String? designation;
  String? description;
  List<DetailStatusLogs>? statusLogs;

  DetailTasks(
      {this.taskId,
        this.milestone,
        this.name,
        this.startDate,
        this.endDate,
        this.priority,
        this.status,
        this.assignedTo,
        this.designation,
        this.description,
        this.statusLogs});

  DetailTasks.fromJson(Map<String, dynamic> json) {
    taskId = json['task_id'];
    milestone = json['milestone'];
    name = json['name'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    priority = json['priority'];
    status = json['status'];
    assignedTo = json['assigned_to'];
    designation = json['designation'];
    description = json['description'];
    if (json['statusLogs'] != null) {
      statusLogs = <DetailStatusLogs>[];
      json['statusLogs'].forEach((v) {
        statusLogs!.add(new DetailStatusLogs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['task_id'] = this.taskId;
    data['milestone'] = this.milestone;
    data['name'] = this.name;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['priority'] = this.priority;
    data['status'] = this.status;
    data['assigned_to'] = this.assignedTo;
    data['designation'] = this.designation;
    data['description'] = this.description;
    if (this.statusLogs != null) {
      data['statusLogs'] = this.statusLogs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DetailStatusLogs {
  String? projectName;
  String? taskName;
  String? status;
  String? statusUpdatedAt;
  String? dueDate;
  String? remarks;
  String? action_by;

  DetailStatusLogs(
      {this.projectName,
        this.taskName,
        this.status,
        this.statusUpdatedAt,
        this.dueDate,
        this.remarks,
        this.action_by});

  DetailStatusLogs.fromJson(Map<String, dynamic> json) {
    projectName = json['project_name'];
    taskName = json['task_name'];
    status = json['status'];
    statusUpdatedAt = json['status_updated_at'];
    dueDate = json['due_date'];
    remarks = json['remarks'];
    action_by = json['action_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['project_name'] = this.projectName;
    data['task_name'] = this.taskName;
    data['status'] = this.status;
    data['status_updated_at'] = this.statusUpdatedAt;
    data['due_date'] = this.dueDate;
    data['remarks'] = this.remarks;
    data['action_by'] = this.action_by;
    return data;
  }
}
