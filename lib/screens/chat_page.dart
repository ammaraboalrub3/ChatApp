import 'package:chat_app/model/message_modle.dart';
import 'package:chat_app/widget/const.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widget/chat_buble.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});

  final _controlar = ScrollController();

  CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');
  TextEditingController controller = TextEditingController();
  static String id = "ChatPage";

  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder<QuerySnapshot>(
        stream: messages.orderBy('cratedAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Message> messagesList = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
            }

            return Scaffold(
                appBar: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: kPrimaryColor,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 50,
                            child: Image.asset("assets/images/scholar.png")),
                        const Text("Chat"),
                      ],
                    )),
                body: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          reverse: true,
                          controller: _controlar,
                          itemCount: messagesList.length,
                          itemBuilder: (context, index) {
                            return messagesList[index].id == email
                                ? chatBuble(
                                    message: messagesList[index],
                                  )
                                : chatBubleForFriend(
                                    message: messagesList[index]);
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextField(
                        controller: controller,
                        onSubmitted: (data) {
                          messages.add({
                            'message': data,
                            "cratedAt": DateTime.now(),
                            "id": email
                          });
                          controller.clear();
                          _controlar.animateTo(0,
                              duration: const Duration(seconds: 1),
                              curve: Curves.fastOutSlowIn);
                        },
                        decoration: const InputDecoration(
                          hintText: "sent message...",
                          suffixIcon: Icon(Icons.send),
                          suffixIconColor: kPrimaryColor,
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              borderSide: BorderSide(color: kPrimaryColor)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: kPrimaryColor),
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ));
          } else {
            return const Text("laoding");
          }
        });
  }
}
