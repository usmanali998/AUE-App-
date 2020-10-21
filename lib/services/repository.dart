import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';
import 'package:aue/model/add_letter_request_model.dart';
import 'package:aue/model/announcement.dart';
import 'package:aue/model/announcement_details.dart';
import 'package:aue/model/announcements.dart';
import 'package:aue/model/applicable_grant_model.dart';
import 'package:aue/model/apply_academic_grievance.dart';
import 'package:aue/model/apply_course_withdrawal.dart';
import 'package:aue/model/apply_grant_semester_company.dart';
import 'package:aue/model/assignment.dart';
import 'package:aue/model/attendance_excuse.dart';
import 'package:aue/model/attendance_summary.dart';
import 'package:aue/model/class_announcement.dart';
import 'package:aue/model/class_update.dart';
import 'package:aue/model/class_discussion_model.dart';
import 'package:aue/model/core_courses.dart';
import 'package:aue/model/course.dart';
import 'package:aue/model/course_categories.dart';
import 'package:aue/model/course_marks_model.dart';
import 'package:aue/model/course_material.dart';
import 'package:aue/model/course_outline_model.dart';
import 'package:aue/model/course_timings.dart';
import 'package:aue/model/course_withdrawal_data.dart';
import 'package:aue/model/course_withdrawal_reason.dart';
import 'package:aue/model/current_semester.dart';
import 'package:aue/model/discussion_reply_model.dart';
import 'package:aue/model/ebooks_model.dart';
import 'package:aue/model/elective_colleges.dart';
import 'package:aue/model/event.dart';
import 'package:aue/model/excusable_attendance.dart';
import 'package:aue/model/excuse_categories.dart';
import 'package:aue/model/grant_details_model.dart';
import 'package:aue/model/grant_details_semester.dart';
import 'package:aue/model/grant_details_semester_alumni.dart';
import 'package:aue/model/grant_details_semester_company.dart';
import 'package:aue/model/grant_history_model.dart';
import 'package:aue/model/grievance_academic_form.dart';
import 'package:aue/model/grievance_behavior_form.dart';
import 'package:aue/model/grievance_history.dart';
import 'package:aue/model/grievance_terms_and_conditions.dart';
import 'package:aue/model/letter_request.dart';
import 'package:aue/model/letter_type.dart';
import 'package:aue/model/notification_model.dart';
import 'package:aue/model/offered_elective_courses.dart';
import 'package:aue/model/rubric_criteria.dart';
import 'package:aue/model/rubric_descriptor.dart';
import 'package:aue/model/rubric_measurement.dart';
import 'package:aue/model/paymentToPay.dart';
import 'package:aue/model/sections.dart';
import 'package:aue/model/semester.dart';
import 'package:aue/model/semester_details.dart';
import 'package:aue/model/sent_otp_model.dart';
import 'package:aue/model/single_section.dart';
import 'package:aue/model/student_grades.dart';
import 'package:aue/model/student_profile_model.dart';
import 'package:aue/model/student_rubric.dart';
import 'package:aue/model/student_schedule.dart';
import 'package:aue/model/study_plan.dart';
import 'package:aue/model/terms_condition.dart';
import 'package:aue/model/time_line.dart';
import 'package:aue/model/user.dart';
import 'package:aue/model/video_tutorial.dart';
import 'package:aue/model/whatsapp_contact_model.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../res/utils.dart';

class Repository {
  Dio dio;

  Repository() {
    BaseOptions options = BaseOptions(
        baseUrl: "http://integrations.aue.ae/stdsvc/Student/",
        headers: {"Authorization": "Basic bW9iaWxldXNlcjpBdWVkZXYyMDIw"},
        responseType: ResponseType.json,
        connectTimeout: 30000,
        sendTimeout: 30000,
        receiveTimeout: 30000,
        receiveDataWhenStatusError: false);
    dio = Dio(options);
    dio.interceptors.add(
      DioCacheManager(
        CacheConfig(baseUrl: "http://integrations.aue.ae/stdsvc/Student/"),
      ).interceptor,
    );
  }

  static Future<String> sendOTP(
      String studentId, String phoneNumber, int numOfDigits) async {
    final String url =
        "https://integrations.aue.ae/stdsvc/Student/SendOTP?StudentID=$studentId&PhoneNumber=$phoneNumber&NumOfDigits=$numOfDigits";

    try {
      String username = 'mobileuser';
      String password = 'Auedev2020';
      String basicAuth =
          'Basic ' + convert.base64Encode(utf8.encode('$username:$password'));
      print(basicAuth);

      Map<String, String> headers = {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': basicAuth
      };

      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        print("Response: " + response.body);
        return response.body;
      } else {
        return null;
      }
    } catch (error) {
      print(error);
      return null;
    }
  }

  static Future<User> getStudentInformation(String studentId) async {
    final String url =
        "https://integrations.aue.ae/stdsvc/Student/Search?StudentID=$studentId";

    try {
      String username = 'mobileuser';
      String password = 'Auedev2020';
      String basicAuth =
          'Basic ' + convert.base64Encode(utf8.encode('$username:$password'));
      print(basicAuth);

      Map<String, String> headers = {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': basicAuth
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        print(json.decode(response.body));
        var jsonResponse = convert.jsonDecode(response.body);
        var user = User.fromJson(jsonResponse);
        print("User: $user");
        return user;
      } else {
        return null;
      }
    } catch (error) {
      print(error);
      return null;
    }
  }

//<<<<<<< HEAD
  static Future<StudentProfile> getStudentProfile(String studentId) async {
    final String url =
        "https://integrations.aue.ae/stdsvc/Student/GetProfile?StudentID=$studentId";
//=======
//  static Future<String> sendOTP(
//      String studentId, String phoneNumber, int numOfDigits) async {
//    final String url =
//        "https://integrations.aue.ae/stdsvc/Student/SendOTP?StudentID=$studentId&PhoneNumber=$phoneNumber&NumOfDigits=$numOfDigits";
//>>>>>>> a26cb10c327e0b9fe51e9eacad8968c183335499

    try {
      String username = 'mobileuser';
      String password = 'Auedev2020';
      String basicAuth =
          'Basic ' + convert.base64Encode(utf8.encode('$username:$password'));
      print(basicAuth);

      Map<String, String> headers = {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': basicAuth
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        print(studentProfileFromJson(response.body).first.toJson());
        return studentProfileFromJson(response.body).first;
      } else {
        return null;
      }
    } catch (error) {
      print(error);
      return null;
    }
  }

  // static Future<Announcements> getAnnouncements(String studentId) async {
  //   final String url =
  //       "https://integrations.aue.ae/stdsvc/Student/GetAnnouncements?StudentID=$studentId";
  //
  //   try {
  //     String username = 'mobileuser';
  //     String password = 'Auedev2020';
  //     String basicAuth =
  //         'Basic ' + convert.base64Encode(utf8.encode('$username:$password'));
  //     print(basicAuth);
  //
  //     Map<String, String> headers = {
  //       'content-type': 'application/json',
  //       'accept': 'application/json',
  //       'authorization': basicAuth
  //     };
  //
  //     final response = await http.get(url, headers: headers);
  //
  //     if (response.statusCode == 200) {
  //       print('Status 200');
  //       final Announcements announcements =
  //           announcementsFromJson(response.body);
  //       return announcements;
  //     } else {
  //       print('Status is not 200');
  //       return null;
  //     }
  //   } catch (error) {
  //     print('Error');
  //     print(error);
  //     return null;
  //   }
  // }

  Future<Announcements> getAnnouncements(String studentId) async {
    final parameters = {"StudentID": studentId};

    try {
      final result = await dio.get(
        "GetAnnouncements",
        queryParameters: parameters,
        options: buildCacheOptions(
          const Duration(days: 7),
          forceRefresh: true,
        ),
      );

      // print(result.data);
      final announcements =
          announcementsFromJson(convert.jsonEncode(result.data));
      return announcements;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<List<GrievanceHistory>> getGrievanceHistoryList(
      String studentId) async {
    final parameters = {"StudentID": studentId};

    try {
      final result = await dio.get(
        "GetGrievanceHistory",
        queryParameters: parameters,
        options: buildCacheOptions(const Duration(days: 7),
            forceRefresh: true,
            options: Options(receiveDataWhenStatusError: true)),
      );

      // print(result.data);
      final grievanceHistoryList =
          grievanceHistoryFromJson(convert.jsonEncode(result.data));
      return grievanceHistoryList;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<List<GrievanceTermsAndConditions>> getGrievanceTermsAndConditions(
      String studentId, int functionalityId, int language) async {
    final parameters = {
      "StudentID": studentId,
      'FunctionalityID': functionalityId,
      'Language': language
    };

    try {
      final result = await dio.get(
        "GetTermsAndConditions",
        queryParameters: parameters,
        options: buildCacheOptions(
          const Duration(days: 7),
          forceRefresh: true,
          options: Options(
            receiveDataWhenStatusError: true,
          ),
        ),
      );

      // print(result.data);
      final grievanceTermsAndConditions =
          grievanceTermsAndConditionsFromJson(convert.jsonEncode(result.data));
      return grievanceTermsAndConditions;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<GrievanceAcademicForm> getGrievanceAcademicForm(
      String studentId) async {
    final parameters = {
      "StudentID": studentId,
    };

    try {
      final result = await dio.get(
        "GetAcademicGrievanceForm",
        queryParameters: parameters,
        options: buildCacheOptions(
          const Duration(days: 7),
          forceRefresh: true,
          options: Options(receiveDataWhenStatusError: true),
        ),
      );

      // print(result.data);
      final grievanceAcademicForm =
          grievanceAcademicFormFromJson(convert.jsonEncode(result.data));
      return grievanceAcademicForm;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<GrievanceBehaviorForm> getGrievanceBehaviorForm(
      String studentId) async {
    final parameters = {
      "StudentID": studentId,
    };

    try {
      final result = await dio.get(
        "GetBehaviorGrievanceForm",
        queryParameters: parameters,
        options: buildCacheOptions(
          const Duration(days: 7),
          forceRefresh: true,
          options: Options(receiveDataWhenStatusError: true),
        ),
      );

      // print(result.data);
      final grievanceBehaviorForm =
          grievanceBehaviorFormFromJson(convert.jsonEncode(result.data));
      return grievanceBehaviorForm;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<List<LetterRequest>> getLetterRequests(String studentId) async {
    final parameters = {"StudentID": studentId};

    try {
      final result = await dio.get(
        "GetLetterRequests",
        queryParameters: parameters,
        options: buildCacheOptions(const Duration(days: 7),
            forceRefresh: true,
            options: Options(receiveDataWhenStatusError: true)),
      );

      // print(result.data);
      final letterRequests =
          letterRequestFromJson(convert.jsonEncode(result.data));
      return letterRequests;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<List<LetterType>> getLetterTypes(String studentId) async {
    final parameters = {"StudentID": studentId};

    try {
      final result = await dio.get(
        "GetLetterTypes",
        queryParameters: parameters,
        options: buildCacheOptions(const Duration(days: 7),
            forceRefresh: true,
            options: Options(receiveDataWhenStatusError: true)),
      );

      // print(result.data);
      final letterTypes = letterTypeFromJson(convert.jsonEncode(result.data));
      return letterTypes;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<String> postLetterRequest(AddLetterRequestModel model) async {
    try {
      final result = await dio.post(
        'AddLetterRequest',
        data: addLetterRequestModelToJson(model),
        options: Options(
          receiveDataWhenStatusError: true,
        ),
      );
      if (result.statusCode == 200) {
        return result.data;
      } else {
        return null;
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<AttendanceExcuse>> getAttendanceExcuseHistory(
      String studentId) async {
    final parameters = {"StudentID": studentId};

    try {
      final result = await dio.get(
        "GetExcuseRequests",
        queryParameters: parameters,
        options: buildCacheOptions(
          const Duration(days: 7),
          forceRefresh: true,
          options: Options(
            receiveDataWhenStatusError: true,
          ),
        ),
      );

      // print(result.data);
      final attendanceExcuseHistory =
          attendanceExcuseFromJson(convert.jsonEncode(result.data));
      return attendanceExcuseHistory;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<List<ExcusableAttendance>> getExcusableAttendance(
      String studentId, String startDate, String endDate) async {
    final parameters = {
      "StudentID": studentId,
      'DateFrom': startDate,
      'DateTo': endDate,
    };

    try {
      final result = await dio.get(
        "GetExcusableAttendance",
        queryParameters: parameters,
        options: buildCacheOptions(
          const Duration(days: 7),
          forceRefresh: true,
          options: Options(
            receiveDataWhenStatusError: true,
          ),
        ),
      );

      // print(result.data);
      final excusableAttendance =
          excusableAttendanceFromJson(convert.jsonEncode(result.data));
      return excusableAttendance;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<List<ExcuseCategory>> getExcuseCategories(String studentId) async {
    final parameters = {"StudentID": studentId};

    try {
      final result = await dio.get(
        "GetExcuseCategories",
        queryParameters: parameters,
        options: buildCacheOptions(
          const Duration(days: 7),
          forceRefresh: true,
          options: Options(
            receiveDataWhenStatusError: true,
          ),
        ),
      );

      // print(result.data);
      final excuseCategories =
          excuseCategoryFromJson(convert.jsonEncode(result.data));
      return excuseCategories;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<List<NotificationModel>> getNotifications(String studentId) async {
    final parameters = {"StudentID": studentId};

    try {
      final result = await dio.get(
        "GetNotifications",
        queryParameters: parameters,
        options: buildCacheOptions(
          const Duration(days: 7),
          forceRefresh: true,
          options: Options(
            receiveDataWhenStatusError: true,
          ),
        ),
      );

      // print(result.data);
      final notifications =
          notificationFromJson(convert.jsonEncode(result.data));
      return notifications;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<List<VideoTutorial>> getVideoTutorials(String studentId) async {
    final parameters = {
      "StudentID": studentId,
    };

    try {
      final result = await dio.get(
        "GetVideoTutorials",
        queryParameters: parameters,
        options: buildCacheOptions(
          const Duration(days: 7),
          forceRefresh: true,
          options: Options(
            receiveDataWhenStatusError: true,
          ),
        ),
      );

      // print(result.data);
      final videoTutorials =
          videoTutorialFromJson(convert.jsonEncode(result.data));
      return videoTutorials;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<StudentRubric> getStudentRubric(
      String studentId, int courseWorkId, int rubricId) async {
    final parameters = {
      "StudentID": studentId ?? '161410013',
      'CourseWorkID': courseWorkId ?? 100538,
      'RubricID': rubricId ?? 7471,
    };

    try {
      final result = await dio.get(
        "GetStudentRubric",
        queryParameters: parameters,
        options: buildCacheOptions(
          const Duration(days: 7),
          forceRefresh: true,
          options: Options(
            receiveDataWhenStatusError: true,
          ),
        ),
      );

      // print(result.data);
      final studentRubric =
          studentRubricFromJson(convert.jsonEncode(result.data));
      return studentRubric;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  static Future<AnnouncementDetails> getAnnouncementDetails(
      int year, int id) async {
    final String url =
        "https://integrations.aue.ae/stdsvc/Student/GetAnnouncementDetails?Year=$year&ID=$id";

    try {
      String username = 'mobileuser';
      String password = 'Auedev2020';
      String basicAuth =
          'Basic ' + convert.base64Encode(utf8.encode('$username:$password'));
      print(basicAuth);

      Map<String, String> headers = {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': basicAuth
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        print('Status 200');
        return announcementDetailsFromJson(response.body);
      } else {
        print('Status null');
        return null;
      }
    } catch (error) {
      print('Error');
      print(error);
      return null;
    }
  }

  static Future<List<Semester>> getSemesters(
      String studentId, int language) async {
    final String url =
        "https://integrations.aue.ae/stdsvc/Student/GetSemesters?StudentID=$studentId&Language=$language";

    try {
      String username = 'mobileuser';
      String password = 'Auedev2020';
      String basicAuth =
          'Basic ' + convert.base64Encode(utf8.encode('$username:$password'));
      print(basicAuth);

      Map<String, String> headers = {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': basicAuth
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        print('Status 200');
        final List<Semester> semesters = semesterFromJson(response.body);
        return semesters;
      } else {
        print('Status null');
        return null;
      }
    } catch (error) {
      print('Error');
      print(error);
      return null;
    }
  }

  static Future<List<SemesterDetails>> getSemesterDetails(
      String studentId, int semesterId) async {
    final String url =
        "https://integrations.aue.ae/stdsvc/Student/GetSemesterDetails?StudentID=$studentId&SemesterID=$semesterId";

    try {
      String username = 'mobileuser';
      String password = 'Auedev2020';
      String basicAuth =
          'Basic ' + convert.base64Encode(utf8.encode('$username:$password'));
      print(basicAuth);

      Map<String, String> headers = {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': basicAuth
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        print('Status 200');
        final List<SemesterDetails> semesterDetails =
            semesterDetailsFromJson(response.body);
        return semesterDetails;
      } else {
        print('Status null');
        return null;
      }
    } catch (error) {
      print('Error');
      print(error);
      return null;
    }
  }

  static Future<SentOtpModel> getSentOTPForVerification(
      String studentId) async {
    final String url =
        "https://integrations.aue.ae/stdsvc/Student/GetSentOTPForVerification?StudentID=$studentId";

    try {
      String username = 'mobileuser';
      String password = 'Auedev2020';
      String basicAuth =
          'Basic ' + convert.base64Encode(utf8.encode('$username:$password'));
      print(basicAuth);

      Map<String, String> headers = {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': basicAuth
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        print("Response: " + response.body);
        final SentOtpModel sentOtpModel = sentOtpModelFromJson(response.body);
        return sentOtpModel;
      } else {
        Get.snackbar('API Error', response.body);
        return null;
      }
    } catch (error) {
      print('in catch');
      print(error);
      return null;
    }
  }

  static Future<String> updateSentOTPStatus(
      String studentId, String sentOTP, bool isVerified) async {
    final String url =
        "https://integrations.aue.ae/stdsvc/Student/UpdateSentOTPStatus?StudentID=$studentId&SentOTP=$sentOTP&IsVerified=$isVerified";

    try {
      String username = 'mobileuser';
      String password = 'Auedev2020';
      String basicAuth =
          'Basic ' + convert.base64Encode(utf8.encode('$username:$password'));
      print(basicAuth);

      Map<String, String> headers = {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': basicAuth
      };

      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        print("Response: " + response.body);
        return response.body;
      } else {
        return null;
      }
    } catch (error) {
      print(error);
      return null;
    }
  }

  static Future<String> changeStudentPassword(
      String studentId, String newPassword) async {
    final String url =
        "https://integrations.aue.ae/stdsvc/Student/ChangeStudentPassword?StudentID=$studentId&NewPassword=$newPassword";
    try {
      String username = 'mobileuser';
      String password = 'Auedev2020';
      String basicAuth =
          'Basic ' + convert.base64Encode(utf8.encode('$username:$password'));
      print(basicAuth);

      Map<String, String> headers = {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': basicAuth
      };

      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        print("Response: " + response.body);
        return response.body;
      } else {
        return null;
      }
    } catch (error) {
      print(error);
      return null;
    }
  }

//<<<<<<< HEAD

  static Future<String> changePhoneNumber(
      String studentId, String newPhoneNumber) async {
    String url =
        'https://integrations.aue.ae/stdsvc/Student/ChangeStudentPhoneNumber?StudentID=$studentId&NewPhoneNumber=$newPhoneNumber';

    try {
      String username = 'mobileuser';
      String password = 'Auedev2020';
      String basicAuth =
          'Basic ' + convert.base64Encode(utf8.encode('$username:$password'));
      print(basicAuth);

      Map<String, String> headers = {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': basicAuth
      };

      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        print("Response: " + response.body);
        return response.body;
      } else {
        return null;
      }
    } catch (error) {
      print(error);
      return null;
    }
  }

  static Future<List<CourseCategories>> getCourseCategories(
      {var studentId}) async {
    var url =
        "https://integrations.aue.ae/stdsvc/Student/GetCourseCategories?StudentID=$studentId";
//=======
//  static Future<List<CourseCategories>> getCourseCategories(
//      {var studentId}) async {
//    var url =
//        "https://integrations.aue.ae/stdsvc/Student/GetCourseCategories?StudentID=$studentId";
//>>>>>>> a26cb10c327e0b9fe51e9eacad8968c183335499

    try {
      // var response = await http.get(url);
      String username = 'mobileuser';
      String password = 'Auedev2020';
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      print(basicAuth);

      Map<String, String> headers = {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': basicAuth
      };

      // Map<String, String> headers = {"Accept": "text/html,application/xml"};
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        var jsonResponse = convert.jsonDecode(response.body);
        var categories = CourseCategoryList.fromJson(jsonResponse);
        print("Cities Count: ${categories.courseCategoryList.length}");
        return categories.courseCategoryList;
      } else {
        return [];
      }
    } catch (error) {
      print(error);
      return [];
    }
  }

  static Future<List<ClassUpdate>> getClassUpdates(String studentId) async {
    var url =
        "https://integrations.aue.ae/stdsvc/Student/GetClassUpdates?StudentID=$studentId";

    try {
      // var response = await http.get(url);
      String username = 'mobileuser';
      String password = 'Auedev2020';
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      print(basicAuth);

      Map<String, String> headers = {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': basicAuth
      };

      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        List<ClassUpdate> classUpdates = classUpdatesFromJson(response.body);
        return classUpdates;
      } else {
        return [];
      }
    } catch (error) {
      print(error);
      return [];
    }
  }

  static Future<List<CoreCoursesObj>> getCoreCourese(
      {var studentId, var categoryId}) async {
    var url =
        "https://integrations.aue.ae/stdsvc/Student/GetOfferedCourses?StudentID=$studentId&SemesterID=70&CourseCategoryID=$categoryId";

    try {
      // var response = await http.get(url);
      String username = 'mobileuser';
      String password = 'Auedev2020';
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      print(basicAuth);

      Map<String, String> headers = {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': basicAuth
      };

      // Map<String, String> headers = {"Accept": "text/html,application/xml"};
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        var jsonResponse = convert.jsonDecode(response.body);
        var coreCourses = CoreCoursesList.fromJson(jsonResponse);
        print("Cities Count: ${coreCourses.coreCoursesList.length}");
        return coreCourses.coreCoursesList;
      } else {
        return [];
      }
    } catch (error) {
      print(error);
      return [];
    }
  }

  //save Selected Courses

  static Future<bool> saveSelectedCourses() async {
    var url =
        "https://integrations.aue.ae/stdsvc/Student/SaveCourseRegistration";

    String username = 'mobileuser';
    String password = 'Auedev2020';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    print(basicAuth);

    Map<String, String> headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
      'authorization': basicAuth
    };
    // Map<String, dynamic> body = {
    //   "StudentID": 171210050,
    //   "SemesterID": 70,
    //   "SectionIDs": [1, 2, 3],
    // };

    try {
      var response = await http.post(url, headers: headers);
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        // var data = UpdatePassword.fromJson(jsonResponse);
        print("This is response message ${jsonResponse}");

        if (jsonResponse == "Your course registration has been saved.") {
          print("user data save Successfully");
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  //get student payment to payment

  static Future<List<PaymentToPay>> getPaymentToPay({String studentId}) async {
    var url =
        "http://integrations.aue.ae/stdsvc/student/GetBalanceToPay?StudentID=$studentId";

    try {
      // var response = await http.get(url);
      String username = 'mobileuser';
      String password = 'Auedev2020';
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      print(basicAuth);

      Map<String, String> headers = {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': basicAuth
      };

      // Map<String, String> headers = {"Accept": "text/html,application/xml"};
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        var jsonResponse = convert.jsonDecode(response.body);
        var paymentToPay = PaymentToPayList.fromJson(jsonResponse);
        print("payment count: ${paymentToPay.payentToPayList.length}");
        return paymentToPay.payentToPayList;
      } else {
        return [];
      }
    } catch (error) {
      print(error);
      return [];
    }
  }

  // static Future<PaymentToPay> getPaymentToPay({String studentId}) async {
  //   String username = 'mobileuser';
  //   String password = 'Auedev2020';
  //   String basicAuth =
  //       'Basic ' + base64Encode(utf8.encode('$username:$password'));
  //   print(basicAuth);

  //   Map<String, String> headers = {
  //     'content-type': 'application/json',
  //     'accept': 'application/json',
  //     'authorization': basicAuth
  //   };

  //   final response = await http.get(
  //       'http://integrations.aue.ae/stdsvc/student/GetBalanceToPay?StudentID=$studentId',
  //       headers: headers);

  //   if (response.statusCode == 200) {
  //     return PaymentToPay.fromJson(json.decode(response.body));
  //   } else {
  //     throw Exception('Failed to load Payment');
  //   }
  // }

  //get terms and condition

  static Future<List<TermsCondition>> getTermsAndCondition() async {
    var url =
        "https://integrations.aue.ae/stdsvc/Student/GetTermsAndConditions?StudentID=191210021&FunctionalityID=1&Language=8";

    try {
      // var response = await http.get(url);
      String username = 'mobileuser';
      String password = 'Auedev2020';
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      print(basicAuth);

      Map<String, String> headers = {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': basicAuth
      };

      // Map<String, String> headers = {"Accept": "text/html,application/xml"};
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        var jsonResponse = convert.jsonDecode(response.body);
        var termsAndCondition = TermsConditionList.fromJson(jsonResponse);
        print("College count: ${termsAndCondition.termsConditionList.length}");
        return termsAndCondition.termsConditionList;
      } else {
        return [];
      }
    } catch (error) {
      print(error);
      return [];
    }
  }

  //get Evective colleges function

  static Future<List<ElectiveColleges>> getElectiveColleges() async {
    var url =
        "https://integrations.aue.ae/stdsvc/Student/GetElectiveColleges?StudentID=151810021&ElectiveCategoryID=0&SemesterID=70";

    try {
      // var response = await http.get(url);
      String username = 'mobileuser';
      String password = 'Auedev2020';
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      print(basicAuth);

      Map<String, String> headers = {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': basicAuth
      };

      // Map<String, String> headers = {"Accept": "text/html,application/xml"};
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        var jsonResponse = convert.jsonDecode(response.body);
        var electiveCollege = ElectiveCollegesList.fromJson(jsonResponse);
        print("College count: ${electiveCollege.electiveCollegesList.length}");
        return electiveCollege.electiveCollegesList;
      } else {
        return [];
      }
    } catch (error) {
      print(error);
      return [];
    }
  }

  // get offered elective Courses
  static Future<List<OfferedElectiveCourses>> getOfferedElectiveCorses(
      {var studentId, var electiveCategoryId, var collegeId}) async {
    var url =
        "https://integrations.aue.ae/stdsvc/Student/GetOfferedElectiveCourses?StudentID=$studentId&ElectiveCategoryID=$electiveCategoryId&SemesterID=70&CollegeID=$collegeId";

    try {
      // var response = await http.get(url);
      String username = 'mobileuser';
      String password = 'Auedev2020';
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      print(basicAuth);

      Map<String, String> headers = {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': basicAuth
      };

      // Map<String, String> headers = {"Accept": "text/html,application/xml"};
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        var jsonResponse = convert.jsonDecode(response.body);
        var offeredElectiveCourse =
            OfferedElectiveCoursesList.fromJson(jsonResponse);
        print(
            "offered couurses count: ${offeredElectiveCourse.offeredElectiveCoursesList.length}");
        return offeredElectiveCourse.offeredElectiveCoursesList;
      } else {
        return [];
      }
    } catch (error) {
      print(error);
      return [];
    }
  }

  static Future<List<CourseTiming>> getCourseTimings(
      {var studentId, var courseCode, var semesterId}) async {
    var url =
        "https://integrations.aue.ae/stdsvc/Student/GetCourseTimings?StudentID=$studentId&CourseCode=$courseCode&SemesterID=$semesterId";

    try {
      // var response = await http.get(url);
      String username = 'mobileuser';
      String password = 'Auedev2020';
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      print(basicAuth);

      Map<String, String> headers = {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': basicAuth
      };

      // Map<String, String> headers = {"Accept": "text/html,application/xml"};
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        var jsonResponse = convert.jsonDecode(response.body);
        var courseTimings = CourseTimingList.fromJson(jsonResponse);
        print("Course Timing  count: ${courseTimings.courseTimingList.length}");
        return courseTimings.courseTimingList;
      } else {
        return [];
      }
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<List<Course>> getCourses(String studentId) async {
    final parameters = {"StudentID": studentId};

    try {
      final result = await dio.get(
        "GetAllCoursesByStudentId",
        queryParameters: parameters,
        options: buildCacheOptions(const Duration(days: 7), forceRefresh: true),
      );

      final courses = Course.fromMapToList(result.data);
      return courses;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<ClassAnnouncement>> getClassAnnouncements(
      {String studentId, int sectionId}) async {
    final parameters = {'StudentID': studentId, 'SectionID': sectionId};

    try {
      final result = await dio.get(
        'GetClassAnnouncements',
        queryParameters: parameters,
        options: buildCacheOptions(const Duration(days: 7),
            forceRefresh: true,
            options: Options(receiveDataWhenStatusError: true)),
      );

      final announcements =
          classAnnouncementsFromJson(convert.jsonEncode(result.data));
      return announcements;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<EBook>> getEBooks({String studentId, int sectionId}) async {
    final parameters = {'StudentID': studentId, 'SectionID': sectionId};

    try {
      final result = await dio.get(
        'GetEbooksBySectionID',
        queryParameters: parameters,
        options: buildCacheOptions(
          const Duration(days: 7),
          forceRefresh: true,
        ),
      );

      final ebooks = eBookFromJson(convert.jsonEncode(result.data));
      return ebooks;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<WhatsAppContact>> getWhatsAppContacts(String studentId) async {
    final parameters = {
      'StudentId': studentId,
    };

    try {
      final result = await dio.get(
        'GetWhatsAppContacts',
        queryParameters: parameters,
        options: buildCacheOptions(const Duration(days: 7), forceRefresh: true),
      );
      final whatsAppContacts =
          whatsAppContactFromJson(convert.jsonEncode(result.data));
      return whatsAppContacts;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<CourseOutline>> getCourseOutlines(
      String studentId, int sectionId) async {
    final parameters = {
      'StudentId': studentId,
      'SectionId': sectionId,
    };

    try {
      final result = await dio.get('GetCourseOutline',
          queryParameters: parameters,
          options:
              buildCacheOptions(const Duration(days: 7), forceRefresh: true));
      final courseOutlines =
          courseOutlineFromJson(convert.jsonEncode(result.data));
      return courseOutlines;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<CourseWithdrawalData> getCourseWithdrawalData(
      {String studentId, int sectionId}) async {
    final parameters = {'StudentID': studentId, 'SectionID': sectionId};

    try {
      final result = await dio.get(
        'GetCourseWithdrawalData',
        queryParameters: parameters,
        options: buildCacheOptions(
          const Duration(days: 7),
          forceRefresh: true,
        ),
      );

      final courseWithdrawalData =
          courseWithdrawalDataFromJson(convert.jsonEncode(result.data));
      return courseWithdrawalData;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<CourseWithdrawalReason>> getCourseWithdrawalReasons() async {
    try {
      final result = await dio.get(
        'GetCourseWithdrawalReasons',
        options: buildCacheOptions(
          const Duration(days: 7),
          forceRefresh: true,
        ),
      );

      final courseWithdrawalReasons =
          courseWithdrawalReasonFromJson(convert.jsonEncode(result.data));
      return courseWithdrawalReasons;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<ClassDiscussionModel>> getDiscussions(int sectionId) async {
    final parameters = {"SectionID": sectionId}; // used 17010 to test

    try {
      final result = await dio.get(
        "GetClassDiscussion",
        queryParameters: parameters,
        options: buildCacheOptions(
          Duration(days: 7),
          forceRefresh: true,
        ),
      );

      List<ClassDiscussionModel> discussions = [];

      (result.data as List).forEach(
          (element) => discussions.add(ClassDiscussionModel.fromMap(element)));
      return discussions;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<DiscussionReplyModel> getDiscussionsReplies(int discussionID) async {
    final parameters = {"DiscussionID": discussionID}; // used 3600 to test

    try {
      final result = await dio.get(
        "GetClassDiscussionReply",
        queryParameters: parameters,
        options: buildCacheOptions(
          Duration(days: 7),
          forceRefresh: true,
        ),
      );

      return DiscussionReplyModel.fromMap(result.data);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> addDiscussionReply(
      int discussionID, String reply, String replyBy) async {
    final parameters = {
      "DiscussionID": 3600,
      "ReplyText": reply,
      "ReplyBy": replyBy
    };
    final result = await dio.post(
      "AddDiscussionReply",
      data: parameters,
      options: buildCacheOptions(
        Duration(days: 7),
        forceRefresh: true,
      ),
    );

    print(result.data);
  }

  Future<dynamic> submitWithdrawalRequest(ApplyCourseWithdrawal model) async {
    final parameters = {
      'StudentID': model.studentId,
      'SectionID': model.sectionId,
      'ReasonID': model.reasonId,
      'ReasonText': model.reasonText,
      'RefundPercent': model.refundPercentage,
      'Attachments': model.attachments.map((Map<String, dynamic> attachment) {
        return {
          'StringValue': attachment['StringValue'],
          'ByteValues': attachment['ByteValues']
        };
      }).toList()
    };
    print(parameters);

    try {
      final result = await dio.post(
        'ApplyCourseWithdrawal',
        data: parameters,
        options: buildCacheOptions(
          const Duration(days: 7),
          forceRefresh: true,
        ),
      );
      return result.data;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<Announcement>> getStudentAnnouncements(User user) async {
    final parameters = {"StudentID": user.studentID};

    try {
      final result = await dio.get(
        "SelectStudentAnnouncements",
        queryParameters: parameters,
        options: buildCacheOptions(Duration(days: 7), forceRefresh: true),
      );

      if (result.statusCode == HttpStatus.ok) {
        return Announcement.fromMapToList(result.data);
      }

      return null;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<CourseSchedule> getStudentSchedule(User user) async {
    final currentSemester = await getCurrentSemester(user);

    final parameters = {
      "StudentID": user.studentID,
      "SemesterID": currentSemester.semesterID,
      "DayID": 2
    };

    print('Parameters: $parameters');

    try {
      final result = await dio.get(
        "GetStudentSchedule",
        queryParameters: parameters,
        options: buildCacheOptions(const Duration(days: 7), forceRefresh: true),
      );
      print("\n\n\n\n\n\n");
      Utils.printWrapped(jsonEncode(result.data));

//     final courses = Course.fromMapToList(result.data);
      if (result?.data?.first == null) {
        return Future.error("Invalid Data Error");
      }
      return courseScheduleFromJson(result.data).first;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<CourseMaterial>> getCourseMaterialList(Section section) async {
    final parameters = {"SectionID": section.sectionId};

    try {
      final result = await dio.get(
        "GetAllCourseMaterialsBySectionID",
        queryParameters: parameters,
        options: buildCacheOptions(
          Duration(days: 7),
          forceRefresh: true,
          options: Options(
            receiveDataWhenStatusError: true,
          ),
        ),
      );
      print("\n\n\n\n\n\n");
      // Utils.printWrapped(jsonEncode(result.data));

      final courseMaterials =
          courseMaterialFromJson(convert.jsonEncode(result.data));

      print(courseMaterials);

      return courseMaterials;
    } catch (e) {
      print('Catching Course Material');
      print(e);
      return null;
    }
  }

  Future<List<RubricCriteria>> gerRubricCriteriaList(
      int id, int rubricId, int courseWorkId) async {
    //TODO CHANGE THE IDS
    final parameters = {
      "ID": -1,
      "RubricID": rubricId,
//      "RubricID": rubricId ?? 2927,
//      "CourseWorkID": courseWorkId ?? 84128
      "CourseWorkID": courseWorkId
    };

    print(parameters);

    try {
      final result = await dio.get(
        "GetRubricCriteria",
        queryParameters: parameters,
        options: buildCacheOptions(Duration(days: 7),
            forceRefresh: true,
            options: Options(receiveDataWhenStatusError: true)),
      );

      final List<RubricCriteria> rubricCriteriaList =
          rubricCriteriaFromJson(jsonEncode(result.data));

      print(rubricCriteriaList);

      return rubricCriteriaList;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<List<RubricMeasurement>> getRubricMeasurement(
      int id, int rubricId) async {
    //TODO CHANGE THE IDS
    final parameters = {
      "ID": id ?? -1,
      "RubricID": rubricId ?? 2927,
    };

    print(parameters);
    try {
      final result = await dio.get(
        "GetRubricMeasurement",
        queryParameters: parameters,
        options: buildCacheOptions(const Duration(days: 7), forceRefresh: true),
      );

      final List<RubricMeasurement> rubricMeasurement =
          rubricMeasurementFromJson(jsonEncode(result.data));

      print(rubricMeasurement);

      return rubricMeasurement;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<List<RubricDescriptor>> getRubricDescriptor(
      int id, int rubricId, int measurementId, int criteriaId) async {
    //TODO CHANGE THE IDS
    final parameters = {
      "ID": id ?? -1,
      "RubricID": rubricId ?? 2927,
      "MeasurementID": measurementId ?? 5963,
      "CriteriaID": criteriaId ?? -1
    };

    print(parameters);
    try {
      final result = await dio.get(
        "GetRubricDescriptor",
        queryParameters: parameters,
        options: buildCacheOptions(const Duration(days: 7), forceRefresh: true),
      );

      final List<RubricDescriptor> rubricDescriptor =
          rubricDescriptorFromJson(jsonEncode(result.data));

      print(rubricDescriptor);

      return rubricDescriptor;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<CourseMarks> getCourseMarks(String studentId, int sectionId) async {
    //TODO CHANGE THE IDS
    final parameters = {
      "StudentID": studentId,
      "SectionID": sectionId,
    };

    try {
      final result = await dio.get(
        "GetCourseMarks",
        queryParameters: parameters,
        options: buildCacheOptions(
          const Duration(days: 7),
          forceRefresh: true,
          options: Options(receiveDataWhenStatusError: true),
        ),
      );

      final CourseMarks courseMarks =
          courseMarksFromJson(jsonEncode(result.data));

      return courseMarks;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<List<ApplicableGrant>> getApplicableGrants(String studentId) async {
    final parameters = {
      "StudentID": studentId,
    };

    try {
      final result = await dio.get(
        "GetApplicableGrants",
        queryParameters: parameters,
        options: buildCacheOptions(
          const Duration(days: 7),
          forceRefresh: true,
          options: Options(
            receiveDataWhenStatusError: true,
          ),
        ),
      );

      final List<ApplicableGrant> _applicableGrants =
          applicableGrantFromJson(convert.jsonEncode(result.data));

      return _applicableGrants;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<List<GrantHistory>> getGrantsHistory(String studentId) async {
    final parameters = {
      "StudentID": studentId,
    };
    try {
      final result = await dio.get(
        "GetDiscountHistory",
        queryParameters: parameters,
        options: buildCacheOptions(const Duration(days: 7),
            forceRefresh: true,
            options: Options(receiveDataWhenStatusError: true)),
      );

      final List<GrantHistory> _grantsHistory =
          grantHistoryFromJson(convert.jsonEncode(result.data));

      return _grantsHistory;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<GrantDetails> getGrantDetails(
      String studentId, int discountTypeId, int subTypeId) async {
    final parameters = {
      "StudentID": studentId,
      'DiscountTypeID': discountTypeId,
      'SubTypeID': subTypeId,
    };

    try {
      final result = await dio.get(
        "GetApplicableGrantDetails",
        queryParameters: parameters,
        options: buildCacheOptions(
          const Duration(days: 7),
          forceRefresh: true,
        ),
      );

      final GrantDetails _grantDetails =
          grantDetailsFromJson(convert.jsonEncode(result.data));

      return _grantDetails;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<GrantDetailsSemesterCompany> getGrantDetailsSemesterCompany(
      String studentId, int discountTypeId, int subTypeId) async {
    final parameters = {
      "StudentID": studentId,
      'DiscountTypeID': discountTypeId,
      'SubTypeID': subTypeId,
    };

    try {
      final result = await dio.get(
        "GetApplicableGrantDetails",
        queryParameters: parameters,
        options: buildCacheOptions(const Duration(days: 7),
            forceRefresh: true,
            options: Options(receiveDataWhenStatusError: true)),
      );

      final GrantDetailsSemesterCompany _grantDetails =
          grantDetailsSemesterCompanyFromJson(convert.jsonEncode(result.data));

      return _grantDetails;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<GrantDetailsSemester> getGrantDetailsSemester(
      String studentId, int discountTypeId, int subTypeId) async {
    final parameters = {
      "StudentID": studentId,
      'DiscountTypeID': discountTypeId,
      'SubTypeID': subTypeId,
    };

    try {
      final result = await dio.get(
        "GetApplicableGrantDetails",
        queryParameters: parameters,
        options: buildCacheOptions(const Duration(days: 7),
            forceRefresh: true,
            options: Options(receiveDataWhenStatusError: true)),
      );

      final GrantDetailsSemester _grantDetails =
          grantDetailsSemesterFromJson(convert.jsonEncode(result.data));

      return _grantDetails;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<GrantDetailsSemesterAlumni> getGrantDetailsSemesterAlumni(
      String studentId, int discountTypeId, int subTypeId) async {
    final parameters = {
      "StudentID": studentId,
      'DiscountTypeID': discountTypeId,
      'SubTypeID': subTypeId,
    };

    try {
      final result = await dio.get(
        "GetApplicableGrantDetails",
        queryParameters: parameters,
        options: buildCacheOptions(const Duration(days: 7),
            forceRefresh: true,
            options: Options(receiveDataWhenStatusError: true)),
      );

      final GrantDetailsSemesterAlumni _grantDetails =
          grantDetailsSemesterAlumniFromJson(convert.jsonEncode(result.data));

      return _grantDetails;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<String> applyGrantSemesterCompany(
      ApplyGrantSemesterCompany applyGrantSemesterCompany,
      Function(int, int) onSendProgress) async {
    print('SemesterCompany: ');
    print(applyGrantSemesterCompany.toJson());
    try {
      final result = await dio.post('ApplyGrantRequest',
          data: convert.jsonEncode(applyGrantSemesterCompany),
          options: Options(receiveDataWhenStatusError: true),
          onReceiveProgress: (int count, int total) {
        print('OnReceiveProgress: count: $count | total: $total');
      }, onSendProgress: (int count, int total) {
        print('OnSendProgress: count: $count | total: $total');
        onSendProgress(count, total);
      });
      print(result.data);
      return result.data;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<String> applyAcademicGrievance(
      ApplyAcademicGrievance applyAcademicGrievance,
      Function(int, int) onSendProgress) async {
    print(applyAcademicGrievance.toJson());
    try {
      final result = await dio.post('SubmitAcademicGrievance',
          data: convert.jsonEncode(applyAcademicGrievance),
          options: Options(
            receiveDataWhenStatusError: true,
          ), onReceiveProgress: (int count, int total) {
        print('OnReceiveProgress: count: $count | total: $total');
      }, onSendProgress: (int count, int total) {
        print('OnSendProgress: count: $count | total: $total');
        onSendProgress(count, total);
      });
      print(result.data);
      return result.data;
    } catch (e) {
      print((e as DioError).response.data);
      return Future.error(e);
    }
  }

  Future<StudentGrades> getStudentGrades(String studentId) async {
    final parameters = {
      "StudentID": studentId,
    };

    try {
      final result = await dio.get(
        "GetStudentGrades",
        queryParameters: parameters,
        options: buildCacheOptions(const Duration(days: 7),
            forceRefresh: true,
            options: Options(receiveDataWhenStatusError: true)),
      );

      final StudentGrades _studentGrades =
          studentGradesFromJson(convert.jsonEncode(result.data));

      return _studentGrades;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<StudyPlan> getStudyPlan(String studentId) async {
    final parameters = {
      "StudentID": studentId,
    };

    try {
      final result = await dio.get(
        "GetStudyPlan",
        queryParameters: parameters,
        options: buildCacheOptions(const Duration(days: 7),
            forceRefresh: true,
            options: Options(receiveDataWhenStatusError: true)),
      );

      final StudyPlan _studyPlan =
          studyPlanFromJson(convert.jsonEncode(result.data));

      return _studyPlan;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<List<Section>> getSections(User user) async {
    // final currentSemester = await getSectionId(user);
    // TODO: HardCoded SemesterID
    final parameters = {
      "StudentID": user.studentID,
      "SemesterID": 64,
    };
    try {
      final result = await dio.get("GetAllSectionsByStudentID",
          queryParameters: parameters);
      final sections = sectionFromJson(convert.jsonEncode(result.data));
      return sections;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<SingleSection> getSingleSection([int sectionID]) async {
//    final Map<String, dynamic> parameters = {'SectionID': sectionID ?? 14397};
    try {
      String username = 'mobileuser';
      String password = 'Auedev2020';
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      print(basicAuth);

      Map<String, String> headers = {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': basicAuth
      };
      final result = await http.get(
          'http://integrations.aue.ae/stdsvc/Student/GetSectionByID?SectionID=$sectionID',
          headers: headers);
      if (result.statusCode == 200) {
        print(json.decode(result.body));
        final SingleSection singleSection =
            SingleSection.fromJson(json.decode(result.body)[0]);
        print('SingleSection');
        print(singleSection.toJson());
        return singleSection;
      } else {
        return null;
      }
//      final result = await dio.get('GetSectionByID', queryParameters: parameters);
//      print('TypeOf');
//      print(result.data.runtimeType);
//      final SingleSection singleSection = SingleSection.fromJson(json.decode(result.data));
//      print('SingleSection');
//      print(singleSection.toJson());
//      return singleSection;
    } catch (e) {
      print('SingleSectionError');
      print(e);
      return Future.error(e);
    }
  }

  static Future<AttendanceSummary> getAttendanceSummary(
      [String studentID, int sectionID]) async {
//    final Map<String, dynamic> parameters = {'SectionID': sectionID ?? 14397};
    try {
      String username = 'mobileuser';
      String password = 'Auedev2020';
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      print(basicAuth);

      Map<String, String> headers = {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': basicAuth
      };
      final result = await http.get(
        'https://integrations.aue.ae/stdsvc/Student/GetAttendanceSummary?StudentID=${studentID ?? 181230009}&SectionID=${sectionID ?? 17594}',
        headers: headers,
      );
      if (result.statusCode == 200) {
        print(json.decode(result.body));
        final AttendanceSummary attendanceSummary =
            attendanceSummaryFromJson(result.body);
        print('AttendanceSummary');
        print(attendanceSummary.toJson());
        return attendanceSummary;
      } else {
        return null;
      }
//      final result = await dio.get('GetSectionByID', queryParameters: parameters);
//      print('TypeOf');
//      print(result.data.runtimeType);
//      final SingleSection singleSection = SingleSection.fromJson(json.decode(result.data));
//      print('SingleSection');
//      print(singleSection.toJson());
//      return singleSection;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<CurrentSemester> getCurrentSemester(User user) async {
    if (user.currentSemester == null) {
      final currentSemesterData = await dio.get('GetCurrentSemester');
      if (currentSemesterData.statusCode == HttpStatus.ok) {
        final currentSemester =
            CurrentSemester.fromMap(currentSemesterData.data);
        user.currentSemester = currentSemester;
      } else {
        throw HttpException("Unable To Get Semester Id");
      }
    }

    return user.currentSemester;
  }

  Future<List<Timeline>> getTimeLine({int sectionId}) async {
    // final currentSemester = await getSectionId(user);
    final parameters = {
      "SectionID": sectionId,
    };
    try {
      final result = await dio.get("GetTimeline", queryParameters: parameters);
      final timelines = Timeline.fromMapToList(result.data);
      return timelines;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<List<Assignment>> getStudentAssignmentsBySectionID(
      [String studentId = "181210060", int sectionId = 14397]) async {
    final parameters = {"StudentID": studentId, "SectionID": sectionId};
    print(parameters);
    try {
      final result = await dio.get(
        "GetStudentAssignmentsBySectionID",
        queryParameters: parameters,
        options: buildCacheOptions(
          const Duration(days: 7),
          options: Options(
            receiveDataWhenStatusError: true
          )
        ),
      );

      if (result.statusCode == HttpStatus.ok) {
        return assignmentFromJson(convert.jsonEncode(result.data));
      }

      return null;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<Event>> getEventsByType(
      [int typeId = 0, bool activeOnly = false]) async {
    final parameters = {"TypeID": typeId, "ActiveOnly": activeOnly};

    print(parameters);

    try {
      final result = await dio.get(
        "SelectEventsByType",
        queryParameters: parameters,
        options: buildCacheOptions(Duration(days: 7), forceRefresh: true),
      );

      if (result.statusCode == HttpStatus.ok) {
        return Event.fromMapToList(result.data);
      }

      return null;
    } catch (e) {
      return Future.error(e);
    }
  }
}

//final map = [
//  {
//    "ID": 1,
//    "Value": "Sunday",
//    "Message": "No Class",
//    "Schedule": [
//      {
//        "SectionID": "14179",
//        "SectionCode": "HRM 404-W1",
//        "MergeID": "742859C0-D250-4F83-9056-A7CDD845116F",
//        "CourseName": "Special Topics in HR",
//        "CreditHours": "3",
//        "Classroom": "CR 7302",
//        "TotalStudents": "36",
//        "DayID": "1",
//        "Day": null,
//        "StartTime": "0001-01-01T00:00:00",
//        "EndTime": "0001-01-01T00:00:00",
//        "Timing": "00:00-00:00",
//        "InstructorImageByte": null,
//        "InstructorName": "Dr. Tarek Azmi Abousaleh",
//        "code": "00",
//        "Message": "Successfull"
//      },
//      {
//        "SectionID": "14180",
//        "SectionCode": "HRM 405-W1",
//        "MergeID": "49785956-8949-47FC-9074-3FC478A5FEE3",
//        "CourseName": "Strategic Human Resource Management",
//        "CreditHours": "3",
//        "Classroom": "CR 7113",
//        "TotalStudents": "26",
//        "DayID": "1",
//        "Day": null,
//        "StartTime": "0001-01-01T00:00:00",
//        "EndTime": "0001-01-01T00:00:00",
//        "Timing": "00:00-00:00",
//        "InstructorImageByte": null,
//        "InstructorName": "Dr. Tarek Azmi Abousaleh",
//        "code": "00",
//        "Message": "Successfull"
//      },
//      {
//        "SectionID": "14191",
//        "SectionCode": "MGT 300-1",
//        "MergeID": "999BBEC2-6951-4F24-9A08-078C61F61462",
//        "CourseName": "Production and Operations Management",
//        "CreditHours": "3",
//        "Classroom": "LAB 7114",
//        "TotalStudents": "34",
//        "DayID": "1",
//        "Day": null,
//        "StartTime": "0001-01-01T00:00:00",
//        "EndTime": "0001-01-01T00:00:00",
//        "Timing": "00:00-00:00",
//        "InstructorImageByte": null,
//        "InstructorName": "Prof. Abdulsattar Ahmad Al Alusi",
//        "code": "00",
//        "Message": "Successfull"
//      },
//      {
//        "SectionID": "14212",
//        "SectionCode": "MGT 303-2",
//        "MergeID": "775DD83A-FC14-4D06-984F-1CBE64CA6092",
//        "CourseName": "Quantitative Analysis",
//        "CreditHours": "3",
//        "Classroom": "LAB 7105",
//        "TotalStudents": "42",
//        "DayID": "1",
//        "Day": null,
//        "StartTime": "0001-01-01T00:00:00",
//        "EndTime": "0001-01-01T00:00:00",
//        "Timing": "00:00-00:00",
//        "InstructorImageByte": null,
//        "InstructorName": "Dr. Muhammad Azeem",
//        "code": "00",
//        "Message": "Successfull"
//      }
//    ]
//  },
//  {"ID": 2, "Value": "Monday", "Message": "", "Schedule": []},
//  {"ID": 3, "Value": "Tuesday", "Message": "", "Schedule": []},
//  {"ID": 4, "Value": "Wednesday", "Message": "", "Schedule": []},
//  {"ID": 5, "Value": "Thursday", "Message": "", "Schedule": []},
//  {"ID": 6, "Value": "Friday", "Message": "", "Schedule": []},
//  {"ID": 7, "Value": "Saturday", "Message": "", "Schedule": []}
//];
