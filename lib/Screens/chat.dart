import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("chat page"),
          centerTitle: true,
        ),
        body: Center(
          child: Text('Welcome to chat page'),
        ),
      ),
    );
  }
}
