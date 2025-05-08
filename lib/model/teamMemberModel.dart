import 'dart:convert';

TeamMemberModel teamMemberModelFromJson(String str) => TeamMemberModel.fromJson(json.decode(str));

class TeamMemberModel {
  String? status;
  String? message;
  List<TeamMemberData>? data;

  TeamMemberModel({this.status, this.message, this.data});

  TeamMemberModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TeamMemberData>[];
      json['data'].forEach((v) {
        data!.add(new TeamMemberData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TeamMemberData {
  dynamic id;
  String? name;
  String? designation;

  TeamMemberData(
       {this.id,
        this.name,
       this.designation});

  TeamMemberData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    designation = json['designation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['designation'] = this.designation;
    return data;
  }
}
