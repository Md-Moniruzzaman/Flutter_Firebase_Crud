import 'package:flutter/material.dart';

import 'add_users_page.dart';
import 'user_list_page.dart';

class Myhomepage extends StatefulWidget {
  // const Myhomepage({ Key? key }) : super(key: key);

  @override
  _MyhomepageState createState() => _MyhomepageState();
}

class _MyhomepageState extends State<Myhomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Flutter Crud', style: TextStyle(fontSize: 25.0)),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddUsersPage(),
                  ),
                );
              },
              child: const Text('Add', style: TextStyle(fontSize: 20.0)),
              style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple,
                  padding: const EdgeInsets.all(20)),
            ),
          ],
        ),
      ),
      body: UserListPage(),
    );
  }
}
