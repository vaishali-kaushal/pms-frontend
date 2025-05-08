import 'dart:convert';

UserRolesModel userRolesModelFromJson(String str) => UserRolesModel.fromJson(json.decode(str));

class UserRolesModel {
  String? status;
  String? message;
  int? count;
  List<UserRolesData>? data;

  UserRolesModel({this.status, this.message, this.count, this.data});

  UserRolesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    count = json['count'];
    if (json['data'] != null) {
      data = <UserRolesData>[];
      json['data'].forEach((v) {
        data!.add(new UserRolesData.fromJson(v));
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

class UserRolesData {
  int? id;
  String? secureId;
  String? name;
  String? role;
  String? mobileNumber;
  String? designation;
  List<String>? department;
  String? employer;
  String? createdAt;
  List<String>? skills;
  String? domain;
  String? subDomain;

  UserRolesData(
      {this.id,
        this.secureId,
        this.name,
        this.role,
        this.mobileNumber,
        this.designation,
        this.department,
        this.employer,
        this.createdAt,
        this.skills,
        this.domain,
        this.subDomain});

  UserRolesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    secureId = json['secure_id'];
    name = json['name'];
    role = json['role'];
    mobileNumber = json['mobile_number'];
    designation = json['designation'];
    department = json['department'].cast<String>();
    employer = json['employer'];
    createdAt = json['created_at'];
    if (json['skills'] != null) {
      skills = json['skills'].cast<String>();
    }
    domain = json['domain'];
    subDomain = json['sub_domain'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['secure_id'] = this.secureId;
    data['name'] = this.name;
    data['role'] = this.role;
    data['mobile_number'] = this.mobileNumber;
    data['designation'] = this.designation;
    data['department'] = this.department;
    data['employer'] = this.employer;
    data['created_at'] = this.createdAt;
    if (this.skills != null) {
      data['skills'] = this.skills;
    }
    data['domain'] = this.domain;
    data['sub_domain'] = this.subDomain;
    return data;
  }
}
