import 'dart:convert';

SaveTaskModel saveTaskModelFromJson(String str) => SaveTaskModel.fromJson(json.decode(str));

String saveTaskModelToJson(SaveTaskModel data) => json.encode(data.toJson());

class SaveTaskModel {
  String? status;
  String? message;
  SaveTaskData? data;

  SaveTaskModel({this.status, this.message, this.data});

  SaveTaskModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new SaveTaskData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class SaveTaskData {
  Selftask? selftask;

  SaveTaskData({this.selftask});

  SaveTaskData.fromJson(Map<String, dynamic> json) {
    selftask = json['selftask'] != null
        ? new Selftask.fromJson(json['selftask'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.selftask != null) {
      data['selftask'] = this.selftask!.toJson();
    }
    return data;
  }
}

class Selftask {
  int? id;
  String? projectId;
  String? taskName;
  String? startDate;
  String? endDate;
  String? taskDescription;
  String? createdBy;
  String? createdAt;

  Selftask(
      {this.id,
        this.projectId,
        this.taskName,
        this.startDate,
        this.endDate,
        this.taskDescription,
        this.createdBy,
        this.createdAt});

  Selftask.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    projectId = json['project_id'];
    taskName = json['task_name'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    taskDescription = json['task_description'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['project_id'] = this.projectId;
    data['task_name'] = this.taskName;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['task_description'] = this.taskDescription;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    return data;
  }
}
