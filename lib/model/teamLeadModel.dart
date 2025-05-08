import 'dart:convert';

TeamLeadModel teamLeadModelFromJson(String str) => TeamLeadModel.fromJson(json.decode(str));

class TeamLeadModel {
  String? status;
  String? message;
  List<TeamLeadData>? data;

  TeamLeadModel({this.status, this.message, this.data});

  TeamLeadModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TeamLeadData>[];
      json['data'].forEach((v) {
        data!.add(new TeamLeadData.fromJson(v));
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

class TeamLeadData {
  dynamic id;
  dynamic roleId;
  String? mobileNumber;
  String? name;
  String? email;
  String? employer;
  dynamic designation;
  dynamic department;
  String? isActive;
  dynamic createdBy;
  dynamic techStack;
  dynamic otp;
  String? createdAt;
  String? updatedAt;

  TeamLeadData(
      {this.id,
        this.roleId,
        this.mobileNumber,
        this.name,
        this.email,
        this.employer,
        this.designation,
        this.department,
        this.isActive,
        this.createdBy,
        this.techStack,
        this.otp,
        this.createdAt,
        this.updatedAt});

  TeamLeadData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleId = json['role_id'];
    mobileNumber = json['mobile_number'];
    name = json['name'];
    email = json['email'];
    employer = json['employer'];
    designation = json['designation'];
    department = json['department'];
    isActive = json['is_active'];
    createdBy = json['created_by'];
    techStack = json['tech_stack'];
    otp = json['otp'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['role_id'] = this.roleId;
    data['mobile_number'] = this.mobileNumber;
    data['name'] = this.name;
    data['email'] = this.email;
    data['employer'] = this.employer;
    data['designation'] = this.designation;
    data['department'] = this.department;
    data['is_active'] = this.isActive;
    data['created_by'] = this.createdBy;
    data['tech_stack'] = this.techStack;
    data['otp'] = this.otp;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
