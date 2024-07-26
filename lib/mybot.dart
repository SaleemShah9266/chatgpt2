import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatBot extends StatefulWidget {
  const ChatBot({Key? key}) : super(key: key);

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  ChatUser myself = ChatUser(id: '1', firstName: 'Saleem');
  ChatUser chatbuddy = ChatUser(id: '2', firstName: 'chatbuddy');

  List<ChatMessage> allMessages = [];
  List<ChatUser> Typing = [];
  final oururl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyA1Bvzn4hFLZ-XYXruTmHDTIqu4FH-asyo';

  final header = {'Content-Type': 'application/json'};

  getdata(ChatMessage m) async {
    Typing.add(chatbuddy);
    allMessages.insert(0, m);
    setState(() {});

    var data = {
      "contents": [
        {
          "parts": [
            {"text": m.text}
          ]
        }
      ]
    };

    await http
        .post(Uri.parse(oururl), headers: header, body: jsonEncode(data))
        .then((value) {
      if (value.statusCode == 200) {
        var result = jsonDecode(value.body);
        print(result['candidates'][0]['content']['parts'][0]['text']);

        ChatMessage m1 = ChatMessage(
            text: result['candidates'][0]['content']['parts'][0]['text'],
            user: chatbuddy,
            createdAt: DateTime.now());

        allMessages.insert(0, m1);
      } else {
        print("error occured");
      }
    }).catchError((e) {});
    Typing.remove(chatbuddy);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: Text(
          "BeCoders.AI",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.brown,
      body: DashChat(
        typingUsers: Typing,
        currentUser: myself,
        onSend: (ChatMessage m) {
          getdata(m);
        },
        messages: allMessages,
      ),
    );
  }
}
