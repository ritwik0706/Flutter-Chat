import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String msg;
  final String userName;
  final String userImage;
  final bool _isMe;
  final Key key;
  ChatBubble(this.msg, this.userName, this.userImage, this._isMe, {this.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              _isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              width: 140,
              decoration: BoxDecoration(
                color: _isMe ? Colors.grey[350] : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: _isMe ? Radius.circular(15) : Radius.circular(0),
                  bottomRight: _isMe ? Radius.circular(0) : Radius.circular(15),
                ),
              ),
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
              child: Column(
                crossAxisAlignment:
                    _isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (!_isMe)
                    Text(
                      userName,
                      style: TextStyle(
                        color:
                            Theme.of(context).accentTextTheme.headline1.color,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  Text(
                    msg,
                    style: TextStyle(
                      color: _isMe
                          ? Colors.black
                          : Theme.of(context).accentTextTheme.headline1.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if(!_isMe)
        Positioned(
          top: 0,
          left: 120,
          child: CircleAvatar(backgroundImage: NetworkImage(userImage),),
        )
      ],
    );
  }
}
