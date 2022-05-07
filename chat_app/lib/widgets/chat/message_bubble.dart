import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String username;
  final String userImage;
  final bool isMe;

  const MessageBubble(this.message, this.isMe, this.username, this.userImage,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: isMe
                      ? const Radius.circular(12)
                      : const Radius.circular(0),
                  bottomRight: isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                ),
                color: isMe
                    ? Colors.grey[300]
                    : Theme.of(context).colorScheme.secondary,
              ),
              width: 140,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(username,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isMe
                              ? Colors.black
                              : Theme.of(context).colorScheme.onSecondary)),
                  Text(message,
                      textAlign: isMe ? TextAlign.end : TextAlign.start,
                      style: TextStyle(
                          color: isMe
                              ? Colors.black
                              : Theme.of(context).colorScheme.onSecondary)),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          left: isMe ? null : 120,
          right: isMe ? 120 : null,
          child: CircleAvatar(backgroundImage: NetworkImage(userImage)),
        )
      ],
      clipBehavior: Clip.none,
    );
  }
}
