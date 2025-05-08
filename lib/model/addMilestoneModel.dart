import 'dart:convert';

AddMilestoneModel addMilestoneModelFromJson(String str) => AddMilestoneModel.fromJson(json.decode(str));

String addMilestoneModelToJson(AddMilestoneModel data) => json.encode(data.toJson());

class AddMilestoneModel {
  String? status;
  String? message;
  AddMilestoneData? data;

  AddMilestoneModel({this.status, this.message, this.data});

  AddMilestoneModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new AddMilestoneData.fromJson(json['data']) : null;
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

class AddMilestoneData {
  AddMilestone? milestone;

  AddMilestoneData({this.milestone});

  AddMilestoneData.fromJson(Map<String, dynamic> json) {
    milestone = json['milestone'] != null
        ? new AddMilestone.fromJson(json['milestone'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.milestone != null) {
      data['milestone'] = this.milestone!.toJson();
    }
    return data;
  }
}

class AddMilestone {
  String? name;
  String? projectName;
  String? startDate;
  String? endDate;
  String? description;
  String? createdBy;
  String? createdAt;

  AddMilestone(
      {this.name,
        this.projectName,
        this.startDate,
        this.endDate,
        this.description,
        this.createdBy,
        this.createdAt});

  AddMilestone.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    projectName = json['project_name'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    description = json['description'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['project_name'] = this.projectName;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['description'] = this.description;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    return data;
  }
}
