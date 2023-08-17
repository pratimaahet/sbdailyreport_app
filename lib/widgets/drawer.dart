import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:sbdailyreport_app/helpers/helper_functions.dart';
import 'package:sbdailyreport_app/pages/allcustomer_page.dart';
import 'package:sbdailyreport_app/pages/auth/login_page.dart';
import 'package:sbdailyreport_app/pages/home_page.dart';
import 'package:sbdailyreport_app/services/auth_service.dart';
import 'package:sbdailyreport_app/services/database_service.dart';
import 'package:sbdailyreport_app/pages/meetings/meetings_page.dart';
import 'dart:io';

import 'package:sbdailyreport_app/widgets/widgets.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String profilePic = "";
  File? image;
  String email = "";
  String userName = "";
  String imageUrl = "";
  bool _isLoading = false;
  AuthService authService = AuthService();

  // void selectImage() async {
  //   final image = await ImagePicker().pickImage(
  //     source: ImageSource.gallery,
  //   );

  //   Reference ref =
  //       FirebaseStorage.instance.ref().child("profilePic/${DateTime.now()}");
  //   await ref.putFile(File(image!.path));
  //   ref.getDownloadURL().then((value) async {
  //     // print(value);
  //     setState(() {
  //       imageUrl = value;
  //     });
  //   });
  // }

  void selectImage() async {
    image = await pickImage(context);
    _isLoading = true;

    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .storeFileToStorage("profilePic/${DateTime.now()}", image!)
        .whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunctions.getUSerEmailSF().then((value) {
      if (value != null) {
        setState(() {
          email = value;
        });
      }
    });

    await HelperFunctions.getUserNameSF().then((value) {
      if (value != null) {
        setState(() {
          userName = value;
        });
      }
    });
  }

  // for selecting image

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
          // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            InkWell(
              onTap: () => selectImage(),
              child: image == null
                  ? const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 50,
                      child: Icon(
                        Icons.account_circle,
                        size: 100,
                        color: Colors.brown,
                      ),
                    )
                  : CircleAvatar(
                      backgroundImage: FileImage(image!),
                      radius: 50,
                      // child: Image.network(
                      //   imageUrl,
                      //   width: 100,
                      //   height: 100,

                      // ),
                      // backgroundImage: Image.network(imageUrl),
                      // radius: 50,
                    ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              userName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              email,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Divider(
              height: 1.0,
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                color: Theme.of(context).primaryColor,
                size: 35,
              ),
              title: TextButton(
                  style: const ButtonStyle(alignment: Alignment.centerLeft),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const HomePage()));
                  },
                  child: const Text(
                    "HOME",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                color: Theme.of(context).primaryColor,
                size: 35,
              ),
              title: TextButton(
                  style: const ButtonStyle(alignment: Alignment.centerLeft),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AllCustomers()));
                  },
                  child: const Text(
                    "All Customers",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                color: Theme.of(context).primaryColor,
                size: 35,
              ),
              title: TextButton(
                  style: const ButtonStyle(alignment: Alignment.centerLeft),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AllCustomers()));
                  },
                  child: const Text(
                    "All Users",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                color: Theme.of(context).primaryColor,
                size: 35,
              ),
              title: TextButton(
                  style: const ButtonStyle(alignment: Alignment.centerLeft),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const MeetingsPage()));
                  },
                  child: const Text(
                    "Meetings",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Theme.of(context).primaryColor,
                size: 35,
              ),
              title: TextButton(
                  style: const ButtonStyle(alignment: Alignment.centerLeft),
                  onPressed: () async {
                    return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("LOGOUT"),
                            content: const Text(
                              "Are you sure you want ot logout?",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 18),
                            ),
                            actions: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.cancel,
                                    size: 30,
                                    color: Colors.red,
                                  )),
                              const SizedBox(
                                width: 20,
                              ),
                              IconButton(
                                  onPressed: () async {
                                    await authService.signout();
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage()),
                                        (route) => false);
                                  },
                                  icon: const Icon(
                                    Icons.done,
                                    size: 30,
                                    color: Colors.green,
                                  ))
                            ],
                          );
                        });
                  },
                  child: const Text(
                    "LOGOUT",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  )),
            ),
          ]),
    );
  }
}
