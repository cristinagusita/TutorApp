import 'package:cloud_firestore/cloud_firestore.dart';

class TutorsCourseInfo {
  String title, description, dayOfTheWeek, startTime, endTime;
  int maxNumberOfStudents;
  List<String> acceptedStudents;

  TutorsCourseInfo(
      this.title,
      this.description,
      this.dayOfTheWeek,
      this.startTime,
      this.endTime,
      this.maxNumberOfStudents,
      this.acceptedStudents);
}

List<TutorsCourseInfo> TutorsCourses = List.filled(
    0,
    TutorsCourseInfo(
        ' ', ' ', ' ', ' ', ' ', 0, List.filled(0, '', growable: true)),
    growable: true);

Future<void> getCoursesByTutor(String? tutor) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  TutorsCourses = List.filled(
      0,
      TutorsCourseInfo(
          ' ', ' ', ' ', ' ', ' ', 0, List.filled(0, '', growable: true)),
      growable: true);

  TutorsCourseInfo courseToAdd;
  var _myCoursesSnapshots = await firestore
      .collection('courses')
      .where("tutor", isEqualTo: tutor)
      .get();
  final _courses = _myCoursesSnapshots.docs;

  if (_courses.isNotEmpty) {
    int i;
    for (i = 0; i < _courses.length; i++) {
      var _myCoursesSnapshots = await FirebaseFirestore.instance
          .collection("courses")
          .doc(
              '${_courses[i]['title']}${_courses[i]['dayOfTheWeek']}${_courses[i]['startTime']}')
          .get();

      var _myStudentsSnapshot = await firestore
          .collection('users-courses-requests')
          .where("tutor-email", isEqualTo: tutor)
          .where('course-name', isEqualTo: _courses[i]['title'])
          .where('dayOfTheWeek', isEqualTo: _courses[i]['dayOfTheWeek'])
          .where('startTime', isEqualTo: _courses[i]['startTime'])
          .get();

      final students = _myStudentsSnapshot.docs;

      List<String> studentsList = List.filled(0, '', growable: true);

      for (int j = 0; j < students.length; j++) {
        studentsList.add(students[j]['user-email']);
      }

      final info = _myCoursesSnapshots.data();
      String description = info?['description'];
      String endTime = info?['endTime'];
      print('endtime: $endTime');
      courseToAdd = TutorsCourseInfo(
          _courses[i].data()['title'],
          description,
          _courses[i].data()['dayOfTheWeek'],
          _courses[i].data()['startTime'],
          endTime,
          _courses[i].data()['maxNumberOfStudents'],
          studentsList);
      TutorsCourses.add(courseToAdd);
    }
  }
}
