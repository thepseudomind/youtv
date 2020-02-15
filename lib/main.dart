import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:youtv/pages/channel.dart';
import 'package:youtv/pages/instagram-page.dart';
import './pages/payment.dart';
import './scoped_models/main.dart';
import './models/channel.dart';
import 'package:animated_splash/animated_splash.dart';

//TEST IM PAGE
import './pages/im.dart';

import './pages/auth.dart';
import './pages/subscibe.dart';
import './pages/register.dart';
import './pages/settings.dart';
import './pages/about.dart';
import './pages/edit_profile.dart';
import './pages/forgot_password.dart';
import './pages/facebook_page.dart';
import './pages/youtube_channel.dart';
import './pages/movie.dart';
import './pages/download.dart';

import './pages/android/home.dart';
import './pages/movie_detail.dart';
import './pages/profile.dart';
// import './pages/android/edit_profile.dart';
import './pages/android/favorite.dart';

import './pages/ios/home.dart';
// import './pages/ios/edit_profile.dart';
import './pages/ios/favorite.dart';

void main()=> runApp(YOUtv());

class YOUtv extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MyYOUtvAppState();
  }
}

class _MyYOUtvAppState extends State<YOUtv>{
  final MainModel model = MainModel();
  Widget home, authPage, profile, editProfile, favorites, introRoute;

  Future<void> checkForUser() async{
    await model.autoLogin();
    setState(() {
      introRoute = (model.signedInUser == null) ? AuthPage() : home;
    });
  }

  @override
  void initState(){
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
      ]);
     checkForUser();
    // authPage = SplashScreen(model);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
  
    if(Platform.isAndroid){
      setState(() {
        home = HomePage(model);
        favorites = FavoritePage(model);
      });
    }else if(Platform.isIOS){
      setState(() {
        home = IosHomePage(model);
        favorites = IosFavoritePage(model);
      });
    }
    

    return ScopedModel<MainModel>(
      model: model,
      child: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: (model.darkMode) ? ThemeData.dark().copyWith(
              scaffoldBackgroundColor: Color(0xFF242A38),
              cardColor: Color(0xFF242A38),
              toggleableActiveColor: Color(0xFFECAC46),
              accentColor: Color(0xFFECAC46),
              accentColorBrightness: Brightness.light,
              splashColor: Color(0xFFECAC46),
              buttonTheme: ButtonThemeData(
                textTheme: ButtonTextTheme.accent
              ),
              cardTheme: CardTheme(
                elevation: 5.0
              ),
              textTheme: TextTheme(
                button: TextStyle(color: Color(0xFFECAC46))
              ),
              iconTheme: IconThemeData(color: (model.darkMode) ? Color(0xFFECAC46): Colors.deepOrange),
              indicatorColor: Color(0xFFECAC46)
            ) 
            : 
            ThemeData(
              primarySwatch: Colors.deepOrange
            ),
            routes: {
              '/' : (context) => ScopedModelDescendant<MainModel>(
                builder: (context, child, model){
                  // if(model.signedInUser == null){
                  //   return AuthPage();
                  // }else{
                  //   return home;
                  // }
                  Widget alternativeRoute = (introRoute == null) ? AuthPage() : introRoute;
                  return AnimatedSplash(
                    imagePath: 'assets/test.png',
                    home: alternativeRoute,
                    duration: 4000,
                    splashBackgroundImage: 'assets/test.png',
                  );
                }
              ),
              '/auth' : (context) => AuthPage(),
              '/signup' : (context) => SignUpPage(),
              '/subscribe' : (context) => SubscriptionPage(),
              '/home' : (context) => home,
              '/profile' : (context) => ProfilePage(model),
              '/edit-profile' : (context) => EditProfilePage(model),
              '/favorites' : (context) => favorites,
              '/settings' : (context) => SettingsPage(model),
              '/chat' : (context) => IMPage(),
              '/about' : (context) => AboutPage(),
              '/forgot' : (context) => ForgotPasswordPage(),
              '/facebook-page': (context) => YOUtvFacebook(),
              '/youtube-page' : (context) => YOUtvYouTube(),
              '/instagram-page' : (context) => YOUtvInstagram(),
              '/downloads' : (context)=> DownloadPage(model)
              // '/show-movie' : (context) => Movie()
            },
            onGenerateRoute: (RouteSettings settings){
              List<String> pathElements = settings.name.split('/');

              if(pathElements[0] != ''){
                return null;
              }

              if(pathElements[1] == 'movies'){
                int index = int.parse(pathElements[2]);
                return MaterialPageRoute(
                  builder: (BuildContext context) => ScopedModelDescendant(
                    builder: (BuildContext context, Widget child, MainModel model){
                      return MovieDetail(model, model.movies[index], index);
                    },
                  )
                );
              }else if(pathElements[1] == 'channel'){
                int index = int.parse(pathElements[2]);
                return MaterialPageRoute(
                  builder: (BuildContext context) => ScopedModelDescendant(
                    builder: (BuildContext context, Widget child, MainModel model){
                      return ShowChannel(model.channels[index], index);
                    },
                  )
                );
              }
            },
          );
        },
      )
    );
  }
}