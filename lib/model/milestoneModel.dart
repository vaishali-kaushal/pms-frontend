import 'dart:convert';

MilestoneModel milestoneModelFromJson(String str) => MilestoneModel.fromJson(json.decode(str));

class MilestoneModel {
  String? status;
  String? message;
  dynamic count;
  List<MilestoneData>? data;

  MilestoneModel({this.status, this.message, this.count, this.data});

  MilestoneModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    count = json['count'];
    if (json['data'] != null) {
      data = <MilestoneData>[];
      json['data'].forEach((v) {
        data!.add(new MilestoneData.fromJson(v));
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

class MilestoneData {
  dynamic id;
  dynamic projectId;
  String? name;
  String? startDate;
  String? endDate;
  String? status;
  String? projectName;
  String? description;
  String? createdBy;
  String? createdAt;

  MilestoneData(
      {this.id,
        this.projectId,
        this.name,
        this.startDate,
        this.endDate,
        this.status,
        this.projectName,
        this.description,
        this.createdBy,
        this.createdAt});

  MilestoneData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    projectId = json['project_id'];
    name = json['name'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    status = json['status'];
    projectName = json['project_name'];
    description = json['description'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['project_id'] = this.projectId;
    data['name'] = this.name;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['status'] = this.status;
    data['project_name'] = this.projectName;
    data['description'] = this.description;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    return data;
  }
}
