import 'dart:convert';

UsersListModel usersListModelModelFromJson(String str) => UsersListModel.fromJson(json.decode(str));

class UsersListModel {
  String? status;
  String? message;
  int? count;
  List<UsersData>? data;

  UsersListModel({this.status, this.message, this.count, this.data});

  UsersListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    count = json['count'];
    if (json['data'] != null) {
      data = <UsersData>[];
      json['data'].forEach((v) {
        data!.add(new UsersData.fromJson(v));
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

class UsersData {
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

  UsersData(
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

  UsersData.fromJson(Map<String, dynamic> json) {
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