import 'dart:convert';

TasksModel tasksModelFromJson(String str) => TasksModel.fromJson(json.decode(str));

class TasksModel {
  String? status;
  String? message;
  List<TaskData>? data;
  int? count;

  TasksModel({this.status, this.message, this.data, this.count});

  TasksModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TaskData>[];
      json['data'].forEach((v) {
        data!.add(new TaskData.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    return data;
  }
}

class TaskData {
  int? id;
  String? name;
  String? projectName;
  int? projectId;
  String? milestoneName;
  String? startDate;
  String? endDate;
  String? assignedTo;
  String? designation;
  String? description;
  String? priority;
  String? status;
  String? createdAt;
  List<StatusLogs>? statusLogs;

  TaskData(
      {this.id,
        this.name,
        this.projectName,
        this.projectId,
        this.milestoneName,
        this.startDate,
        this.endDate,
        this.assignedTo,
        this.designation,
        this.description,
        this.priority,
        this.status,
        this.createdAt,
        this.statusLogs});

  TaskData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    projectName = json['project_name'];
    projectId = json['project_id'];
    milestoneName = json['milestone_name'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    assignedTo = json['assigned_to'];
    designation = json['designation'];
    description = json['description'];
    priority = json['priority'];
    status = json['status'];
    createdAt = json['created_at'];
    if (json['status_logs'] != null) {
      statusLogs = <StatusLogs>[];
      json['status_logs'].forEach((v) {
        statusLogs!.add(new StatusLogs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['project_name'] = this.projectName;
    data['project_id'] = this.projectId;
    data['milestone_name'] = this.milestoneName;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['assigned_to'] = this.assignedTo;
    data['designation'] = this.designation;
    data['description'] = this.description;
    data['priority'] = this.priority;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    if (this.statusLogs != null) {
      data['status_logs'] = this.statusLogs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StatusLogs {
  String? projectName;
  String? taskName;
  String? status;
  String? statusUpdatedAt;
  String? dueDate;
  String? remarks;
  String? action_by;

  StatusLogs(
      {this.projectName,
        this.taskName,
        this.status,
        this.statusUpdatedAt,
        this.dueDate,
        this.remarks,
        this.action_by});

  StatusLogs.fromJson(Map<String, dynamic> json) {
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
