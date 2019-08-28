import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped_models/main.dart';
import '../models/movie.dart';


const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

//MESSAGE BUBBLE CLASS
class MessageBubbles extends StatelessWidget {
  final String user, comment;

  MessageBubbles({@required this.user, @required this.comment});

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
                  color: (model.darkMode) ? Color(0xFFECAC46) : Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0)
                  )
                ),
                child: Text(comment, style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        );
      }
    );
  }
}

class CommentsPage extends StatefulWidget {
  final Movie currentMovie;
  final MainModel model;
  final int _index;

  CommentsPage(this.currentMovie, this.model, this._index);
  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  FirebaseUser _currentUser;
  Firestore _commentStore;
  String newMessageValue;
  TextEditingController _messageController;

  @override
  void initState() {
    _currentUser = widget.model.signedInUser;
    _commentStore = Firestore.instance;
    _messageController = TextEditingController();
    super.initState();
  }

  Container messageArea(MainModel model){
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: (model.darkMode) ? Color(0xFF20242F) : Colors.deepOrange, width: 2.0),
        ),
      ),
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
              });
              _commentStore.collection(widget.currentMovie.commentStore).add(
                {
                  'comment' : newMessageValue,
                  'user' : _currentUser.displayName
                }
              );
            },
            child: Text(
              'Send',
              style: TextStyle(
                color: (model.darkMode) ? Color(0xFF20242F) : Colors.deepOrange,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  StreamBuilder commentStream(){
    return StreamBuilder<QuerySnapshot>(
      //Collection is meant to be widget.currentMovie.commentStore
      stream: _commentStore.collection(widget.currentMovie.commentStore).snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(
            child: (Platform.isAndroid) ? CircularProgressIndicator() : CupertinoActivityIndicator()
          );
        }
        final List<MessageBubbles> fetchedComments = [];
        final comments = snapshot.data.documents.reversed;
        for(var comment in comments){
          fetchedComments.add(MessageBubbles(comment: comment.data['comment'], user: comment.data['user']));
        }
        return Expanded(
          child: ListView.builder(
            reverse: true,
            itemBuilder: (context, index){
              return MessageBubbles(user: fetchedComments[index].user, comment: fetchedComments[index].comment);
            },
            itemCount: fetchedComments.length,
          )
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model){
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: (){
                Navigator.pushReplacementNamed(context, '/movies/' + widget._index.toString());
              },
              icon: (Platform.isIOS) ? Icon(Icons.arrow_back_ios) : Icon(Icons.arrow_back),
            ),
            backgroundColor: (model.darkMode) ? Color(0xFF20242F) : Theme.of(context).primaryColor,
            title: Text('Comments'),
          ),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                commentStream(),
                messageArea(model)
              ]
            )
          )
        );
      },
    );
  }
}
