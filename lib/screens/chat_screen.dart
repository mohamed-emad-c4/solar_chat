import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scholar_chat/main.dart';
import 'package:scholar_chat/models/mesges.dart';
import 'package:scholar_chat/screens/loading_screen.dart';

class ChatScreen extends StatefulWidget {
  String email;
  ChatScreen({super.key, required this.email});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

final storage = FirebaseStorage.instance;
CollectionReference messages = FirebaseFirestore.instance.collection('mesgs');
TextEditingController controller = TextEditingController();
final ScrollController _controller = ScrollController();

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy('time').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<MesgesFirestore> messagesList = [];
          for (var mwsg in snapshot.data!.docs) {
            messagesList.add(MesgesFirestore.fromJson(mwsg.data()));
          }

          return Scaffold(
            appBar: AppBar(
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(darkmode ? Icons.light_mode : Icons.dark_mode),
                  onPressed: () async {
                    darkmode = !darkmode;
                    setState(() {});
                  },
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/comments.png', scale: 10),
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
                actions: [
                  Container(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: IconButton(
                        onPressed: () async {},
                        icon: IconButton(
                          icon: const Icon(Icons.logout),
                          onPressed: () {
                            GoRouter.of(context).go('/');
                          },
                        ),
                      )),
                ]),
            body: Column(children: [
              Expanded(
                child: ListView.builder(
                    // reverse: true,
                    controller: _controller,
                    itemBuilder: (context, index) {
                      if (messagesList[index].email == widget.email) {
                        return BobleChat(
                          messagesListToShow: messagesList,
                          index: index,
                        );
                      } else {
                        return BobleChat(
                          messagesListToShow: messagesList,
                          index: index,
                          alignment: Alignment.topRight,
                          fristColor: const Color.fromARGB(255, 93, 185, 0),
                          secndtColor: const Color.fromARGB(255, 128, 255, 1),
                        );
                      }
                    },
                    itemCount: messagesList.length),
              ),
              TextField(
                controller: controller,
                onSubmitted: (value) async {
                  log('''''' '''''' '''''' '''''');
                  log(value);
                  log(controller.text);
                  messages.add(
                    {
                      'send-message': value,
                      'email': widget.email,
                      'time-send': getTimeNow(),
                      'device-model': await getInfo(),
                      'time': DateTime.now(),
                    },
                  );
                  controller.clear();
                  _controller.animateTo(
                    _controller.position.maxScrollExtent,
                    duration: const Duration(seconds: 1),
                    curve: Curves.fastOutSlowIn,
                  );
                  // setState(() {
                  //   log('set state');
                  // });
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.message),
                  suffixIcon: IconButton(
                      onPressed: () async {
                        log('info');
                        messages.add(
                          {
                            'send-message': controller.text,
                            'email': widget.email,
                            'time-send': getTimeNow(),
                            'device-model': await getInfo(),
                            'time': DateTime.now(),
                          },
                        );
                        controller.clear();
                        _controller.animateTo(
                          _controller.position.maxScrollExtent,
                          duration: const Duration(seconds: 1),
                          curve: Curves.fastOutSlowIn,
                        );
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
        } else {
          return const LoadingScreen();
        }
      },
    );
  }

  Future<String> getInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    return 'Running on ${androidInfo.model}';
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

class BobleChat extends StatelessWidget {
  List<MesgesFirestore> messagesListToShow = [];
  int index;
  final Color fristColor;
  final Color secndtColor;
  final Alignment alignment;
  BobleChat({
    super.key,
    required this.messagesListToShow,
    required this.index,
    this.fristColor = const Color(0xFFFF5F6D),
    this.secndtColor = const Color(0xFFFFC371),
    this.alignment = Alignment.topLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
      child: Align(
        alignment: alignment,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0)),
            gradient: LinearGradient(
              colors: [fristColor, secndtColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 13, right: 13, left: 13),
            child: Text(
                "${messagesListToShow[index].message}\n ${messagesListToShow[index].time} "),
          ),
        ),
      ),
    );
  }
}
