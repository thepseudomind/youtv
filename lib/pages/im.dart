import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped_models/main.dart';

//CONSTANTS FOR CHAT SYLING
const kSendButtonTextStyle = TextStyle(
  color: Colors.deepOrange,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.deepOrange, width: 2.0),
  ),
);

//MESSAGE BUBBLE CLASS
class MessageBubbles extends StatelessWidget {
  final String user, text;

  MessageBubbles({@required this.user, @required this.text});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model){
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(user, style: TextStyle(fontSize: 12.0)),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                decoration: BoxDecoration(
                  color: (model.darkMode) ? Color(0xFF20242F).withOpacity(0.5) : Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0)
                  )
                ),
                child: Text(text, style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        );
      }
    );
  }
}

class IMPage extends StatefulWidget {
  @override
  _IMPageState createState() => _IMPageState();
}

class _IMPageState extends State<IMPage> {
  String newMessageValue;
  List<MessageBubbles> messages;
  TextEditingController _messageController;

  @override
  void initState() {
    _messageController = TextEditingController();
    messages = [
      MessageBubbles(user: 'tom@aol.com', text: 'Nice movie'),
      MessageBubbles(user: 'aoki@sam.com', text: 'Interesting hoping to see another part soon'),
      MessageBubbles(user: 'tunde@gmail.com', text: 'Just saw this movie. Wasn\'t too impressed'),
      MessageBubbles(user: 'sholla_p@yahoo.com', text: 'Kit Harrington is really great at acting'),
      MessageBubbles(user: 'aroe@yahoo.com', text: 'That was intense'),
      MessageBubbles(user: 'bensontr259@gmail.com', text: 'Anyone loved the part where they found love?'),
      MessageBubbles(user: 'olaitankazzem@google.com', text: 'Epic movie'),
      MessageBubbles(user: 'appysasam@live.com', text: 'I did\'nt really like the movie'),
      MessageBubbles(user: 'phil-rob2345@webmail.com', text: 'Glad i could see this on YOUtv'),
      MessageBubbles(user: 'deryy.fred@ymail.com.com', text: 'Wished they could have ended the movie on a better note'),
      MessageBubbles(user: 'clarissafairchild@gmail.com', text: '@40:36 Love is beautiful.'),
      MessageBubbles(user: 'jaceallec@yahoo.com', text: 'Thumbs up')
    ];
    super.initState();
  }

  Container messageArea(){
    return Container(
      decoration: kMessageContainerDecoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _messageController,
              onChanged: (value) {
                newMessageValue = value;
              },
              decoration: kMessageTextFieldDecoration,
            ),
          ),
          FlatButton(
            onPressed: () {
              setState(() {
                _messageController.clear();
                messages.add(MessageBubbles(user: 'you@user.com', text: newMessageValue));
              });
            },
            child: Text(
              'Send',
              style: kSendButtonTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Expanded chatList(){
      return Expanded(
        child: ListView.builder(
          itemBuilder: (context, index){
            return MessageBubbles(user: messages[index].user, text: messages[index].text);
          },
          itemCount: messages.length,
        )
      );
    }

    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model){
        return Scaffold(
          appBar: AppBar(
            backgroundColor: (model.darkMode) ? Color(0xFF20242F) : Theme.of(context).primaryColor,
            title: Text('Comments'),
          ),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                chatList(),
                messageArea()
              ]
            )
          )
        );
      },
    );
  }
}
