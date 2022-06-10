import 'package:cloud_firestore/cloud_firestore.dart';

class Requests {
  String title, dayOfTheWeek, startTime, student, currentStatus;
  Requests(this.title, this.dayOfTheWeek, this.startTime, this.student,
      this.currentStatus);
}

List<Requests> listOfRequests =
    List.filled(0, Requests(' ', ' ', ' ', ' ', ' '), growable: true);

Future<void> getRequests(String? tutor) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Requests courseToAdd;
  listOfRequests =
      List.filled(0, Requests(' ', ' ', ' ', ' ', ' '), growable: true);

  var _myRequestsSnapshots = await firestore
      .collection('users-courses-requests')
      .where("tutor-email", isEqualTo: tutor)
      .get();

  final _requests = _myRequestsSnapshots.docs;

  int i;
  for (i = 0; i < _requests.length; i++) {
    courseToAdd = Requests(
      _requests[i].data()['course-name'],
      _requests[i].data()['dayOfTheWeek'],
      _requests[i].data()['startTime'],
      _requests[i].data()['user-email'],
      _requests[i].data()['status-request'],
    );
    listOfRequests.add(courseToAdd);
  }
}
