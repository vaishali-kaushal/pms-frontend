import 'dart:convert';

AddProjectModel addProjectModelFromJson(String str) => AddProjectModel.fromJson(json.decode(str));

String addProjectModelToJson(AddProjectModel data) => json.encode(data.toJson());

class AddProjectModel {
  String? status;
  String? message;
  AddProjectData? data;

  AddProjectModel({this.status, this.message, this.data});

  AddProjectModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new AddProjectData.fromJson(json['data']) : null;
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

class AddProjectData {
  Project? project;

  AddProjectData({this.project});

  AddProjectData.fromJson(Map<String, dynamic> json) {
    project =
    json['project'] != null ? new Project.fromJson(json['project']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.project != null) {
      data['project'] = this.project!.toJson();
    }
    return data;
  }
}

class Project {
  int? id;
  String? name;
  String? startDate;
  String? description;
  String? createdBy;
  String? createdAt;

  Project(
      {this.id,
        this.name,
        this.startDate,
        this.description,
        this.createdBy,
        this.createdAt});

  Project.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    startDate = json['start_date'];
    description = json['description'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['start_date'] = this.startDate;
    data['description'] = this.description;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    return data;
  }
}
