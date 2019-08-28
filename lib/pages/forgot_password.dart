import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:youtv/scoped_models/main.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String emailValue;

  Widget backButton(BuildContext context){
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: ()=> Navigator.pushReplacementNamed(context, '/auth'),
            child: Icon(Icons.arrow_back)
          )
        ),
        Expanded(
          flex: 14,
          child: Container()
        )
      ],
    );
  }

  Widget appLogo(){
    return Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/youtv_logo.png')
        )
      ),
    );
  }

  Column titleSubtitleText(){
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text('Forgot password?', textAlign: TextAlign.left, style: TextStyle(fontFamily : 'ProximaNova', fontSize: 35.0, fontWeight: FontWeight.w700)),
            )
          ],
        )
        // SizedBox(height: 10.0),
        // Text('Enter your email to receive a password reset confirmation')
      ],
    );
  }

  TextField emailAddressField(){
    return TextField(
      onChanged: (String value){
        setState(() {
          emailValue = value;
        });
      },
      decoration: InputDecoration(
        labelText: 'Enter your email address here'
      ),
    );
  }

  Widget submitButton(BuildContext context, Function forgotPassword){
    void resetSuccessful(){
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            content: Text('Kindly check your email to reset your password'),
          );
        }
      );
    }

    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model){
        if(model.passwordResetLoading){
          return Center(
            child: CircularProgressIndicator()
          );
        }else{
          return GestureDetector(
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
              print(emailValue);
              forgotPassword(emailValue, resetSuccessful);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(30.0)
              ),
              child: Center(
                child: (Text('Reset password', style: TextStyle(fontSize: 16.0, color: Colors.white)))
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
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: IconButton(
              onPressed: ()=> Navigator.pushReplacementNamed(context, '/auth'),
              icon: Icon(Icons.arrow_back),
              color: Colors.black
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // backButton(context),
                  // SizedBox(height: 60.0),
                  appLogo(),
                  SizedBox(height: 20.0),
                  titleSubtitleText(),
                  emailAddressField(),
                  SizedBox(height: 20.0),
                  submitButton(context, model.forgotPassword),
                  SizedBox(height: 60.0),
                ]
              )
            ),
          ),
        );
      }
    );
  }
}

//FocusScope.of(context).requestFocus(FocusNode());