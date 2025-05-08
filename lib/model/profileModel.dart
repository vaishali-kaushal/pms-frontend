import 'dart:convert';

profileModel profileModelFromJson(String str) => profileModel.fromJson(json.decode(str));

class profileModel {
  String? status;
  String? message;
  ProfileData? data;

  profileModel({this.status, this.message, this.data});

  profileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new ProfileData.fromJson(json['data']) : null;
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

class ProfileData {
  int? id;
  String? name;
  String? dob;
  String? email;
  String? mobileNumber;
  String? role;
  String? designation;
  List<String>? department;
  String? reportingOfficer;
  String? reviewingOfficer;
  List<String>? qualification;
  List<String>? skills;
  String? domain;
  String? subDomain;
  String? experience;
  List<String>? division;
  String? salary;
  String? createdBy;
  String? location;
  String? doj;
  String? employer;
  String? createdAt;
  String? resume;

  ProfileData(
      {this.id,
        this.name,
        this.dob,
        this.email,
        this.mobileNumber,
        this.role,
        this.designation,
        this.department,
        this.reportingOfficer,
        this.reviewingOfficer,
        this.qualification,
        this.skills,
        this.domain,
        this.subDomain,
        this.experience,
        this.division,
        this.salary,
        this.createdBy,
        this.location,
        this.doj,
        this.employer,
        this.createdAt,
      this.resume});

  ProfileData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    dob = json['dob'];
    email = json['email'];
    mobileNumber = json['mobile_number'];
    role = json['role'];
    designation = json['designation'];
    department = json['department'].cast<String>();
    reportingOfficer = json['reporting_officer'];
    reviewingOfficer = json['reviewing_officer'];
    qualification = json['qualification'].cast<String>();
    skills = json['skills'].cast<String>();
    domain = json['domain'];
    subDomain = json['sub_domain'];
    experience = json['experience'];
    division = json['division'].cast<String>();
    salary = json['salary'];
    createdBy = json['created_by'];
    location = json['location'];
    doj = json['doj'];
    employer = json['employer'];
    createdAt = json['created_at'];
    resume = json['resume'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['dob'] = this.dob;
    data['email'] = this.email;
    data['mobile_number'] = this.mobileNumber;
    data['role'] = this.role;
    data['designation'] = this.designation;
    data['department'] = this.department;
    data['reporting_officer'] = this.reportingOfficer;
    data['reviewing_officer'] = this.reviewingOfficer;
    data['qualification'] = this.qualification;
    data['skills'] = this.skills;
    data['domain'] = this.domain;
    data['sub_domain'] = this.subDomain;
    data['experience'] = this.experience;
    data['division'] = this.division;
    data['salary'] = this.salary;
    data['created_by'] = this.createdBy;
    data['location'] = this.location;
    data['doj'] = this.doj;
    data['employer'] = this.employer;
    data['created_at'] = this.createdAt;
    data['resume'] = this.resume;
    return data;
  }
}
