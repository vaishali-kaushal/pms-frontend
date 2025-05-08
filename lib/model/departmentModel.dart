import 'dart:convert';

departmentModel departmentModelFromJson(String str) => departmentModel.fromJson(json.decode(str));

class departmentModel {
  String? status;
  List<DepartmentData>? data;

  departmentModel({this.status, this.data});

  departmentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <DepartmentData>[];
      json['data'].forEach((v) {
        data!.add(new DepartmentData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DepartmentData {
  int? id;
  String? secureId;
  String? code;
  String? name;
  String? type;
  String? isActive;
  String? createdAt;
  Null? updatedAt;

  DepartmentData(
      {this.id,
        this.secureId,
        this.code,
        this.name,
        this.type,
        this.isActive,
        this.createdAt,
        this.updatedAt});

  DepartmentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    secureId = json['secure_id'];
    code = json['code'];
    name = json['name'];
    type = json['type'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['secure_id'] = this.secureId;
    data['code'] = this.code;
    data['name'] = this.name;
    data['type'] = this.type;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
