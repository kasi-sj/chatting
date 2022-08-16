import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_11_chat/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

var textfielder = TextEditingController();

class ChatScreen extends StatefulWidget {
  static const id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late String message;
  messagestreme() async {
    // var mess = await firestore.collection('message').get();
    // for (var mes in  mess.docs) {
    //   print(mes.data());
    // }
    await for (var Snapshot in firestore.collection('message').snapshots()) {
      for (var message in Snapshot.docs) {
        print(message.data());
      }
    }
  }

  var currentuser;
  void getcurrentuser() async {
    final user = await _auth.currentUser;
    if (user != null) {
      currentuser = user.email;
      print(currentuser);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcurrentuser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.grey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: firestore
                    .collection('message')
                    .orderBy('time', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: SpinKitCircle(
                      color: Colors.grey,
                    ));
                  }
                  var message = snapshot.data!;
                  List<Padding> lis = [];
                  for (var mes in message.docs.reversed) {
                    var text = mes.get('text');
                    var user = mes.get('sender');
                    var time = mes.get('time');
                    bool val = user == currentuser ? true : false;
                    var info = Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      child: messagebox(
                        user: user,
                        text: text,
                        tim: time,
                        value: val,
                      ),
                    );
                    lis.add(info);
                  }
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView(
                        reverse: true,
                        children: lis,
                      ),
                    ),
                  );
                },
              ),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          message = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                        controller: textfielder,
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          textfielder.clear();
                        });

                        firestore.collection('message').add({
                          'text': message,
                          'time': FieldValue.serverTimestamp(),
                          'sender': currentuser
                        });
                      },
                      child: Text(
                        'Send',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class messagebox extends StatelessWidget {
  messagebox(
      {Key? key,
      required this.user,
      required this.text,
      required this.tim,
      required this.value})
      : super(key: key);

  final String user;
  final String text;
  final bool value;
  var tim;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          value ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          user,
          style: TextStyle(fontSize: 8, color: Colors.black87),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
                topLeft: value ? Radius.circular(10) : Radius.zero,
                topRight: !value ? Radius.circular(10) : Radius.zero),
            color: value ? Colors.blueAccent : Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              text,
              style: TextStyle(
                  color: value ? Colors.white : Colors.black87, fontSize: 20),
            ),
          ),
        )
      ],
    );
  }
}
