import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped_models/main.dart';
import '../models/user.dart';
import '../pages/auth.dart';

class SignUpPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _SignUpPageState();
  }
}

class _SignUpPageState extends State<SignUpPage>{
  String emailAddressValue, passwordValue, firstNameValue, lastNameValue;
  GlobalKey<FormState> signupformKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  void signUp(){
    SnackBar signUpSnackBar = SnackBar(
      backgroundColor : Theme.of(context).primaryColor,
      content: Text('Account created successfully', style: TextStyle(color: Colors.white)),
      action: SnackBarAction(
        label: 'LOGIN',
        textColor: Colors.white,
        onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (BuildContext context) => AuthPage()
          ));
        }
      )
    );
    scaffoldKey.currentState.showSnackBar(signUpSnackBar);
  }

    //APPLOGO
  Widget appLogo(){
    return Container(
      width: 150.0,
      height: 150.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/logo.png')
        )
      ),
    );
  }

  //SIGN UP BUTTON
  Widget signUpButton(MainModel model){
    User userDetails = User(emailAddress: emailAddressValue, password: passwordValue, firstName: firstNameValue, lastName: lastNameValue);
    return (model.signUpLoading) ? CircularProgressIndicator() : 
    GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
        if(signupformKey.currentState.validate()){
          signupformKey.currentState.save();
          model.createUser(userDetails, signUp, context);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 75.0, vertical: 15.0),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(30.0)
        ),
        child: Text('Register', style: TextStyle(fontSize: 16.0, color: Colors.white)),
      )
    );
  }

  Widget signUpForm(MainModel model){
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Form(
        key: signupformKey,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    onSaved: (String value){
                      setState(() {
                        firstNameValue = value;
                      });
                    },
                    validator: (String value){
                      if(value.isEmpty){
                        return 'First name required';
                      }
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'First Name'
                    ),
                  )
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: TextFormField(
                    onSaved: (String value){
                      setState(() {
                        lastNameValue = value;
                      });
                    },
                    validator: (String value){
                      if(value.isEmpty){
                        return 'Last name required';
                      }
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Last Name'
                    ),
                  )
                )
              ],
            ),
            TextFormField(
              onSaved: (String value){
                setState(() {
                  emailAddressValue = value;
                });
              },
              validator: (String value){
                if(value.isEmpty){
                  return 'Please enter an email address';
                }
                for(var i = 0; i <value.length; i++){
                  if(!value.contains('@')){
                    return 'Please enter a valid email address';
                  }
                }
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email Address'
              ),
            ),
            TextFormField(
              onSaved: (String value){
                setState(() {
                  passwordValue = value;
                });
              },
              obscureText: true,
              validator: (String value){
                if(value.isEmpty){
                  return 'Please enter a password';
                }
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Password'
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            signUpButton(model)
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model){
        return GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Scaffold(
            key: scaffoldKey,
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    appLogo(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text('Register', textAlign: TextAlign.left, style: TextStyle(fontFamily : 'ProximaNova', fontSize: 40.0, fontWeight: FontWeight.w700)),
                          ),
                          Expanded(
                            child: Container(),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: signUpForm(model),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.pushReplacementNamed(context, '/auth');
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text('I already have an account', textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14.0)),
                      ),
                    )
                  ],
                ),
              )
            )
          ),
        );
      },
    );
  }
}

