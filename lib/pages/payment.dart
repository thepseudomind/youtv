import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:youtv/scoped_models/main.dart';

class PaymentPage extends StatefulWidget {
  final MainModel model;
  final String subscriptionCode;
  PaymentPage(this.model, this.subscriptionCode);
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String cardNumberValue, cvvValue;
  int expiryMonthValue, expiryYearValue;
  var publicKey = 'pk_test_be39e8d84492620065b49675b380d6fe78bd112b';

  @override
  void initState() {
    // widget.model.chargeCard(context);
    PaystackPlugin.initialize(
      publicKey: publicKey
    );
    super.initState();
  }

  TextField cardNumberField(){
    return TextField(
      keyboardType: TextInputType.number,
      onChanged: (String value){
        setState(() {
          cardNumberValue = value;
        });
      },
      decoration: InputDecoration(
        labelText: 'Card Number'
      ),
    );
  }

  TextFormField cvvField(){
    return TextFormField(
      keyboardType: TextInputType.number,
      maxLength: 3,
      validator: (value){
        if(value.length > 3){
          return 'Invalid CVV';
        }
        return null;
      },
      onSaved: (String value){
        setState(() {
          cvvValue = value;
        });
      },
      decoration: InputDecoration(
        labelText: 'CVV'
      ),
    );
  }

  TextField expiryMonthField(){
    return TextField(
      keyboardType: TextInputType.number,
      maxLength: 2,
      onChanged: (String value){
        setState(() {
          expiryMonthValue = int.parse(value);
        });
      },
      decoration: InputDecoration(
        labelText: 'Expiry Month'
      ),
    );
  }

  TextField expiryYearField(){
    return TextField(
      keyboardType: TextInputType.number,
      maxLength: 2,
      onChanged: (String value){
        setState(() {
          expiryYearValue = int.parse(value);
        });
      },
      decoration: InputDecoration(
        labelText: 'Expiry Year'
      ),
    );
  }

  Row expiryDate(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: expiryMonthField()
        ),
        SizedBox(width: 20.0),
        Expanded(
          child: expiryYearField()
        )
      ]
    );
  }

  Widget paymentButton(BuildContext context){
    void paymentSuccessful(){
      showDialog(
        context: context,
        builder: (context){
          if(Platform.isIOS){
            return CupertinoAlertDialog(
              title: Icon(Icons.check_circle, color: Colors.green, size: 100.0),
              content: Text('Payment successful', textAlign: TextAlign.center),
              actions: <Widget>[
                CupertinoDialogAction(
                  onPressed: ()=> Navigator.pushReplacementNamed(context, '/home'),
                  child: Text('PROCEED', style: TextStyle(color: Theme.of(context).primaryColor))
                )
              ]
            );
          }else{
            return AlertDialog(
              title: Icon(Icons.check_circle, color: Colors.green, size: 100.0),
              content: Text('Payment successful', textAlign: TextAlign.center),
              actions: <Widget>[
                FlatButton(
                  onPressed: ()=> Navigator.pushReplacementNamed(context, '/home'),
                  child: Text('Proceed'),
                )
              ],
            );
          }
        }
      );
    }

    void paymentFailed(){
      showDialog(
        context: context,
        builder: (context){
          if(Platform.isIOS){
            return CupertinoAlertDialog(
              title: Icon(Icons.cancel, color: Colors.red, size: 100.0),
              content: Text('Payment failed', textAlign: TextAlign.center),
              actions: <Widget>[
                CupertinoDialogAction(
                  onPressed: ()=> Navigator.pop(context),
                  child: Text('TRY AGAIN', style: TextStyle(color: Theme.of(context).primaryColor))
                )
              ]
            );
          }else{
            return AlertDialog(
              title: Icon(Icons.cancel, color: Colors.red, size: 100.0),
              content: Text('Payment failed', textAlign: TextAlign.center),
              actions: <Widget>[
                FlatButton(
                  onPressed: ()=> Navigator.pop(context),
                  child: Text('Try again'),
                )
              ],
            ); 
          }  
        }
      );
    }

    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model){
        if(model.paymentInProgress == true){
          return Center(
            child: CircularProgressIndicator()
          );
        }else{
          return GestureDetector(
            onTap: () async{
              FocusScope.of(context).requestFocus(FocusNode());
              await model.chargeCard(context, paymentSuccessful, paymentFailed, widget.subscriptionCode, cardNumber: cardNumberValue, cvv: cvvValue, expiryMonth: expiryMonthValue, expiryYear: expiryYearValue);
              // paymentSuccessful();
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(30.0)
              ),
              child: Center(
                child: (Text('Pay Now', style: TextStyle(fontSize: 16.0, color: Colors.white)))
              )
            ),
          );
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model){
        return Scaffold(
          appBar: AppBar(
            title: Text('Payment page'),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  cardNumberField(),
                  expiryDate(),
                  cvvField(),
                  SizedBox(height: 20.0),
                  paymentButton(context)
                ],
              ),
            ),
          )
        );
      }
    );
  }
}