import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (ctx, index) => Container(
          padding: const EdgeInsets.all(8),
          child: const Text('this works!'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          var messages = FirebaseFirestore.instance
              .collection('chats/SmJIvPjMsCfl6jNMlJ5w/messages')
              .snapshots()
              .listen((data) {
            data.docs.forEach((element) {
              print(element.data());
            });
          });
        },
      ),
    );
  }
}
