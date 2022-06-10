import 'package:flutter/material.dart';
import 'package:tutor_app/auth_info.dart';
import 'package:tutor_app/screens/tutors/profile_screen.dart';
import 'package:tutor_app/screens/tutors/tutor_history_of_courses.dart';
import 'package:tutor_app/screens/tutors/tutor_requests.dart';
import 'package:tutor_app/screens/tutors/tutors_create_course.dart';
import 'get_requests.dart';
import 'get_tutor_courses.dart';

class TutorsMainScreen extends StatefulWidget {
  static const id = 'tutors-main';

  @override
  _TutorsMainScreenState createState() => _TutorsMainScreenState();
}

class _TutorsMainScreenState extends State<TutorsMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tutor\'s Screen')),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, TutorProfile.id);
                  },
                  child: const Text('Create a Profile'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, CreateCourse.id);
                  },
                  child: const Text('Create a Course'),
                ),
                TextButton(
                  onPressed: () async {
                    await getCoursesByTutor(authEmail);
                    Navigator.pushNamed(context, TutorHistory.id);
                  },
                  child: const Text('Course\'s History'),
                ),
                TextButton(
                  onPressed: () async {
                    await getRequests(authEmail);
                    Navigator.pushNamed(context, TutorRequests.id);
                  },
                  child: const Text('Course\'s Requests'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
