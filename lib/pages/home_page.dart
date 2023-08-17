import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sbdailyreport_app/helpers/helper_functions.dart';
import 'package:sbdailyreport_app/services/auth_service.dart';
import 'package:sbdailyreport_app/services/database_service.dart';
import 'package:sbdailyreport_app/widgets/customer_tile.dart';

import 'package:sbdailyreport_app/widgets/drawer.dart';
import 'package:sbdailyreport_app/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "";
  String email = "";
  String customerName = "";
  DateTime date = DateTime.now();
  String priority = "";
  String conditionFound = "";
  String repairSolution = "";
  String attachPhotos = "";
  bool _isLoading = false;
  AuthService authService = AuthService();
  Stream? customers;
  String imageUrl = "";
  // List<String> list = <String>[
  //   'HIGH',
  //   'MEDIUM',
  //   'LOW',
  // ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf('_') + 1);
  }

  gettingUserData() async {
    await HelperFunctions.getUserNameSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    await HelperFunctions.getUSerEmailSF().then((value) {
      setState(() {
        email = value!;
      });
    });
// getting list of snapshot in our stream

    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserCustomers(FirebaseAuth.instance.currentUser!.uid)
        .then((snapshot) {
      setState(() {
        customers = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text("Daily Report App"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      drawer: const MyDrawer(),
      body:
          // Text("Home"),
          customerList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  customerList() {
    return StreamBuilder(
      stream: customers,
      builder: (context, AsyncSnapshot snapshot) {
        // make some checks
        if (snapshot.hasData) {
          if (snapshot.data['customers'] != null) {
            if (snapshot.data['customers'].length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data['customers'].length,
                  itemBuilder: (context, index) {
                    int reverseIndex =
                        snapshot.data['customers'].length - index - 1;
                    return CustomerTile(
                      userName: snapshot.data['fullName'],
                      customerId:
                          getId(snapshot.data['customers'][reverseIndex]),
                      customerName:
                          getName(snapshot.data['customers'][reverseIndex]),
                    );
                  });
            } else {
              return noCustomerWidget();
            }
          } else {
            return noCustomerWidget();
          }
        } else {
          return const Center(child: Text("Central Progress")
              // CircularProgressIndicator(
              //     color: Theme.of(context).primaryColor),
              );
        }
      },
    );
  }

  noCustomerWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                popUpDialog(context);
              },
              child: Icon(
                Icons.add_circle,
                color: Colors.grey[700],
                size: 60,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "You don't have any customers, tap on the add icon to create a customer or also search from top search button",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ]),
    );
  }

  popUpDialog(BuildContext context) {
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
          "Add Customer",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          _isLoading == true
              ? Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : TextField(
                  onChanged: (value) {
                    setState(() {
                      customerName = value;
                    });
                  },
                  decoration: textInputDecoration.copyWith(
                      prefix: Icon(
                        Icons.person,
                        color: Theme.of(context).primaryColor,
                      ),
                      hintText: "Customer Name",
                      hintStyle: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500))),
          const SizedBox(
            height: 20,
          ),

          // Row(
          //   children: [
          //     Text(
          //       "Priority",
          //       style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          //     ),
          //     SizedBox(
          //       width: 20,
          //     ),

          //     DropdownButton<String>(
          //       hint: Text("Priority"),
          //       iconSize: 50,
          //       isExpanded: true,
          //       style: TextStyle(
          //           color: Colors.black,
          //           fontSize: 20,
          //           fontWeight: FontWeight.w500),
          //       value: dropdownValue,
          //       onChanged: (String? value) {
          //         // This is called when the user selects an item.
          //         setState(() {
          //           dropdownValue = value!;
          //           priority = dropdownValue;
          //         });
          //       },
          //       items: list.map<DropdownMenuItem<String>>((String value) {
          //         return DropdownMenuItem<String>(
          //           value: value,
          //           child: Text(value),
          //         );
          //       }).toList(),
          //     ),

          //     // PriorityDropdownButton(),
          //   ],
          // ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Select Priority:',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
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
                              color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                      );
                    }).toList();
                  },
                  items: list.map<DropdownMenuItem<String>>((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),

          // DropdownButton<String>(
          //   hint: Text("Priority"),
          //   iconSize: 50,
          //   isExpanded: true,
          //   style: TextStyle(
          //       color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          //   value: dropdownValue,
          //   onChanged: (String? value) {
          //     // This is called when the user selects an item.
          //     setState(() {
          //       dropdownValue = value!;
          //       priority = dropdownValue;
          //     });
          //   },
          //   items: list.map<DropdownMenuItem<String>>((String value) {
          //     return DropdownMenuItem<String>(
          //       value: value,
          //       child: Text(value),
          //     );
          //   }).toList(),
          // ),

          // ElevatedButton(
          //     onPressed: () async {
          //       DateTime? newDate = await showDatePicker(
          //           context: context,
          //           initialDate: date,
          //           firstDate: DateTime(2000),
          //           lastDate: DateTime(2040));
          //       if (newDate == null) return;
          //       setState(() {
          //         date = newDate;
          //       });
          //     },
          //     child: Text("date")),
          // // Text(
          //     onChanged: (value) {
          //       if (value != null) {
          //         setState(() {
          //           date = value;
          //         });
          //       }
          //     },
          //     decoration: textInputDecoration.copyWith(
          //         prefix: Icon(
          //           Icons.person,
          //           color: Theme.of(context).primaryColor,
          //         ),
          //         hintText: "Date",
          //         hintStyle:
          //             TextStyle(fontSize: 20, fontWeight: FontWeight.w500))),
          const SizedBox(
            height: 20,
          ),
          TextField(
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
                  hintText: "Condition Found",
                  hintStyle:
                      const TextStyle(fontSize: 20, fontWeight: FontWeight.w500))),
          const SizedBox(
            height: 20,
          ),
          TextField(
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
                  hintText: "Repair/ Solution",
                  hintStyle:
                      const TextStyle(fontSize: 20, fontWeight: FontWeight.w500))),
          const SizedBox(
            height: 20,
          ),

          TextField(
              onChanged: (value) {
                setState(() {
                  attachPhotos = value;
                });
              },
              decoration: textInputDecoration.copyWith(
                  prefix: Icon(
                    Icons.person,
                    color: Theme.of(context).primaryColor,
                  ),
                  hintText: "Department",
                  hintStyle:
                      const TextStyle(fontSize: 20, fontWeight: FontWeight.w500))),

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
          //       final path = results.files.single.path;
          //       final fileName = results.files.single.name;
          //       DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          //           .uploadFile(path!, fileName)
          //           .then((value) => print("Done"));
          //     },
          //     child: Text("Upload Image")),
          IconButton(
              onPressed: () async {
                ImagePicker imagePicker = ImagePicker();
                XFile? file =
                    await imagePicker.pickImage(source: ImageSource.gallery);
                if (file == null) {
                  return print("No file uploaded");
                } else {
                  String uniqueFileName =
                      DateTime.now().millisecondsSinceEpoch.toString();
                  Reference referenceRoot = FirebaseStorage.instance.ref();
                  Reference referenceDirImages =
                      referenceRoot.child('images/$customerName/');
                  Reference referenceImageToUpload =
                      referenceDirImages.child(uniqueFileName);

                  try {
                    await referenceImageToUpload.putFile(File(file.path));
                    imageUrl = await referenceImageToUpload.getDownloadURL();
                  } catch (e) {
                    return print(e.toString());
                  }
                }
              },
              icon: const Icon(Icons.camera_alt))
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

                DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                    .createCustomer(
                        userName,
                        FirebaseAuth.instance.currentUser!.uid,
                        customerName,
                        date,
                        priority,
                        conditionFound,
                        repairSolution,
                        attachPhotos,
                        imageUrl)
                    .whenComplete(() {
                  _isLoading = false;
                });
                Navigator.of(context).pop();
                showSnackBar(
                    context, Colors.green, "New customer has been created");
              },
              child: Text(
                "CREATE",
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

// class PriorityDropdownButton extends StatefulWidget {
//   const PriorityDropdownButton({super.key});

//   @override
//   State<PriorityDropdownButton> createState() => _PriorityDropdownButtonState();
// }

// class _PriorityDropdownButtonState extends State<PriorityDropdownButton> {
//   List<String> list = <String>[
//     'HIGH',
//     'MEDIUM',
//     'LOW',
//   ];

//   String priority = "";

//   @override
//   Widget build(BuildContext context) {
//     String dropdownValue = list.first;
//     return DropdownButton<String>(
//       value: dropdownValue,
//       icon: const Icon(Icons.arrow_downward),
//       elevation: 16,
//       style: const TextStyle(color: Colors.black),
//       underline: Container(
//         height: 2,
//         color: Colors.black,
//       ),
//       onChanged: (String? value) {
//         // This is called when the user selects an item.
//         setState(() {
//           dropdownValue = value!;
//           priority = dropdownValue;
//         });
//       },
//       items: list.map<DropdownMenuItem<String>>((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//     );
//   }
// }
