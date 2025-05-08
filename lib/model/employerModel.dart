import 'dart:convert';

EmployerModel employerModelFromJson(String str) => EmployerModel.fromJson(json.decode(str));

class EmployerModel {
  String? status;
  List<EmployerData>? data;

  EmployerModel({this.status, this.data});

  EmployerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <EmployerData>[];
      json['data'].forEach((v) {
        data!.add(new EmployerData.fromJson(v));
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

class EmployerData {
  int? id;
  String? name;

  EmployerData({this.id, this.name});

  EmployerData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
