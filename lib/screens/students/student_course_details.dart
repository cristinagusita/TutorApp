import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tutor_app/auth_info.dart';

import 'package:tutor_app/course.dart';

class StudentsCourseDetails extends StatefulWidget {
  int index;

  StudentsCourseDetails(this.index);

  static final id = 'course-details';

  @override
  _StudentsCourseDetailsState createState() =>
      _StudentsCourseDetailsState(index);
}

class _StudentsCourseDetailsState extends State<StudentsCourseDetails> {
  int index;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  _StudentsCourseDetailsState(this.index);

  void addStudentToCourse(int numberOfSession) async {
    QuerySnapshot _myDoc = await firestore.collection('users-courses-requests')
        .where('course-name', isEqualTo: courses[index].title)
        .where('user-email', isEqualTo: authEmail)
        .where('dayOfTheWeek', isEqualTo: courses[index].dayOfTheWeek[numberOfSession])
        .where('startTime', isEqualTo: courses[index].startTime[numberOfSession]).get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;

    if(_myDocCount.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('The student already sent a request for this session.')));
      return;
    }

    if(courses[index].maxNumberOfStudents[numberOfSession] == 0){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('There is no space left in this session.')));
      return;
    }

    firestore.collection('users-courses-requests').doc('$authEmail${courses[index].title}'
        '${courses[index].dayOfTheWeek[numberOfSession]}'
        '${courses[index].startTime[numberOfSession]}').set({
      'user-email': authEmail,
      'tutor-email': courses[index].tutor,
      'course-name': courses[index].title,
      'dayOfTheWeek': courses[index].dayOfTheWeek[numberOfSession],
      'startTime': courses[index].startTime[numberOfSession],
      'status-request': 'pending'
    });

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Request was sent to the ${courses[index].title} on ${courses[index].dayOfTheWeek[numberOfSession]} at ${courses[index].startTime[numberOfSession]}.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Course details'),
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Title: ' + courses[index].title,
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                'Tutor email: ' + courses[index].tutor,
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                'Description: ' + courses[index].description,
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                'Available sessions:',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              Container(
                //height: MediaQuery.of(context).size.height - 260,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: courses[index].dayOfTheWeek.length,
                    itemBuilder: (BuildContext context, int numberOfSession) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                                'Day: every ${courses[index].dayOfTheWeek[numberOfSession]}'),
                            Text(
                                'Start Time: ${courses[index].startTime[numberOfSession]} \n End Time: ${courses[index].endTime[numberOfSession]}'),
                            Text(
                                'Available seats: ${courses[index].maxNumberOfStudents[numberOfSession]}'),
                            TextButton(
                                onPressed: () {
                                  addStudentToCourse(numberOfSession);
                                },
                                child: const Text('Register this course')),
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
