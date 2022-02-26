// ignore_for_file: prefer_const_constructors

// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UpdateUserData extends StatefulWidget {
  final String id;
  const UpdateUserData({Key? key, required this.id}) : super(key: key);

  @override
  _UpdateUserDataState createState() => _UpdateUserDataState();
}

class _UpdateUserDataState extends State<UpdateUserData> {
  final _formkey = GlobalKey<FormState>();

  // final TextEditingController nameEditingController = TextEditingController();
  // final TextEditingController emailEditingController = TextEditingController();
  // final TextEditingController passwordcontroller = TextEditingController();
  // clearText() {
  //   nameEditingController.clear();
  //   emailEditingController.clear();
  //   passwordcontroller.clear();
  // }

  @override
  Widget build(BuildContext context) {
    final CollectionReference _userCollectionRrference =
        FirebaseFirestore.instance.collection('users');

    Future<void> updateUser(id, name, email, password) {
      return _userCollectionRrference
          .doc(id)
          .update({'name': name, 'email': email, 'password': password})
          .then((value) => {
                Fluttertoast.showToast(
                    msg: "Update Successful!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.teal,
                    textColor: Colors.white,
                    fontSize: 16.0)
              })
          .catchError((e) => print('The error is: $e'));
    }

    final clearTextButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.redAccent,
      child: MaterialButton(
        // minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
        child: Text(
          'Clear',
          textAlign: TextAlign.center,
        ),
        onPressed: () {},
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Update User Data'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30.0),
            child: Form(
              key: _formkey,
              // Getting spacific data by id
              child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance
                      .collection('ueers')
                      .doc(widget.id)
                      .get(),
                  builder: (_, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Somethig went wrong.');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    var data = snapshot.data!.data();
                    var name = data?['name'];
                    var email = data?['email'];
                    var password = data?['password'];

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          initialValue: "name",
                          autofocus: false,
                          // controller: nameEditingController,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name.';
                            }
                            return null;
                          },
                          onChanged: (value) => name = value,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.account_circle),
                              labelText: 'name',
                              labelStyle: TextStyle(fontSize: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              )),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          initialValue: 'email',
                          autofocus: false,
                          // controller: emailEditingController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email address';
                            } else if (!RegExp(
                                    '^[a-zA-Z0-9.+-_]+@[a-zA-Z0-9.-_]+.[a-z]')
                                .hasMatch(value)) {
                              return 'Enter valid email Address';
                            }
                            return null;
                          },
                          onChanged: (value) => email = value,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            labelText: 'Email Address',
                            labelStyle: TextStyle(
                              fontSize: 20.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          initialValue: 'password',
                          autofocus: false,
                          // controller: passwordcontroller,
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your password';
                            } else if (!RegExp(r'^.{6,}$').hasMatch(value)) {
                              return 'Enter valid password minimum 6 charecter.';
                            }
                            return null;
                          },
                          onChanged: (value) => password = value,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.vpn_key),
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontSize: 20.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.teal,
                              child: MaterialButton(
                                // minWidth: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
                                child: Text(
                                  'Update',
                                  textAlign: TextAlign.center,
                                ),
                                onPressed: () {
                                  if (_formkey.currentState!.validate()) {
                                    updateUser(
                                        widget.id, name, email, password);
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                              width: 100,
                            ),
                            clearTextButton
                          ],
                        ),
                      ],
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
