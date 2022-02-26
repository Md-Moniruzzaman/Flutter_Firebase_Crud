import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddUsersPage extends StatefulWidget {
  const AddUsersPage({Key? key}) : super(key: key);

  @override
  _AddUsersPageState createState() => _AddUsersPageState();
}

class _AddUsersPageState extends State<AddUsersPage> {
  String? name;
  String? email;
  String? password;

  final _formkey = GlobalKey<FormState>();

  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference _userCollectionReference =
        FirebaseFirestore.instance.collection('users');

    Future<void> addUser() {
      return _userCollectionReference
          .add({'name': name, 'email': email, 'password': password})
          .then((value) => {
                Fluttertoast.showToast(
                    msg: "User added Successful!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.teal,
                    textColor: Colors.white,
                    fontSize: 16.0)
              })
          .catchError((e) => print('The error is: $e'));
    }

    clearText() {
      nameEditingController.clear();
      emailEditingController.clear();
      passwordcontroller.clear();
    }

    final nameTextfield = TextFormField(
      autofocus: false,
      controller: nameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your name.';
        }
        return null;
      },
      onSaved: (value) {
        nameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          labelText: 'name',
          labelStyle: const TextStyle(fontSize: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          )),
    );

    final emailTextField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your email address';
        } else if (!RegExp('^[a-zA-Z0-9.+-_]+@[a-zA-Z0-9.-_]+.[a-z]')
            .hasMatch(value)) {
          return 'Enter valid email Address';
        }
        return null;
      },
      onSaved: (value) {
        emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email),
        labelText: 'Email Address',
        labelStyle: const TextStyle(
          fontSize: 20.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordcontroller,
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your password';
        } else if (!RegExp(r'^.{6,}$').hasMatch(value)) {
          return 'Enter valid password minimum 6 charecter.';
        }
        return null;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key),
        labelText: 'Password',
        labelStyle: const TextStyle(
          fontSize: 20.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );

    final registerButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(5),
      color: Colors.teal,
      child: MaterialButton(
        // minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
        child: const Text(
          'Register',
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          if (_formkey.currentState!.validate()) {
            name = nameEditingController.text;
            email = emailEditingController.text;
            password = passwordcontroller.text;
            addUser();
            Navigator.pop(context);
            // clearText();
          }
        },
      ),
    );
    final clearTextButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.redAccent,
      child: MaterialButton(
        // minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
        child: const Text(
          'Reset',
          textAlign: TextAlign.center,
        ),
        onPressed: () => clearText(),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('User Data Adding Page'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30.0),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  nameTextfield,
                  SizedBox(
                    height: 10.0,
                  ),
                  emailTextField,
                  SizedBox(
                    height: 10.0,
                  ),
                  passwordField,
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      registerButton,
                      SizedBox(
                        height: 10.0,
                        width: 100,
                      ),
                      clearTextButton
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
