// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_crud/user_screen/update_user_data_page.dart';

class UserListPage extends StatefulWidget {
  // const UserListPage({ Key? key }) : super(key: key);

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final Stream<QuerySnapshot> _userStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  final CollectionReference _userCollectionRrference =
      FirebaseFirestore.instance.collection('users');

  Future<void> deleteUser(id) {
    return _userCollectionRrference
        .doc(id)
        .delete()
        .then((value) => {
              Fluttertoast.showToast(
                  msg: "$id Deleted",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0)
            })
        .catchError((e) => print('The error is: $e'));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _userStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong.'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final List storedoc = [];
          snapshot.data!.docs.map((DocumentSnapshot document) {
            Map data = document.data()! as Map<String, dynamic>;
            storedoc.add(data);
            data['id'] = document.id;
          }).toList();
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Table(
                border: TableBorder.all(),
                columnWidths: const <int, TableColumnWidth>{
                  1: FixedColumnWidth(180),
                  2: FixedColumnWidth(100)
                },
                children: [
                  TableRow(children: [
                    TableCell(
                      child: Container(
                        color: Colors.white,
                        child: const Center(
                          child: Text(
                            'Name',
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.teal,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        color: Colors.white,
                        child: const Center(
                          child: Text(
                            'Email',
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.teal,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        color: Colors.white,
                        child: const Center(
                          child: Text(
                            'Action',
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.teal,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ]),
                  for (var i = 0; i < storedoc.length; i++) ...[
                    TableRow(children: [
                      TableCell(
                        child: Container(
                          margin: EdgeInsets.all(5),
                          color: Colors.white,
                          child: Center(
                            child: Text(
                              // _storedoc[i]['name'],
                              storedoc[i]['name'],
                              style: const TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          margin: EdgeInsets.all(5),
                          color: Colors.white,
                          child: Center(
                            child: Text(
                              storedoc[i]['email'],
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UpdateUserData(id: storedoc[i]['id']),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.orange,
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  deleteUser(storedoc[i]['id']);
                                },
                                icon: const Icon(Icons.delete,
                                    color: Colors.red)),
                          ],
                        ),
                      )
                    ])
                  ],
                ],
              ),
            ),
          );
        });
  }
}
