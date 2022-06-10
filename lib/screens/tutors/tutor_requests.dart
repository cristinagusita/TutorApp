import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'get_requests.dart';

class TutorRequests extends StatefulWidget {
  const TutorRequests({Key? key}) : super(key: key);

  static String id = 'tutor-requests';

  @override
  State<TutorRequests> createState() => _TutorRequestsState();
}

class _TutorRequestsState extends State<TutorRequests> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Requests'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: listOfRequests.length,
          itemBuilder: (BuildContext context, int index) {
            CourseDetailsCard courseDetailsCard =
                CourseDetailsCard(listOfRequests[index], index);
            return courseDetailsCard;
          },
        ),
      ),
    );
  }
}

class CourseDetailsCard extends StatefulWidget {
  final Requests requestInfo;
  final int index;

  CourseDetailsCard(this.requestInfo, this.index, {Key? key}) : super(key: key);

  @override
  State<CourseDetailsCard> createState() => _CourseDetailsCardState();
}

class _CourseDetailsCardState extends State<CourseDetailsCard> {
  @override
  State<CourseDetailsCard> createState() => _CourseDetailsCardState();
}

class _CourseDetailsCardState extends State<CourseDetailsCard> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.requestInfo.currentStatus == 'pending',
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListTile(
                    title: Text(widget.requestInfo.title),
                    subtitle: Text(
                        'on ${widget.requestInfo.dayOfTheWeek}s, ${widget.requestInfo.startTime}')),
                Column(
                  children: [
                    Text(
                      'student: ${widget.requestInfo.student}',
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('users-courses-requests')
                                  .doc(
                                      '${widget.requestInfo.student}${widget.requestInfo.title}${widget.requestInfo.dayOfTheWeek}${widget.requestInfo.startTime}')
                                  .update({'status-request': 'accepted'});
                              setState(() {
                                widget.requestInfo.currentStatus = 'accepted';
                              });
                            },
                            child: const Text('Accept')),
                        TextButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('courses')
                                  .doc(
                                      '${widget.requestInfo.title}${widget.requestInfo.dayOfTheWeek}${widget.requestInfo.startTime}')
                                  .update({
                                'maxNumberOfStudents': FieldValue.increment(1)
                              });
                              FirebaseFirestore.instance
                                  .collection('users-courses-requests')
                                  .doc(
                                      '${widget.requestInfo.student}${widget.requestInfo.title}${widget.requestInfo.dayOfTheWeek}${widget.requestInfo.startTime}')
                                  .update({'status-request': 'declined'});
                              setState(() {
                                widget.requestInfo.currentStatus = 'declined';
                              });
                            },
                            child: const Text('Reject')),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
