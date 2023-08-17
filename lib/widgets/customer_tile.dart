import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sbdailyreport_app/services/database_service.dart';
import 'package:sbdailyreport_app/widgets/widgets.dart';

import '../pages/customer_info.dart';

class CustomerTile extends StatefulWidget {
  final String userName;
  final String customerId;
  final String customerName;

  const CustomerTile({
    Key? key,
    required this.userName,
    required this.customerId,
    required this.customerName,
  }) : super(key: key);

  @override
  State<CustomerTile> createState() => _CustomerTileState();
}

class _CustomerTileState extends State<CustomerTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreenReplace(
            context,
            CustomerInfo(
              customerId: widget.customerId,
              customerName: widget.customerName,
              admin: widget.userName,
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ListTile(
          tileColor: Theme.of(context).primaryColor.withOpacity(0.1),
          // shape: Border.all(),
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              widget.customerName.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ),
          ),
          title: Text(
            widget.customerName,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
          ),
          subtitle: Text(
            "Admin: ${widget.userName}",
            style: TextStyle(color: Colors.grey[700]),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Delete Customer?",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600)),
                      content: const Text(
                        "Are you sure you want to delete customer? Once deleted it can't be recovered.",
                        style: TextStyle(fontSize: 18),
                      ),
                      actions: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.cancel,
                                color: Colors.red, size: 30)),
                        IconButton(
                            onPressed: () {
                              deleteCustomerList();
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.done,
                              color: Colors.green,
                              size: 30,
                            ))
                      ],
                    );
                  });
            },
          ),
        ),
      ),
    );
  }

  deleteCustomerList() async {
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .deletCustomer(widget.customerId, widget.userName, widget.customerName);
  }
}
