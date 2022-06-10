import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tutor_app/screens/students/student_course_details.dart';
import '../../course.dart';

class RegisterToCourse extends StatefulWidget {
  static const id = 'students-register-to-course';

  const RegisterToCourse({Key? key}) : super(key: key);

  @override
  _RegisterToCourseScreenState createState() => _RegisterToCourseScreenState();
}

class _RegisterToCourseScreenState extends State<RegisterToCourse> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Courses'),
      ),
      body: Container(
        color: Colors.white,
        height: 160.0 * courses.length,
        child: ListView.builder(
          itemCount: courses.length ,
          itemBuilder: (BuildContext context, int index) {
            CourseDetailsCard courseDetailsCard = CourseDetailsCard(courses[index], index);
            return courseDetailsCard;
          },
        ),
      ),
    );
  }
}

class CourseDetailsCard extends StatelessWidget {
  final Course course;
  final int index;
  CourseDetailsCard(this.course,this.index);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            ListTile(
              title: Text(course.title),
              subtitle: Text(
                course.tutor,
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudentsCourseDetails(index)),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                course.description,
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
