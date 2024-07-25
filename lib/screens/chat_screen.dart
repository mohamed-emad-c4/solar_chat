import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:scholar_chat/main.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

final storage = FirebaseStorage.instance;
CollectionReference messages = FirebaseFirestore.instance.collection('users');

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(darkmode ? Icons.light_mode : Icons.dark_mode),
          onPressed: () {
            darkmode = !darkmode;
            setState(() {});
          },
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat),
            SizedBox(width: 10.0),
            Text(
              'Chat',
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
              itemBuilder: (context, index) => const BobalCat(), itemCount: 23),
        ),
        TextField(
          onSubmitted: (value) {
            messages.add({
              'send-message': value,
              'time-send':  getTimeNow()
            });
          },
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.message),
            suffixIcon: IconButton(
                onPressed: () {
                 
                  log('send');
                },
                icon: const Icon(Icons.send)),
            hintText: "Enter message",
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
          ),
        )
      ]),
    );
  }

  String getTimeNow() {
     DateTime now = DateTime.now();
    
    // Convert the 24-hour format to 12-hour format
    int hour = now.hour % 12;
    hour = hour == 0 ? 12 : hour; // If hour is 0, set it to 12
    
    // Determine AM/PM
    String period = now.hour >= 12 ? 'PM' : 'AM';
    
    // Log the time in 12-hour format
    return '$hour:${now.minute}:${now.second} $period';
  }
}

class BobalCat extends StatelessWidget {
  const BobalCat({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0)),
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 61, 130, 0),
                Color.fromARGB(255, 0, 204, 61),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.all(13.0),
            child: Text('Chat reenScreenvScreenScreen'),
          ),
        ),
      ),
    );
  }
}
