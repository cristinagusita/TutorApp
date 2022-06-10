import 'package:flutter/material.dart';
import 'package:tutor_app/auth_info.dart';
import 'package:tutor_app/screens/students/students_register_to_course.dart';
import '../../course.dart';
import 'get_students_courses.dart';
import 'student_history_of_courses.dart';

class StudentsMainScreen extends StatefulWidget {
  const StudentsMainScreen();
  static const id = 'students-main';

  @override
  _StudentsMainScreenState createState() => _StudentsMainScreenState();
}

class _StudentsMainScreenState extends State<StudentsMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student\'s Screen'),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                TextButton(
                    onPressed: () async {
                      await getCourses();
                      Navigator.pushNamed(context, RegisterToCourse.id);
                    },
                    child: const Text('Register to a new course')
                ),
                TextButton(
                    onPressed: () async {
                      await getCoursesByStudent(authEmail);
                      Navigator.pushNamed(context, StudentHistory.id);
                    },
                    child: const Text('History of the courses')
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
