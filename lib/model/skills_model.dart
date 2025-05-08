import 'dart:convert';

SkillsModel skillsModelFromJson(String str) => SkillsModel.fromJson(json.decode(str));

class SkillsModel {
  String? status;
  List<SkillsData>? data;

  SkillsModel({this.status, this.data});

  SkillsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <SkillsData>[];
      json['data'].forEach((v) {
        data!.add(new SkillsData.fromJson(v));
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

class SkillsData {
  int? parentSkillId;
  String? parentSkillName;
  List<SubSkill>? subSkill;

  SkillsData({this.parentSkillId, this.parentSkillName, this.subSkill});

  SkillsData.fromJson(Map<String, dynamic> json) {
    parentSkillId = json['parent_skill_id'];
    parentSkillName = json['parent_skill_name'];
    if (json['sub_skill'] != null) {
      subSkill = <SubSkill>[];
      json['sub_skill'].forEach((v) {
        subSkill!.add(new SubSkill.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['skill_id'] = this.parentSkillId;
    data['skill_name'] = this.parentSkillName;
    if (this.subSkill != null) {
      data['sub_skill'] = this.subSkill!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubSkill {
  int? id;
  String? name;

  SubSkill({this.id, this.name});

  SubSkill.fromJson(Map<String, dynamic> json) {
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
