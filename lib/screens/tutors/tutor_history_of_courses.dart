import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'get_tutor_courses.dart';

class TutorHistory extends StatefulWidget {
  const TutorHistory({Key? key}) : super(key: key);

  static String id = 'tutor-history';

  @override
  State<TutorHistory> createState() => _TutorHistoryState();
}

class _TutorHistoryState extends State<TutorHistory> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: TutorsCourses.length,
          itemBuilder: (BuildContext context, int index) {
            String students = '';
            for (int i = 0;
                i < TutorsCourses[index].acceptedStudents.length;
                i++) {
              students += TutorsCourses[index].acceptedStudents[i];
            }

            if (students == '') students = 'No one is registered yet.';

            CourseDetailsCard courseDetailsCard =
                CourseDetailsCard(TutorsCourses[index], students, index);
            return courseDetailsCard;
          },
        ),
      ),
    );
  }
}

class CourseDetailsCard extends StatelessWidget {
  final TutorsCourseInfo requestInfo;
  final int index;
  final String students;

  const CourseDetailsCard(this.requestInfo, this.students, this.index);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                title: Text(requestInfo.title),
              ),
              Text(
                'description: ${requestInfo.description}',
              ),
              Text(
                  'on ${requestInfo.dayOfTheWeek}s, ${requestInfo.startTime}-${requestInfo.endTime}'),
              Text(
                'accepted students: $students',
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'spots left: ${requestInfo.maxNumberOfStudents}',
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
