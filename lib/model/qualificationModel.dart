import 'dart:convert';

QualificationModel qualificationModelFromJson(String str) => QualificationModel.fromJson(json.decode(str));

class QualificationModel {
  String? status;
  List<QualificationData>? data;

  QualificationModel({this.status, this.data});

  QualificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <QualificationData>[];
      json['data'].forEach((v) {
        data!.add(new QualificationData.fromJson(v));
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

class QualificationData {
  int? id;
  String? name;
  String? type;

  QualificationData({this.id, this.name, this.type});

  QualificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    return data;
  }
}
