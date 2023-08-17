// import 'dart:html';
// import 'dart:io';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // reference for collection

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference customerCollection =
      FirebaseFirestore.instance.collection("customers");
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  // saving user data
  Future savingUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "projects": [],
      "customers": [],
      "profilePic": "",
      "uid": uid,
    });
  }

  // geting user data

  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  Future createCustomer(
    String userName,
    String id,
    String customerName,
    DateTime date,
    String priority,
    String conditionFound,
    String repairSolution,
    String attachPhotos,
    String images,
  ) async {
    DocumentReference customerDocumentReference = await customerCollection.add({
      "admin": "${id}_$userName",
      "customerName": customerName,
      "date": date,
      "priority": priority,
      "conditionFound": conditionFound,
      "repairSolution": repairSolution,
      "attachPhotos": attachPhotos,
      "customerId": "",
      "images": images,
    });

// update customer Id
    await customerDocumentReference.update({
      "customerId": customerDocumentReference.id,
    });

    DocumentReference userDocumentRefrence = userCollection.doc(uid);
    return await userDocumentRefrence.update({
      "customers": FieldValue.arrayUnion(
          ["${customerDocumentReference.id}_$customerName"])
    });
  }

  getUserCustomers(uid) async {
    return userCollection.doc(uid).snapshots();
  }

  getAdminCustomersList() async {
    return customerCollection.doc().snapshots();
  }

  // Future getCustomerInfoDb(String customerId) async {
  //   QuerySnapshot snapshot = await customerCollection
  //       .where("customerId", isEqualTo: customerId)
  //       .get();
  //   return snapshot;
  // }

  Future getCustDate(String customerId) async {
    DocumentReference d = customerCollection.doc(customerId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot["date"];
  }

  Future getCustPriority(String customerId) async {
    DocumentReference d = customerCollection.doc(customerId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot["priority"];
  }

  Future getCustConditionFound(String customerId) async {
    DocumentReference d = customerCollection.doc(customerId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot["conditionFound"];
  }

  Future getCustRepairSolution(String customerId) async {
    DocumentReference d = customerCollection.doc(customerId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot["repairSolution"];
  }

  Future getCustAttachPhotos(String customerId) async {
    DocumentReference d = customerCollection.doc(customerId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot["attachPhotos"];
  }

  Future getCustImages(String customerId) async {
    DocumentReference d = customerCollection.doc(customerId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot["images"];
  }

  Future deletCustomer(
      String customerId, String userName, String customerName) async {
    DocumentReference userDocumentRefrence = userCollection.doc(uid);
    DocumentReference customerDocumentRefrence =
        customerCollection.doc(customerId);

    DocumentSnapshot documentSnapshot = await userDocumentRefrence.get();
    List<dynamic> customers = await documentSnapshot['customers'];

    if (customers.contains("${customerId}_$customerName")) {
      await userDocumentRefrence.update({
        "customers": FieldValue.arrayRemove(["${customerId}_$customerName"])
      });

      await customerDocumentRefrence.update({
        customerId: FirebaseFirestore.instance
            .collection("customers")
            .doc(customerId)
            .delete()
      });
    }
  }

  getCustInfoDb(customerId) async {
    return customerCollection.where("customerId", isEqualTo: customerId).get();
  }

  // Future updateCustomer(
  //     String admin,
  //     String customerId,
  //     String customerName,
  //     String id,
  //     DateTime date,
  //     String priority,
  //     String conditionFound,
  //     String repairSolution,
  //     String attachPhotos) async {
  //   DocumentReference customerDocumentReference = customerCollection.doc(id);
  //   await customerDocumentReference.update({
  //     "admin": admin,
  //     "customerId": customerId,
  //     "customerName": customerName,
  //     "date": date,
  //     "priority": priority,
  //     "conditionFound": conditionFound,
  //     "repairSolution": repairSolution,
  //     "attachPhotos": attachPhotos,
  //   });
  // }

  Future updateCustomer(
      id, priority, conditionFound, repairSolution, images) async {
    DocumentReference customerDocumentRefrence = customerCollection.doc(id);
    await customerDocumentRefrence.update({
      'priority': priority,
      'conditionFound': conditionFound,
      'repairSolution': repairSolution,
      'images': images,
    });
  }

  //uploading file image

  // Future<void> uploadFile(
  //   String filePath,
  //   String fileName,
  // ) async {
  //   File file = File(filePath);
  //   try {
  //     await firebaseStorage.ref("customerImages/$uid/$fileName").putFile(file);
  //   } on FirebaseException catch (e) {
  //     print(e);
  //   }
  // }

  // Future<ListResult> listFiles() async {
  //   FirebaseStorage storage = FirebaseStorage.instance;
  //   ListResult results = await storage.ref("customerImages/$uid").listAll();
  //   results.items.forEach((Reference ref) {
  //     print("Found file: $ref");
  //   });
  //   return results;
  // }

  Future<String> storeFileToStorage(String ref, File file) async {
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }
}
