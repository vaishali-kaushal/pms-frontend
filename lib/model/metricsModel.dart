import 'dart:convert';

MetricsModel metricsModelFromJson(String str) => MetricsModel.fromJson(json.decode(str));

class MetricsModel {
  String? status;
  List<MetricsData>? data;

  MetricsModel({this.status, this.data});

  MetricsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <MetricsData>[];
      json['data'].forEach((v) {
        data!.add(new MetricsData.fromJson(v));
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

class MetricsData {
  String? category;
  String? description;
  String? maximumMarks;
  dynamic selfRating;
  int? reportingOfficerRating;
  int? reviewingOfficerRating;
  String? fieldName;

  MetricsData({this.category, this.description, this.maximumMarks, this.fieldName});

  MetricsData.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    description = json['description'];
    maximumMarks = json['maximumMarks'];
    selfRating = json['selfRating'];
    fieldName = json['fieldName'];
    reportingOfficerRating = json['reportingOfficerRating'];
    reviewingOfficerRating = json['reviewingOfficerRating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    data['description'] = this.description;
    data['maximumMarks'] = this.maximumMarks;
    data['selfRating'] = this.selfRating;
    data['fieldName'] = this.fieldName;
    data['reportingOfficerRating'] = this.reportingOfficerRating;
    data['reviewingOfficerRating'] = this.reviewingOfficerRating;
    return data;
  }
}
