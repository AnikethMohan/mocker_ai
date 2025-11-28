// To parse this JSON data, do
//
//     final resumeResult = resumeResultFromJson(jsonString);

import 'dart:convert';

ResumeResult resumeResultFromJson(String str) =>
    ResumeResult.fromJson(json.decode(str));

String resumeResultToJson(ResumeResult data) => json.encode(data.toJson());

class ResumeResult {
  String? name;
  ContactInfo? contactInfo;
  List<Experience>? experience;
  List<Education>? education;
  List<String>? skills;

  ResumeResult({
    this.name,
    this.contactInfo,
    this.experience,
    this.education,
    this.skills,
  });

  factory ResumeResult.fromJson(Map<String, dynamic> json) => ResumeResult(
    name: json["name"],
    contactInfo: json["contactInfo"] == null
        ? null
        : ContactInfo.fromJson(json["contactInfo"]),
    experience: json["experience"] == null
        ? []
        : List<Experience>.from(
            json["experience"]!.map((x) => Experience.fromJson(x)),
          ),
    education: json["education"] == null
        ? []
        : List<Education>.from(
            json["education"]!.map((x) => Education.fromJson(x)),
          ),
    skills: json["skills"] == null
        ? []
        : List<String>.from(json["skills"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "contactInfo": contactInfo?.toJson(),
    "experience": experience == null
        ? []
        : List<dynamic>.from(experience!.map((x) => x.toJson())),
    "education": education == null
        ? []
        : List<dynamic>.from(education!.map((x) => x.toJson())),
    "skills": skills == null ? [] : List<dynamic>.from(skills!.map((x) => x)),
  };
}

class ContactInfo {
  String? email;
  String? phone;
  String? linkedin;

  ContactInfo({this.email, this.phone, this.linkedin});

  factory ContactInfo.fromJson(Map<String, dynamic> json) => ContactInfo(
    email: json["email"],
    phone: json["phone"].toString(),
    linkedin: json["linkedin"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "phone": phone,
    "linkedin": linkedin,
  };
}

class Education {
  String? degree;
  String? university;
  String? graduationYear;

  Education({this.degree, this.university, this.graduationYear});

  factory Education.fromJson(Map<String, dynamic> json) => Education(
    degree: json["degree"],
    university: json["university"],
    graduationYear: json["graduationYear"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "degree": degree,
    "university": university,
    "graduationYear": graduationYear,
  };
}

class Experience {
  String? title;
  String? company;
  String? startDate;
  String? endDate;
  String? description;

  Experience({
    this.title,
    this.company,
    this.startDate,
    this.endDate,
    this.description,
  });

  factory Experience.fromJson(Map<String, dynamic> json) => Experience(
    title: json["title"],
    company: json["company"],
    startDate: json["startDate"],
    endDate: json["endDate"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "company": company,
    "startDate": startDate,
    "endDate": endDate,
    "description": description,
  };
}
