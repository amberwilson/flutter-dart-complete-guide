import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chats/SmJIvPjMsCfl6jNMlJ5w/messages')
              .snapshots(),
          builder: (ctx, AsyncSnapshot streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final docs = streamSnapshot.data.docs;

            return ListView.builder(
              itemCount: streamSnapshot.data.docs.length,
              itemBuilder: (ctx, index) => Container(
                padding: const EdgeInsets.all(8),
                child: Text(docs[index]['text']),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chats/SmJIvPjMsCfl6jNMlJ5w/messages')
              .add({'text': 'a new message'});
        },
      ),
    );
  }
}
