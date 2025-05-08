import 'dart:convert';

updateTaskStatusModel updateTaskStatusModelFromJson(String str) => updateTaskStatusModel.fromJson(json.decode(str));

class updateTaskStatusModel {
  String? status;
  String? message;

  updateTaskStatusModel({this.status, this.message});

  updateTaskStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}
