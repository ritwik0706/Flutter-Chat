import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  var _message = '';
  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    if (_message.trim() == '') {
      return;
    }

    final user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection('users').document(user.uid).get();
    Firestore.instance.collection('chat').add({
      'text': _controller.text.trim(),
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'userName': userData.data['userName'],
      'userImage': userData.data['imageUrl'],
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Enter a message'),
              enableSuggestions: true,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              onChanged: (val) {
                setState(() {
                  _message = val;
                });
              },
            ),
          ),
          IconButton(
              color: Theme.of(context).primaryColor,
              icon: Icon(Icons.send),
              onPressed: _message.isEmpty ? null : _sendMessage)
        ],
      ),
    );
  }
}
