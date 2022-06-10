import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:tutor_app/screens/tutors/widgets/Button_widget.dart';
import 'package:tutor_app/screens/tutors/widgets/Profile_widget.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../auth_info.dart';

class TutorProfile extends StatefulWidget {
  static const id = 'tutor-profile';

  const TutorProfile({Key? key}) : super(key: key);

  @override
  _TutorProfileState createState() => _TutorProfileState();
}

class _TutorProfileState extends State<TutorProfile> {
  FirebaseStorage storage = FirebaseStorage.instance;
  String description = '';
  String name = '';
  String userType = 'null';
  String myFileUrl =
      "https://w7.pngwing.com/pngs/753/432/png-transparent-user-profile-2018-in-sight-user-conference-expo-business-default-business-angle-service-people.png";
  late Reference myFile;
  double rating = 0.0;

  @override
  initState() {
    super.initState();
    _loadImages();
    _getRating();
  }

  Future<void> _upload(String inputSource) async {
    final picker = ImagePicker();
    XFile? pickedImage;
    try {
      pickedImage = await picker.pickImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          maxWidth: 1920);

      late File imageFile;
      setState(() {
        imageFile = File(pickedImage!.path);
      });

      try {
        // Uploading the selected image with some custom meta data
        await storage.ref(authEmail).putFile(
            imageFile,
            SettableMetadata(customMetadata: {
              'uploaded_by': 'tutor-user',
              'description': 'Some description...'
            }));

        // Refresh the UI
        setState(() {});
      } on FirebaseException catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
    _loadImages();
  }

  void _loadImages() async {
    myFileUrl = 'https://w7.pngwing.com/pngs/753/432/png-transparent-user-profile-2018-in-sight-user-conference-expo-business-default-business-angle-service-people.png';
    final ListResult result = await storage.ref().list();
    final List<Reference> allFiles = result.items;

    myFile = storage.ref(
        'png-transparent-user-profile-2018-in-sight-user-conference-expo-business-default-business-angle-service-people.png');
    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      if (file.fullPath == authEmail) {
        setState(() {
          myFile = file;
          myFileUrl = fileUrl;
        });
      }
    });
  }

  void _getRating() async {
    var info = await FirebaseFirestore.instance
        .collection('ratings')
        .where('tutor', isEqualTo: authEmail)
        .get();

    double sum = 0;
    var ratingData = info.docs;

    for(int i=0;i<ratingData.length;i++) {
      double number = ratingData[i]['rating'];
      sum += number;
    }

    setState(() {
      rating = (sum/(ratingData.length));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tutor\'s Profile')),
      body: Padding(
        padding: const EdgeInsets.only(top: 26.0),
        child: Column(
            children: [
              ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                //physics: NeverScrollableScrollPhysics(),
                children: [
                  ProfileWidget(
                    imagePath: myFileUrl,
                    onClicked: () async {
                      setState(() {
                        _upload('gallery');
                        if (myFileUrl == '') {
                          myFileUrl =
                          "https://w7.pngwing.com/pngs/753/432/png-transparent-user-profile-2018-in-sight-user-conference-expo-business-default-business-angle-service-people.png";
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0),
                    child: TextFormField(
                      onChanged: (value) {
                        name = value;
                      },
                      minLines: 1,
                      maxLines: 2,
                      decoration: const InputDecoration(
                          labelText: 'Name', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(height: 24),
                  MaterialButton(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    onPressed: () {},
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          rating.toStringAsPrecision(2),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Rating',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(child: buildUpgradeButton()),
                ],
              ),
            ]
        ),
      ),
    );
  }

  Widget buildUpgradeButton() => ButtonWidget(
    text: 'Save profile',
    onClicked: () async {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore
          .collection('TutorProfile')
          .doc(authEmail)
          .set({
        'name': name,
        'email': authEmail,
        'rating': rating > 0 ? rating : 0
      });
    },
  );
}


