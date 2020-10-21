// To parse this JSON data, do
//
//     final grievanceBehaviorForm = grievanceBehaviorFormFromJson(jsonString);

import 'dart:convert';

GrievanceBehaviorForm grievanceBehaviorFormFromJson(String str) => GrievanceBehaviorForm.fromJson(json.decode(str));

String grievanceBehaviorFormToJson(GrievanceBehaviorForm data) => json.encode(data.toJson());

class GrievanceBehaviorForm {
  GrievanceBehaviorForm({
    this.category,
    this.communicatedTo,
    this.academicAdvisor,
    this.coordinators,
    this.deans,
    this.faculties,
    this.staffs,
    this.incidentLocation,
  });

  List<GrievanceBehaviorCategory> category;
  List<GrievanceBehaviorCommunicatedTo> communicatedTo;
  List<GrievanceBehaviorAcademicAdvisor> academicAdvisor;
  List<GrievanceBehaviorCoordinator> coordinators;
  List<GrievanceBehaviorDean> deans;
  List<GrievanceBehaviorFaculty> faculties;
  List<GrievanceBehaviorStaff> staffs;
  List<GrievanceBehaviorIncidentLocation> incidentLocation;

  factory GrievanceBehaviorForm.fromJson(Map<String, dynamic> json) => GrievanceBehaviorForm(
        category: List<GrievanceBehaviorCategory>.from(json["Category"].map((x) => GrievanceBehaviorCategory.fromJson(x))),
        communicatedTo: List<GrievanceBehaviorCommunicatedTo>.from(json["CommunicatedTo"].map((x) => GrievanceBehaviorCommunicatedTo.fromJson(x))),
        academicAdvisor: List<GrievanceBehaviorAcademicAdvisor>.from(json["AcademicAdvisor"].map((x) => GrievanceBehaviorAcademicAdvisor.fromJson(x))),
        coordinators: List<GrievanceBehaviorCoordinator>.from(json["Coordinators"].map((x) => GrievanceBehaviorCoordinator.fromJson(x))),
        deans: List<GrievanceBehaviorDean>.from(json["Deans"].map((x) => GrievanceBehaviorDean.fromJson(x))),
        faculties: List<GrievanceBehaviorFaculty>.from(json["Faculties"].map((x) => GrievanceBehaviorFaculty.fromJson(x))),
        staffs: List<GrievanceBehaviorStaff>.from(json["Staffs"].map((x) => GrievanceBehaviorStaff.fromJson(x))),
        incidentLocation: List<GrievanceBehaviorIncidentLocation>.from(json["IncidentLocation"].map((x) => GrievanceBehaviorIncidentLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Category": List<dynamic>.from(category.map((x) => x.toJson())),
        "CommunicatedTo": List<dynamic>.from(communicatedTo.map((x) => x.toJson())),
        "AcademicAdvisor": List<dynamic>.from(academicAdvisor.map((x) => x.toJson())),
        "Coordinators": List<dynamic>.from(coordinators.map((x) => x.toJson())),
        "Deans": List<dynamic>.from(deans.map((x) => x.toJson())),
        "Faculties": List<dynamic>.from(faculties.map((x) => x.toJson())),
        "Staffs": List<dynamic>.from(staffs.map((x) => x.toJson())),
        "IncidentLocation": List<dynamic>.from(incidentLocation.map((x) => x.toJson())),
      };
}

class GrievanceBehaviorAcademicAdvisor {
  GrievanceBehaviorAcademicAdvisor({
    this.employeeId,
    this.name,
    this.advisorImage,
  });

  String employeeId;
  String name;
  String advisorImage;

  factory GrievanceBehaviorAcademicAdvisor.fromJson(Map<String, dynamic> json) => GrievanceBehaviorAcademicAdvisor(
        employeeId: json["EmployeeID"],
        name: json["Name"],
        advisorImage: json["AdvisorImage"],
      );

  Map<String, dynamic> toJson() => {
        "EmployeeID": employeeId,
        "Name": name,
        "AdvisorImage": advisorImage,
      };
}

class GrievanceBehaviorCategory {
  GrievanceBehaviorCategory({
    this.id,
    this.name,
    this.description,
  });

  int id;
  String name;
  String description;

  factory GrievanceBehaviorCategory.fromJson(Map<String, dynamic> json) => GrievanceBehaviorCategory(
        id: json["ID"],
        name: json["Name"],
        description: json["Description"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
        "Description": description,
      };
}

class GrievanceBehaviorCommunicatedTo {
  GrievanceBehaviorCommunicatedTo({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory GrievanceBehaviorCommunicatedTo.fromJson(Map<String, dynamic> json) => GrievanceBehaviorCommunicatedTo(
        id: json["ID"],
        name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
      };
}

class GrievanceBehaviorIncidentLocation {
  GrievanceBehaviorIncidentLocation({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory GrievanceBehaviorIncidentLocation.fromJson(Map<String, dynamic> json) => GrievanceBehaviorIncidentLocation(
    id: json["ID"],
    name: json["Name"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "Name": name,
  };
}

class GrievanceBehaviorCoordinator {
  GrievanceBehaviorCoordinator({
    this.employeeId,
    this.name,
  });

  String employeeId;
  String name;

  factory GrievanceBehaviorCoordinator.fromJson(Map<String, dynamic> json) => GrievanceBehaviorCoordinator(
        employeeId: json["EmployeeID"],
        name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "EmployeeID": employeeId,
        "Name": name,
      };
}

class GrievanceBehaviorStaff {
  GrievanceBehaviorStaff({
    this.employeeId,
    this.name,
  });

  String employeeId;
  String name;

  factory GrievanceBehaviorStaff.fromJson(Map<String, dynamic> json) => GrievanceBehaviorStaff(
    employeeId: json["EmployeeID"],
    name: json["Name"],
  );

  Map<String, dynamic> toJson() => {
    "EmployeeID": employeeId,
    "Name": name,
  };
}

class GrievanceBehaviorDean {
  GrievanceBehaviorDean({
    this.employeeId,
    this.name,
  });

  String employeeId;
  String name;

  factory GrievanceBehaviorDean.fromJson(Map<String, dynamic> json) => GrievanceBehaviorDean(
    employeeId: json["EmployeeID"],
    name: json["Name"],
  );

  Map<String, dynamic> toJson() => {
    "EmployeeID": employeeId,
    "Name": name,
  };
}

class GrievanceBehaviorFaculty {
  GrievanceBehaviorFaculty({
    this.employeeId,
    this.name,
  });

  String employeeId;
  String name;

  factory GrievanceBehaviorFaculty.fromJson(Map<String, dynamic> json) => GrievanceBehaviorFaculty(
    employeeId: json["EmployeeID"],
    name: json["Name"],
  );

  Map<String, dynamic> toJson() => {
    "EmployeeID": employeeId,
    "Name": name,
  };
}