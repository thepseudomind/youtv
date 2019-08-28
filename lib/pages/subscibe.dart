import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:youtv/pages/payment.dart';
import '../scoped_models/main.dart';

class SubscriptionPage extends StatefulWidget {
  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {

  Expanded introTitle(){
    return Expanded(
      flex: 1,
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
            child: Text('Choose a plan', style: TextStyle(fontFamily: 'ProximaNova', fontSize: 45.0, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Expanded subscriptionSlide(BuildContext context, MainModel model){
    return Expanded(
      flex: 6,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          //YouBasic Card
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                width: 350.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.5
                  ),
                  color: (model.darkMode) ? Color(0xFF20242F) : Colors.white
                ),
                child: Column(
                  children: <Widget>[
                    //CARD TITLE
                    Container(
                      height: 150.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: [
                            0.1, 0.3, 0.5, 0.7, 0.9
                          ],
                          colors: [
                            Colors.orange[900],
                            Colors.orange[300],
                            Colors.orange[500],
                            Colors.orange[700],
                            Colors.orange[900]
                          ]
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0)
                        )
                      ),
                      child: Center(
                        child: Text('YouBasic' , style : TextStyle(fontFamily: 'ProximaNova', color: Colors.white, fontSize : 45.0, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text('NGN5000 /mo',style : TextStyle(fontFamily: 'ProximaNova', fontSize : 35.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey,
                                width: 1.0
                              )
                            )
                          ),
                          child: Text('Over 30 movies', style: TextStyle(fontSize: 20.0)),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey,
                                width: 1.0
                              )
                            )
                          ),
                          child: Text('Over 30 channels', style: TextStyle(fontSize: 20.0)),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey,
                                width: 1.0
                              )
                            )
                          ),
                          child: Text('Other services', style: TextStyle(fontSize: 20.0)),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 10.0),
                          child: Text('Other services', style: TextStyle(fontSize: 20.0)),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap: (){
                        showDialog(
                          context: context,
                          builder: (BuildContext context){
                            if(Platform.isAndroid){
                              return AlertDialog(
                                title: Text('Subscribe to the YouBasic plan'),
                                content: Text('This action cannot be undone'),
                                actions: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      FlatButton(
                                        onPressed: (){
                                          Navigator.pop(context);
                                        },
                                        child: Text('CANCEL', style: TextStyle(color: (model.darkMode) ? Color(0xFFECAC46) : Theme.of(context).primaryColor)),
                                      ),
                                      FlatButton(
                                        onPressed: (){
                                          Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => PaymentPage(model, 'PLN_n18ffa5fj98uomc')
                                        ));
                                        },
                                        child: Text('CONTINUE', style: TextStyle(color: (model.darkMode) ? Color(0xFFECAC46) : Theme.of(context).primaryColor)),
                                      )
                                    ],
                                  )
                                ],
                              );
                            }else if(Platform.isIOS){
                              return CupertinoAlertDialog(
                                title: Text('Subscribe to the YouBasic plan'),
                                content: Text('This action cannot be undone'),
                                actions: <Widget>[
                                  CupertinoDialogAction(
                                    onPressed: ()=> Navigator.pop(context),
                                    child: Text('CANCEL', style: TextStyle(color: Theme.of(context).primaryColor))
                                  ),
                                  CupertinoDialogAction(
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => PaymentPage(model, 'PLN_n18ffa5fj98uomc')
                                      ));
                                    },
                                    child: Text('CONTINUE', style: TextStyle(color: Theme.of(context).primaryColor))
                                  )
                                ],
                              );
                            }
                          }
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20.0),
                        padding: EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 60.0
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange[700],
                          borderRadius: BorderRadius.circular(40.0)
                        ),
                        child: Text('SUBSCRIBE', style: TextStyle(fontFamily: 'ProximaNova', color: Colors.white, fontSize: 15.0)),
                      )
                    )
                  ],
                ),
              )
            ],
          ),
          //YouPremium Card
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                width: 350.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.5
                  ),
                  color: (model.darkMode) ? Color(0xFF20242F) : Colors.white
                ),
                child: Column(
                  children: <Widget>[
                    //CARD TITLE
                    Container(
                      height: 150.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: [
                            0.1, 0.3, 0.5, 0.7, 0.9
                          ],
                          colors: [
                            Colors.orange[900],
                            Colors.orange[300],
                            Colors.orange[500],
                            Colors.orange[700],
                            Colors.orange[900]
                          ]
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0)
                        )
                      ),
                      child: Center(
                        child: Text('YouPremium' , style : TextStyle(fontFamily: 'ProximaNova', color: Colors.white, fontSize : 45.0, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text('NGN10000 /mo',style : TextStyle(fontFamily: 'ProximaNova', fontSize : 35.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey,
                                width: 1.0
                              )
                            )
                          ),
                          child: Text('Over 60 movies', style: TextStyle(fontSize: 20.0)),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey,
                                width: 1.0
                              )
                            )
                          ),
                          child: Text('Over 70 movies', style: TextStyle(fontSize: 20.0)),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey,
                                width: 1.0
                              )
                            )
                          ),
                          child: Text('Other services', style: TextStyle(fontSize: 20.0)),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 10.0),
                          child: Text('Other services', style: TextStyle(fontSize: 20.0)),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap: (){
                        showDialog(
                          context: context,
                          builder: (BuildContext context){
                            if(Platform.isAndroid){
                              return AlertDialog(
                                title: Text('Subscribe to the YouPremium plan'),
                                content: Text('This action cannot be undone'),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                    child: Text('CANCEL', style: TextStyle(color: (model.darkMode) ? Color(0xFFECAC46) : Theme.of(context).primaryColor)),
                                  ),
                                  FlatButton(
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => PaymentPage(model, 'PLN_13u5s735meizeq4')
                                      ));
                                    },
                                    child: Text('CONTINUE', style: TextStyle(color: (model.darkMode) ? Color(0xFFECAC46) : Theme.of(context).primaryColor)),
                                  )
                                ],
                              );
                            }else if(Platform.isIOS){
                              return CupertinoAlertDialog(
                                title: Text('Subscribe to the YouPremium plan'),
                                content: Text('This action cannot be undone'),
                                actions: <Widget>[
                                  CupertinoDialogAction(
                                    onPressed: ()=> Navigator.pop(context),
                                    child: Text('CANCEL', style: TextStyle(color: Theme.of(context).primaryColor))
                                  ),
                                  CupertinoDialogAction(
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => PaymentPage(model, 'PLN_13u5s735meizeq4')
                                      ));
                                    },
                                    child: Text('CONTINUE', style: TextStyle(color: Theme.of(context).primaryColor))
                                  )
                                ],
                              );
                            }
                          }
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20.0),
                        padding: EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 60.0
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange[700],
                          borderRadius: BorderRadius.circular(40.0)
                        ),
                        child: Text('SUBSCRIBE', style: TextStyle(fontFamily: 'ProximaNova', color: Colors.white, fontSize: 15.0)),
                      )
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Expanded continueButton(BuildContext context){
    return Expanded(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: GestureDetector(
          onTap: (){
            showDialog(
              context: context,
              builder: (context){
                if(Platform.isAndroid){
                  return AlertDialog(
                    title: Text('Cancel subscription'),
                    content: Text('Are you sure you don\'t want to subscribe now?'),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text('CANCEL'),
                      ),
                      FlatButton(
                        onPressed: ()=> Navigator.pushReplacementNamed(context, '/home'),
                        child: Text('CONTINUE'),
                      )
                    ],
                  );
                }else{
                  return CupertinoAlertDialog(
                    title: Text('Cancel subscription'),
                    content: Text('Are you sure you don\'t want to subscribe now?'),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        onPressed: ()=> Navigator.pop(context),
                        child: Text('CANCEL', style: TextStyle(color: Theme.of(context).primaryColor))
                      ),
                      CupertinoDialogAction(
                        onPressed: ()=> Navigator.pushReplacementNamed(context, '/home'),
                        child: Text('CONTINUE', style: TextStyle(color: Theme.of(context).primaryColor))
                      )
                    ],
                  );
                }
              }
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text('CONTINUE', style: TextStyle(fontSize: 20.0)),
              SizedBox(width: 5.0),
              Icon(Icons.play_circle_filled, size: 22.0, color: Colors.orange[700],)
            ],
          )
        )
      )
    );
  }
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model){
        return Scaffold(
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                introTitle(),
                subscriptionSlide(context, model),
                continueButton(context)
              ],
            )
          )
        );
      }
    );
  }
}