import 'package:cloud_firestore/cloud_firestore.dart';

class RequestInfo {
  String courseName, description, dayOfTheWeek, startTime, endTime, statusRequest, tutorEmail;

  RequestInfo(this.courseName, this.description, this.tutorEmail, this.dayOfTheWeek, this.startTime, this.endTime, this.statusRequest);
}

List<RequestInfo> coursesTaken = List.filled(
    0,
    RequestInfo(' ', ' ', ' ', ' ', ' ', ' ', ' '),
    growable: true);

Future<void> getCoursesByStudent(String? studentEmail) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  coursesTaken = List.filled(
      0,
      RequestInfo(' ', ' ', ' ', ' ', ' ', ' ', ' '),
      growable: true);


    RequestInfo courseToAdd;
    var _myCoursesSnapshots = await firestore
        .collection('users-courses-requests')
        .where("user-email", isEqualTo: studentEmail)
        .get();
    final _courses = _myCoursesSnapshots.docs;

    print(_courses.length);

      int i;
      for (i = 0; i < _courses.length; i++) {
        var _myCoursesSnapshots = await FirebaseFirestore.instance
            .collection("courses")
            .doc(
            '${_courses[i]['course-name']}${_courses[i]['dayOfTheWeek']}${_courses[i]['startTime']}')
            .get();
        final info = _myCoursesSnapshots.data();
          String description = info?['description'] ?? ' ' ;
          String endTime = info?['endTime'] ?? ' ';
          courseToAdd = RequestInfo(
            _courses[i].data()['course-name'],
            description,
            _courses[i].data()['tutor-email'],
            _courses[i].data()['dayOfTheWeek'],
            _courses[i].data()['startTime'],
            endTime,
            _courses[i].data()['status-request'],
          );
          coursesTaken.add(courseToAdd);
    }
}

