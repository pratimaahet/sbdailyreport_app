import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sbdailyreport_app/pages/home_page.dart';
import 'package:sbdailyreport_app/widgets/widgets.dart';

import '../services/auth_service.dart';
import '../services/database_service.dart';
import 'image_detail.dart';

class CustomerInfo extends StatefulWidget {
  final String customerId;
  final String customerName;
  final String admin;

  const CustomerInfo(
      {Key? key,
      required this.customerId,
      required this.customerName,
      required this.admin})
      : super(key: key);

  @override
  State<CustomerInfo> createState() => _CustomerInfoState();
}

class _CustomerInfoState extends State<CustomerInfo> {
  String userName = "";
  // String date = "";
  DateTime date = DateTime.now();
  String priority = "";
  String conditionFound = "";
  String repairSolution = "";
  String attachPhotos = "";
  String customerName = "";
  String images = "";

  bool _isLoading = false;
  AuthService authService = AuthService();

  TextEditingController conditionFoundController = TextEditingController();
  TextEditingController repairSolutionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    getCustomerInfo();
    super.initState();
  }

  getCustomerInfo() async {
    // DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
    //     .getCustDate(widget.customerId)
    //     .then((snapshot) {
    //   setState(() {
    //     date = snapshot;
    //   });
    // });
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getCustPriority(widget.customerId)
        .then((snapshot) {
      setState(() {
        priority = snapshot;
      });
    });

    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getCustConditionFound(widget.customerId)
        .then((snapshot) {
      setState(() {
        conditionFound = snapshot;
        conditionFoundController = TextEditingController(text: snapshot);
      });
    });

    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getCustRepairSolution(widget.customerId)
        .then((snapshot) {
      setState(() {
        repairSolution = snapshot;
        repairSolutionController = TextEditingController(text: snapshot);
      });
    });

    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getCustAttachPhotos(widget.customerId)
        .then((snapshot) {
      setState(() {
        attachPhotos = snapshot;
      });
    });

    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getCustImages(widget.customerId)
        .then((snapshot) {
      setState(() {
        images = snapshot;
      });
    });
  }

  String imageUrl = "";

  @override
  Widget build(BuildContext context) {
    String conditionFoundController = conditionFound;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            nextScreen(context, const HomePage());
          },
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(widget.customerName),
        actions: [
          Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              width: 55,
              // height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white.withOpacity(0.1),
              ),
              child: IconButton(
                  onPressed: () {
                    editpopUpDialog(context);
                  },
                  icon: const Icon(Icons.edit)))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).primaryColor.withOpacity(0.1)),
                  child: RichText(
                      text: TextSpan(children: [
                    const TextSpan(
                        text: "Customer ID:  ",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    TextSpan(
                        text: widget.customerId,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                  ])),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).primaryColor.withOpacity(0.1)),
                  child: RichText(
                      text: TextSpan(children: [
                    const TextSpan(
                        text: "Customer Name:  ",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    TextSpan(
                        text: widget.customerName,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                  ])),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).primaryColor.withOpacity(0.1)),
                  child: RichText(
                      text: TextSpan(children: [
                    const TextSpan(
                        text: "Priority:  ",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    TextSpan(
                        text: priority,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                  ])),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).primaryColor.withOpacity(0.1)),
                  child: RichText(
                      text: TextSpan(children: [
                    const TextSpan(
                        text: "Condition Found:  ",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    TextSpan(
                        text: conditionFound,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                  ])),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).primaryColor.withOpacity(0.1)),
                  child: RichText(
                      text: TextSpan(children: [
                    const TextSpan(
                        text: "Repair/ Solution:  ",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    TextSpan(
                        text: repairSolution,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                  ])),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).primaryColor.withOpacity(0.1)),
                  child: RichText(
                      text: TextSpan(children: [
                    const TextSpan(
                        text: "Department:  ",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    TextSpan(
                        text: attachPhotos,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                  ])),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).primaryColor.withOpacity(0.1)),
                  child: RichText(
                      text: const TextSpan(children: [
                    TextSpan(
                        text: "Photos:  ",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ])),
                ),
                // Container(
                //   // alignment: Alignment.center,
                //   height: 150,
                //   width: MediaQuery.of(context).size.width,
                //   padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                //   child: Image.network(
                //     images,
                //     alignment: Alignment.center,
                //   ),
                // ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: GestureDetector(
                    child: Hero(
                      tag: 'imageHero',
                      child: Image.network(
                        images,
                        height: 200,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                    images: images,
                                  )));
                    },
                  ),
                )
              ]),
        ),
      ),
    );
  }

  // custImages() {
  // FutureBuilder(
  //   future: DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
  //       .listFiles(),
  //   builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
  //     if (snapshot.connectionState == ConnectionState.done &&
  //         snapshot.hasData) {
  //       return Container(
  //           height: 100,
  //           child: ListView.builder(
  //               scrollDirection: Axis.horizontal,
  //               shrinkWrap: true,
  //               itemCount: snapshot.data!.items.length,
  //               itemBuilder: (BuildContext context, int index) {
  //                 return ElevatedButton(
  //                     onPressed: () {},
  //                     child: Text(snapshot.data!.items[index].name));
  //               }));
  //     }
  //     if (snapshot.connectionState == ConnectionState.waiting ||
  //         !snapshot.hasData) {
  //       return CircularProgressIndicator();
  //     }
  //     return Container();
  //   },
  // );
  // }

  editpopUpDialog(BuildContext context) {
    const List<String> list = <String>[
      'HIGH',
      'MEDIUM',
      'LOW',
    ];
    String dropdownValue = list.first;
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          "Update Customer Info",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          _isLoading == true
              ? Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                )

              // : DropdownButton<String>(
              //     // hint: Text("Priority"),
              //     iconSize: 50,
              //     isExpanded: true,
              //     style: TextStyle(
              //         color: Colors.black,
              //         fontSize: 20,
              //         fontWeight: FontWeight.w500),
              //     value: dropdownValue,
              //     onChanged: (String? value) {
              //       // This is called when the user selects an item.
              //       setState(() {
              //         dropdownValue = value!;
              //         priority = dropdownValue;
              //       });
              //     },

              //     items: list.map<DropdownMenuItem<String>>((String value) {
              //       return DropdownMenuItem<String>(
              //         value: value,
              //         child: Text(value),
              //       );
              //     }).toList(),
              //   ),

              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Select Priority:',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            dropdownValue = value!;
                            priority = dropdownValue;
                          });
                        },
                        selectedItemBuilder: (BuildContext context) {
                          return list.map<Widget>((String item) {
                            return Container(
                              alignment: Alignment.centerLeft,
                              constraints: const BoxConstraints(minWidth: 100),
                              child: Text(
                                item,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            );
                          }).toList();
                        },
                        items:
                            list.map<DropdownMenuItem<String>>((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              controller: conditionFoundController,
              onChanged: (value) {
                setState(() {
                  conditionFound = value;
                });
              },
              decoration: textInputDecoration.copyWith(
                prefix: Icon(
                  Icons.person,
                  color: Theme.of(context).primaryColor,
                ),
              )),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              controller: repairSolutionController,
              onChanged: (value) {
                setState(() {
                  repairSolution = value;
                });
              },
              decoration: textInputDecoration.copyWith(
                prefix: Icon(
                  Icons.person,
                  color: Theme.of(context).primaryColor,
                ),
              )),
          const SizedBox(
            height: 20,
          ),
          // ElevatedButton(
          //     onPressed: () async {
          //       final results = await FilePicker.platform.pickFiles(
          //         allowMultiple: false,
          //         type: FileType.custom,
          //         allowedExtensions: ['png', 'jpg', 'jpeg'],
          //       );
          //       if (results == null) {
          //         ScaffoldMessenger.of(context).showSnackBar(
          //             const SnackBar(content: Text("No file uploaded")));
          //         return null;
          //       }
          //       final path = results.files.single.path!;
          //       final fileName = results.files.single.name;

          //       print(path);
          //       print(fileName);
          //     },
          //     child: Text("Upload Image")),

          IconButton(
              onPressed: () async {
                ImagePicker imagePicker = ImagePicker();
                XFile? file =
                    await imagePicker.pickImage(source: ImageSource.gallery);
                // print('$file?.path');
                if (file == null) {
                  return print('No image updated');
                } else {
                  Reference referenceImageToUpload =
                      FirebaseStorage.instance.refFromURL(images);
                  try {
                    // Store the file
                    await referenceImageToUpload.putFile(File(file.path));

// Sucess: get the download URL
                    images = await referenceImageToUpload.getDownloadURL();
                  } catch (e) {
                    // some error occurred
                  }
                }
              },
              icon: const Icon(Icons.camera_alt)),
          const SizedBox(
            height: 20,
          ),
        ]),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "CANCEL",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              )),
          TextButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                await DatabaseService(
                        uid: FirebaseAuth.instance.currentUser!.uid)
                    .updateCustomer(widget.customerId, priority,
                        conditionFound, repairSolution, images)
                    .whenComplete(() {
                  _isLoading = false;
                });

                Navigator.of(context).pop();
                showSnackBar(
                    context, Colors.green, "Customer has been updated");
              },
              child: Text(
                "UPDATE",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              )),
        ],
      ),
      barrierDismissible: true,
    );
  }
}
