import 'dart:convert';

DivisionModel divisionModelFromJson(String str) => DivisionModel.fromJson(json.decode(str));

class DivisionModel {
  String? status;
  List<DivisionData>? data;

  DivisionModel({this.status, this.data});

  DivisionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <DivisionData>[];
      json['data'].forEach((v) {
        data!.add(new DivisionData.fromJson(v));
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

class DivisionData {
  int? id;
  String? name;
  String? isActive;
  String? createdAt;
  String? updatedAt;

  DivisionData({this.id, this.name, this.isActive, this.createdAt, this.updatedAt});

  DivisionData.fromJson(Map<String, dynamic> json) {
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
