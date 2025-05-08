import 'dart:convert';

RolesModel rolesModelFromJson(String str) => RolesModel.fromJson(json.decode(str));

class RolesModel {
  String? status;
  List<RolesData>? data;

  RolesModel({this.status, this.data});

  RolesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <RolesData>[];
      json['data'].forEach((v) {
        data!.add(new RolesData.fromJson(v));
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

class RolesData {
  int? id;
  String? name;
  String? isActive;
  String? createdAt;
  String? updatedAt;

  RolesData({this.id, this.name, this.isActive, this.createdAt, this.updatedAt});

  RolesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
