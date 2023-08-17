import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sbdailyreport_app/pages/customer_info.dart';


class AllCustomers extends StatefulWidget {
  const AllCustomers({super.key});

  @override
  State<AllCustomers> createState() => _AllCustomersState();
}

class _AllCustomersState extends State<AllCustomers> {
  Stream? customers;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // gettingAllCustomers();
  }

  String getName(String res) {
    return res.substring(res.indexOf('_') + 1);
  }

  // gettingAllCustomers() async {
  //   await DatabaseService().getAdminCustomersList().then((snapshot) {
  //     setState(() {
  //       customers = snapshot;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Customers"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: AllCustomerList(),
    );
  }

  AllCustomerList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('customers').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // make some checks
        if (snapshot.hasData) {
          {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CustomerInfo(
                              customerId: snapshot.data!.docs[index]
                                  ['customerId'],
                              customerName: snapshot.data!.docs[index]
                                  ['customerName'],
                              admin: getName(
                                  snapshot.data!.docs[index]['admin']))));
                    },
                    child: Container(
                      margin:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      width: 200,
                      height: 100,
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      child: Column(
                        children: [
                          Text("Customer Name: " +
                              snapshot.data!.docs[index]['customerName']),
                          Text("Customer Admin: ${getName(snapshot.data!.docs[index]['admin'])}"),
                          Text("Priority: " +
                              snapshot.data!.docs[index]['priority']),
                        ],
                      ),
                    ),
                  );
                });
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
    return const Center(
      child: Text("No Customer"),
    );
  }
}
