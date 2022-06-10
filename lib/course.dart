import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  String title, description, tutor;
  List<String> startTime = List.filled(0, ' ', growable: true);
  List<String> endTime = List.filled(0, ' ', growable: true);
  List<String> dayOfTheWeek = List.filled(0, ' ', growable: true);
  List<int> maxNumberOfStudents = List.filled(0, 0, growable: true);

  Course(this.title, this.description, this.tutor, this.dayOfTheWeek,
      this.startTime, this.endTime, this.maxNumberOfStudents);
}

List<Course> courses = List.filled(
    0,
    Course(' ', ' ', ' ', List<String>.empty(), List<String>.empty(),
        List<String>.empty(), List<int>.empty()),
    growable: true);
//Course courseToAdd = Course('Not initialized', ' ',' ', List<String>.empty(),List<String>.empty(), List<String>.empty(), List<int>.empty());
Future<void> getCourses() async {
  if (courses.isEmpty) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Course courseToAdd;
    var _myCoursesSnapshots =
        await firestore.collection('courses').orderBy('title').get();
    final _courses = _myCoursesSnapshots.docs;

    String courseTitle;

    courseToAdd = Course(
        _courses[0].data()['title'],
        _courses[0].data()['description'],
        _courses[0].data()['tutor'],
        List<String>.filled(0, ' ', growable: true),
        List<String>.filled(0, ' ', growable: true),
        List<String>.filled(0, ' ', growable: true),
        List<int>.filled(0, 0, growable: true));

    courseToAdd.dayOfTheWeek.add(_courses[0].data()['dayOfTheWeek']);
    courseToAdd.startTime.add(_courses[0].data()['startTime']);
    courseToAdd.endTime.add(_courses[0].data()['endTime']);
    courseToAdd.maxNumberOfStudents
        .add(_courses[0].data()['maxNumberOfStudents']);
    courses.add(courseToAdd);

    int i;
    int courseCounter = 0;
    for (i = 1; i < _courses.length; i++) {
      courseTitle = _courses[i].data()['title'];
      if (courses[courseCounter].title != courseTitle) {
        courseCounter++;
        courseToAdd = Course(
            _courses[i].data()['title'],
            _courses[i].data()['description'],
            _courses[i].data()['tutor'],
            List<String>.filled(0, ' ', growable: true),
            List<String>.filled(0, ' ', growable: true),
            List<String>.filled(0, ' ', growable: true),
            List<int>.filled(0, 0, growable: true));

        courseToAdd.dayOfTheWeek.add(_courses[i].data()['dayOfTheWeek']);
        courseToAdd.startTime.add(_courses[i].data()['startTime']);
        courseToAdd.endTime.add(_courses[i].data()['endTime']);
        courseToAdd.maxNumberOfStudents
            .add(_courses[i].data()['maxNumberOfStudents']);
        courses.add(courseToAdd);
      } else {
        courses[courseCounter]
            .dayOfTheWeek
            .add(_courses[i].data()['dayOfTheWeek']);
        courses[courseCounter].startTime.add(_courses[i].data()['startTime']);
        courses[courseCounter].endTime.add(_courses[i].data()['endTime']);
        courseToAdd.maxNumberOfStudents
            .add(_courses[i].data()['maxNumberOfStudents']);
      }
    }
  }
}
