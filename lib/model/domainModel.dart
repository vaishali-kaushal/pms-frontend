import 'dart:convert';

DomainModel domainModelFromJson(String str) => DomainModel.fromJson(json.decode(str));

class DomainModel {
  String? status;
  String? message;
  List<DomainData>? data;

  DomainModel({this.status, this.message, this.data});

  DomainModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DomainData>[];
      json['data'].forEach((v) {
        data!.add(new DomainData.fromJson(v));
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

class DomainData {
  int? id;
  String? name;
  List<SubDomains>? subDomains;

  DomainData({this.id, this.name, this.subDomains});

  DomainData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['sub_domains'] != null) {
      subDomains = <SubDomains>[];
      json['sub_domains'].forEach((v) {
        subDomains!.add(new SubDomains.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.subDomains != null) {
      data['sub_domains'] = this.subDomains!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubDomains {
  int? id;
  String? name;
  List<Skills>? skills;

  SubDomains({this.id, this.name, this.skills});

  SubDomains.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['skills'] != null) {
      skills = <Skills>[];
      json['skills'].forEach((v) {
        skills!.add(new Skills.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.skills != null) {
      data['skills'] = this.skills!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Skills {
  int? id;
  String? name;

  Skills({this.id, this.name});

  Skills.fromJson(Map<String, dynamic> json) {
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
