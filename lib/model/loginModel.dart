import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  String? status;
  String? message;
  Data? data;

  LoginModel({this.status, this.message, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  User? user;
  String? token;

  Data({this.user, this.token});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

class User {
  dynamic id;
  String? secureId;
  String? role;
  String? name;
  String? email;
  dynamic department;
  String? employer;
  dynamic designation;
  dynamic designationId;
  String? mobileNumber;
  String? createdAt;

  User(
      {this.id,
        this.secureId,
        this.role,
        this.name,
        this.email,
        this.department,
        this.employer,
        this.designation,
        this.designationId,
        this.mobileNumber,
        this.createdAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    secureId = json['secure_id'];
    role = json['role'];
    name = json['name'];
    email = json['email'];
    department = json['department'];
    employer = json['employer'];
    designation = json['designation'];
    designationId = json['designation_id'];
    mobileNumber = json['mobile_number'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['secure_id'] = this.secureId;
    data['role'] = this.role;
    data['name'] = this.name;
    data['email'] = this.email;
    data['department'] = this.department;
    data['employer'] = this.employer;
    data['designation'] = this.designation;
    data['designation_id'] = this.designationId;
    data['mobile_number'] = this.mobileNumber;
    data['created_at'] = this.createdAt;
    return data;
  }
}
