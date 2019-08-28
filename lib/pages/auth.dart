import 'package:scoped_model/scoped_model.dart';
import '../scoped_models/main.dart';
import '../models/user.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage>{
  String emailAddressValue, passwordValue;
  GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();

  void signIn(){
    Navigator.pushReplacementNamed(context, '/home'); 
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

  Widget usernameField(){
    return TextField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Email Address',
        suffixIcon: GestureDetector(
          onTap: (){},
          child: Icon(Icons.email)
        )
      ),
      onChanged: (String value){
        setState(() {
          emailAddressValue = value;
        });
      },
      // validator: (String value){
      //   if(value.isEmpty){
      //     return 'Please enter your email address';
      //   }
      //   if(!value.contains('@')){
      //     return 'Please enter a valid email address';
      //   }
      // },
    );
  }

  Widget passwordField(){
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model){
        return TextField(
          keyboardType: TextInputType.text,
          obscureText: model.passwordHideText,
          decoration: InputDecoration(
            labelText: 'Password',
            // suffixIcon: Icon(Icons.visibility),
            suffixIcon: (model.passwordHideText) ? GestureDetector(
              child: Icon(Icons.visibility),
              onTap: ()=> model.changePasswordView()
            ) : GestureDetector(
              child: Icon(Icons.visibility_off),
              onTap: ()=> model.changePasswordView()
            )
          ),
          onChanged: (String value){
            setState(() {
              passwordValue = value;
            });
          },
          // validator: (String value){
          //   if(value.isEmpty){
          //     return 'Please enter your password';
          //   }
          // },
        );
      }
    );
  }

  Widget signInButton(BuildContext context, MainModel model){
    return (model.signInLoading) ? CircularProgressIndicator() :
    GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
        User userDetails = User(emailAddress: emailAddressValue, password: passwordValue);
        if(signInFormKey.currentState.validate()){
          model.signIn(userDetails, signIn, context);
          signInFormKey.currentState.save();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 75.0, vertical: 15.0),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(30.0)
        ),
        child: (Text('Sign in', style: TextStyle(fontSize: 16.0, color: Colors.white)))
      )
    );
  }

  Widget socialAndRegisterBar(BuildContext context){
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Text('Or sign in with', style: TextStyle(fontSize: 16.0)),
                    SizedBox(width: 7.5),
                    GestureDetector(
                      onTap: ()=> model.signInWithGoogle(signIn),
                      child: Container(
                        width: 24.0,
                        height: 24.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/google-icon.png')
                          )
                        ),
                      ),
                    ),
                    SizedBox(width: 7.5),
                    // Container(
                    //   width: 22.0,
                    //   height: 22.0,
                    //   decoration: BoxDecoration(
                    //     image: DecorationImage(
                    //       image: AssetImage('assets/facebook-logo.png')
                    //     )
                    //   ),
                    // )
                  ],
                ),
              ),
              Container(
                child: GestureDetector(
                  onTap: (){
                    Navigator.pushReplacementNamed(context, '/signup');
                  },
                  child: Row(
                    children: <Widget>[
                      Text('Register', style: TextStyle(fontSize: 16.0)),
                      SizedBox(width: 5.0),
                      Icon(Icons.arrow_forward, size: 30.0, color: Theme.of(context).primaryColor)
                    ],
                  )
                ),
              )
            ],
          )
        );
      }
    );
  }

  Widget authPageLayout(BuildContext context){
    return WillPopScope(
      onWillPop: () async => false,
      child: ScopedModelDescendant<MainModel>(
        builder: (context, child, model){
          return GestureDetector(
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
              model.passwordHideText = true;
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      appLogo(),
                      Form(
                        key: signInFormKey,
                        child: Column(
                          children: <Widget>[
                            usernameField(),
                            passwordField(),
                            SizedBox(height: 25.0),
                            ScopedModelDescendant<MainModel>(
                              builder: (BuildContext context, Widget child, MainModel model){
                                return signInButton(context, model);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Center(
                        child: GestureDetector(
                          onTap: (){
                            Navigator.pushReplacementNamed(context, '/forgot');
                          },
                          child: Text('Forgot your password?', style: TextStyle(color: Theme.of(context).primaryColor),)
                        )
                      ),
                      SizedBox(height: 5.0)
                    ],
                  ),
                ),
              )
            ),
          );
        }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: authPageLayout(context),
      bottomNavigationBar: socialAndRegisterBar(context)
    );
  }
  
}