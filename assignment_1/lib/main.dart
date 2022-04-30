import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  String _text = 'This is some text';

  void changeText() {
    print("You pressed the button.");
    if (_text == 'This is some text') {
      setState(() {
        _text = 'Wow, I changed!';
      });
    } else {
      setState(() {
        _text = 'This is some text';
      });
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assignment 1',
      home: Scaffold(
        appBar: AppBar(title: const Text('Assignment 1')),
        body: Column(
          children: [TextOutput(_text), TextControl(changeText)],
        ),
      ),
    );
  }
}

class TextControl extends StatelessWidget {
  final Function changeTextHandler;

  const TextControl(this.changeTextHandler);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: changeTextHandler,
      child: const Text('Press me!'),
    );
  }
}

class TextOutput extends StatelessWidget {
  final String text;

  const TextOutput(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }
}
