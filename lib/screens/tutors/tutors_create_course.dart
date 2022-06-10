import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tutor_app/auth_info.dart';

class CreateCourse extends StatefulWidget {
  static const id = 'create-course';
  const CreateCourse({Key? key}) : super(key: key);

  @override
  _CreateCourseState createState() => _CreateCourseState();
}

class _CreateCourseState extends State<CreateCourse> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String description = "", title = "";
  int maxNumberOfStudents = -1, numberOfHours = -1;
  final TimeOfDay _time = const TimeOfDay(hour: 0, minute: 00);

  List<TimeOfDay> startTimes =
  List.filled(0, const TimeOfDay(hour: 0, minute: 00), growable: true);
  List<TimeOfDay> endTimes =
  List.filled(0, const TimeOfDay(hour: 0, minute: 00), growable: true);
  List<String> dayOfTheWeek = List.filled(0, 'Monday', growable: true);

  SnackBar errorSnackbar(String error) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(error),
    );
  }

  Future<String> checkDetails() async {
    if (title.isEmpty) {
      return 'The title is empty!';
    }

    QuerySnapshot _myDoc =
    await firestore.collection('courses').where('title',isEqualTo: title).get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;

    if (_myDocCount.isNotEmpty) {
      return 'The name of this course is used already. Please choose another one.';
    }

    if (description.isEmpty) {
      return 'The description is empty!';
    }

    if (numberOfHours <= 0) {
      return 'Please choose the number of hours.';
    }

    if (maxNumberOfStudents <= 0) {
      return 'Please choose the number of students.';
    }

    for (int i = 0; i < numberOfHours; i++) {
      if (startTimes[i].toString().compareTo(endTimes[i].toString()) > 0) {
        return 'The starting time is later than the ending time for the interval number ${i + 1}!';
      }
    }

    return "No error";
  }

  void addCourse() {
    for (int i = 1; i <= numberOfHours; i++) {
      firestore.collection("courses").doc('$title${dayOfTheWeek[i - 1]}${startTimes[i - 1].format(context)}').set({
        "tutor": authEmail,
        "title": title,
        "description": description,
        "maxNumberOfStudents": maxNumberOfStudents,
        "startTime": startTimes[i - 1].format(context),
        "endTime": endTimes[i - 1].format(context),
        "dayOfTheWeek": dayOfTheWeek[i-1]
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create course'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 23.0,
          left: 23.0,
          right: 23.0,
        ),
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            TextFormField(
              onChanged: (value) {
                title = value;
              },
              minLines: 1,
              maxLines: 2,
              decoration: const InputDecoration(
                  labelText: 'Title', border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 15.0,
            ),
            TextFormField(
              onChanged: (value) {
                description = value;
              },
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                  labelText: 'Description', border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 15.0,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              onChanged: (value) {
                setState(() {
                  if (value.isEmpty) {
                    maxNumberOfStudents = -1;
                  } else {
                    maxNumberOfStudents = int.parse(value);
                  }
                });
              },
              decoration: const InputDecoration(
                  labelText: 'Maximum number of students',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 15.0,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              onChanged: (value) {
                setState(() {
                  numberOfHours = int.parse(value);
                });
              },
              decoration: const InputDecoration(
                  labelText: 'Number of hours', border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 15.0,
            ),
            ListView.builder(
                itemCount: numberOfHours < 0 ? 0 : numberOfHours,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  startTimes.add(_time);
                  endTimes.add(_time);

                  for (int i = 0; i < numberOfHours; i++) {
                    dayOfTheWeek.add("Monday");
                  }

                  TimeOfDay selectedTime;

                  Future<TimeOfDay> _selectTime() async {
                    final TimeOfDay? newTime = await showTimePicker(
                      context: context,
                      initialTime: startTimes[index],
                      initialEntryMode: TimePickerEntryMode.input,
                    );
                    return newTime ?? const TimeOfDay(hour: 0, minute: 0);
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      DropdownButton(
                        value: dayOfTheWeek[index].toString(),
                        items: _dropDownItem(),
                        onChanged: (value) {
                          dayOfTheWeek[index] = value.toString();
                          setState(() {});
                        },
                        hint: const Text('Select Day'),
                      ),
                      const SizedBox(width: 10.0),
                      ElevatedButton(
                          child: Text(
                            startTimes[index].format(context) == "12:00 AM"
                                ? 'Choose time'
                                : startTimes[index].format(context),
                            style: const TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                          onPressed: () async {
                            selectedTime = await _selectTime();
                            setState(() {
                              startTimes[index] = selectedTime;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            //fixedSize: const Size(100.0, 40.0),
                          )),
                      const SizedBox(width: 10.0),
                      ElevatedButton(
                        onPressed: () async {
                          selectedTime = await _selectTime();
                          setState(() {
                            endTimes[index] = selectedTime;
                          });
                        },
                        child: Text(
                          endTimes[index].format(context) == "12:00 AM"
                              ? 'Choose time'
                              : endTimes[index].format(context),
                          style: const TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          //fixedSize: const Size(100.0, 40.0),
                        ),
                      ),
                    ],
                  );
                }),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () async {
                    String response = await checkDetails();
                    if (response.compareTo("No error") == 0) {
                      addCourse();
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(errorSnackbar(await checkDetails()));
                    }
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: const Text(
                    'SAVE COURSE',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItem() {
    List<String> ddl = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    return ddl
        .map((value) => DropdownMenuItem(
      value: value,
      child: Text(value),
    ))
        .toList();
  }
}
