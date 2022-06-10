import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tutor_app/screens/first_screen.dart';
import 'package:tutor_app/screens/register_screen.dart';
import 'package:tutor_app/screens/students/student_history_of_courses.dart';
import 'package:tutor_app/screens/tutors/profile_screen.dart';
import 'package:tutor_app/screens/students/students_register_to_course.dart';
import 'package:tutor_app/screens/tutors/tutor_history_of_courses.dart';
import 'package:tutor_app/screens/tutors/tutor_requests.dart';
import 'package:tutor_app/themes.dart';
import 'screens/tutors/tutors_main_screen.dart';
import 'screens/login_screen.dart';
import 'screens/students/students_main_screen.dart';
import 'screens/tutors/tutors_create_course.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: MyThemes.lightTheme,
        darkTheme: MyThemes.darkTheme,
        themeMode: ThemeMode.light,
        home: const FirstScreen(),
        initialRoute: FirstScreen.id,
        routes: {
          FirstScreen.id: (context) => const FirstScreen(),
          RegisterScreen.id: (context) => const RegisterScreen(),
          LoginScreen.id: (context) => const LoginScreen(),
          TutorsMainScreen.id: (context) => TutorsMainScreen(),
          StudentsMainScreen.id: (context) => const StudentsMainScreen(),
          CreateCourse.id: (context) => const CreateCourse(),
          RegisterToCourse.id: (context) => const RegisterToCourse(),
          StudentHistory.id: (context) => const StudentHistory(),
          TutorProfile.id: (context) => const TutorProfile(),
          TutorHistory.id: (context) => const TutorHistory(),
          TutorRequests.id: (context) => const TutorRequests(),
        });
  }
}
