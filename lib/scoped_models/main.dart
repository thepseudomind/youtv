import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/gallery_image.dart';

import '../models/movie.dart';
import '../models/movie_cast.dart';

import '../utilities/utils.dart';

import './channels.dart';

class MainModel extends Model with ChannelsModel{

  /* APP THEME */
  bool _darkMode = false;
  Color tabBarColor;
  Color tabBarIconColor;
  // SharedPreferences themePrefs;

  void changeMode(bool currentMode) async{
    // themePrefs = await SharedPreferences.getInstance();
    // themePrefs.setBool('mode', currentMode);
    _darkMode = currentMode;
    notifyListeners();
  }

  bool get darkMode{
    return _darkMode;
  }

  Color changeIosTabBarColor(){
    if(_darkMode){
      tabBarColor = Color(0xFF20242F);
      notifyListeners();
    }else{
      tabBarColor = Colors.white;
      notifyListeners();
    }
    return tabBarColor;
  }

  Color changeIosTabBarIconColor(){
    return tabBarIconColor = (_darkMode) ? Color(0xFFECAC46) : Colors.deepOrange;
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  /* USER MODEL */
  String userToken;
  SharedPreferences userPrefs;
  bool passwordHideText = true;
  bool _signUpLoading = false, _signInLoading = false, _passwordResetLoading = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser signedInUser;
  String userPhoneNumber;
  File displayPicture;
  
  void changePasswordView(){
    if(passwordHideText == false){
      passwordHideText = !passwordHideText;
      notifyListeners();
    }else if(passwordHideText == true){
      passwordHideText = !passwordHideText;
      notifyListeners();
    }
  }

  bool get signUpLoading{
    return _signUpLoading;
  }

  bool get signInLoading{
    return _signInLoading;
  }

  bool get passwordResetLoading{
    return _passwordResetLoading;
  }

  Future<void> autoLogin() async{
    userPrefs = await SharedPreferences.getInstance();
    FirebaseUser _signedInUser = await _auth.currentUser();
    if(userPrefs != null && signedInUser == null){
      String userToken = userPrefs.getString('token');
      if(userToken != null){
        String email = userPrefs.getString('email');
        String password = userPrefs.getString('password');
        FirebaseUser _signedInUser = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
        );
        signedInUser = _signedInUser;
        notifyListeners();
      }
    }else if(_signedInUser != null){
      signedInUser = _signedInUser;
      notifyListeners();
    }else{
      signedInUser = null;
      notifyListeners();
    }
  }

  Future<void> createUser(User userToCreate, Function successfulSignup, BuildContext context) async{
    _signUpLoading = true;
    try{
      final FirebaseUser newUser = await _auth.createUserWithEmailAndPassword(
        email: userToCreate.emailAddress,
        password: userToCreate.password
      );
      if(newUser != null){
        UserUpdateInfo info = UserUpdateInfo();
        info.displayName = userToCreate.firstName + ' ' + userToCreate.lastName;
        newUser.updateProfile(info);
        signedInUser = newUser;
        signedInUser.reload();
        String userToken = await newUser.getIdToken();
        userPrefs = await SharedPreferences.getInstance();
        userPrefs.setString('email', userToCreate.emailAddress);
        userPrefs.setString('password', userToCreate.password);
        userPrefs.setString('token', userToken);
        userPrefs.setString('displayName', userToCreate.firstName + ' ' + userToCreate.lastName);
        successfulSignup();
        _signUpLoading = false;
        notifyListeners();
      }
    }catch(e){
      _signUpLoading = false;
      notifyListeners();
      String error = e.toString();
      String errorMessage;
      if(error == 'PlatformException(ERROR_EMAIL_ALREADY_IN_USE, The email address is already in use by another account., null)'){
        errorMessage = 'User already exists';
      }else if(error == 'PlatformException(ERROR_NETWORK_REQUEST_FAILED, A network error (such as timeout, interrupted connection or unreachable host) has occurred., null)'){
        errorMessage = 'Please check your internet connection';
      }else{
        errorMessage = 'Something went wrong';
      }
       _signInLoading = false;
      notifyListeners();
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            content: Text(errorMessage)
          );
        }
      );
      print(e);
    }
  }

  Future<void> signIn(User userDetails, Function successfulSignin, BuildContext context) async{
    _signInLoading = true;
    try{
      final FirebaseUser _signedInUser = await _auth.signInWithEmailAndPassword(
        email: userDetails.emailAddress,
        password: userDetails.password
      );
      if(_signedInUser != null){
        userToken = await _signedInUser.getIdToken();
        userPrefs = await SharedPreferences.getInstance();
        userPrefs.setString('email', userDetails.emailAddress);
        userPrefs.setString('password', userDetails.password);
        userPrefs.setString('token', userToken);
        signedInUser = _signedInUser;
         print("signed in " + signedInUser.displayName);
        successfulSignin();
        _signInLoading = false;
        notifyListeners();
      }
    }catch(e){
      String error = e.toString();
      String errorMessage;
      if(error == 'PlatformException(ERROR_WRONG_PASSWORD, The password is invalid or the user does not have a password., null)'){
        errorMessage = 'Password Incorrect';
      }else if(error == 'PlatformException(ERROR_USER_NOT_FOUND, There is no user record corresponding to this identifier. The user may have been deleted., null)'){
        errorMessage = 'User does not exist';
      }else if(error == 'PlatformException(ERROR_NETWORK_REQUEST_FAILED, Network error (such as timeout, interrupted connection or unreachable host) has occurred., null)'){
        errorMessage = 'Please check your internet connection';
      }else{
        errorMessage = 'Something went wrong';
      }
       _signInLoading = false;
      notifyListeners();
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            content: Text(errorMessage)
          );
        }
      );
      print(e);
    }
  }

  Future<void> signInWithGoogle(Function successfulSignin) async{
    try{
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user = await _auth.signInWithCredential(credential);
      if(user != null){
        // userToken = await user.getIdToken();
        // prefs = await SharedPreferences.getInstance();
        // prefs.setString('token', userToken);
        signedInUser = user;
        print("signed in " + signedInUser.displayName);
        successfulSignin();
      }
    }catch(e){
      print(e);
    }
  }

  Future<FirebaseUser> getCurrentUser() async{
    if(signedInUser == null){
      FirebaseUser _signedinUser = await _auth.currentUser();
      signedInUser = _signedinUser;
      notifyListeners();
    }
    return signedInUser;
  }

  // Future<String> getUserDisplayName() async{
  //   userPrefs = await SharedPreferences.getInstance();
  //   String displayName = userPrefs.getString('displayName');
  //   return displayName;
  // }

  Future<void> updateProfile(String name, String phoneNumber, File image) async{
    try{
      FirebaseUser _signedInUser = await _auth.currentUser();
      Map<String, dynamic> profileToAdd = {
        'phone' : phoneNumber,
        'imageUrl' : image.path
      };
      await http.put('https://youtvusers.firebaseio.com/users/${signedInUser.uid}.json/', body: json.encode(profileToAdd));
      UserUpdateInfo info = UserUpdateInfo();
      info.displayName = name;
      _signedInUser.updateProfile(info);
      signedInUser = _signedInUser;
      signedInUser.reload();
      notifyListeners();
      print(signedInUser.displayName);
    }catch(e){
      print(e);
      print('Couldn\'t post');
    }
  }

  Future<void> fetchOtherDetails() async{
    http.Response response = await http.get('https://youtvusers.firebaseio.com/users.json');
    print(json.decode(response.body));
    final Map<String, dynamic> responseData = json.decode(response.body);
    responseData.forEach(
      (String id, dynamic content){
        String userId = id;
        if(signedInUser.uid == userId){
          userPhoneNumber = content['phone'];
          displayPicture = File(content['imageUrl']);
          notifyListeners();
        }
      }
    );
    // userPhoneNumber = '123265';
    notifyListeners();
  }

  Future<void> removeDisplayPicture() async{
    try{
      await http.delete('https://youtvusers.firebaseio.com/users/${signedInUser.uid}/imageUrl.json');
      displayPicture = null;
      notifyListeners();
    }catch(e){
      print(e);
    }
  }

  Future<void> forgotPassword(String email, Function successPrompt) async{
    _passwordResetLoading = true;
    try{
      await _auth.sendPasswordResetEmail(email: email);
      _passwordResetLoading = false;
      notifyListeners();
      successPrompt();
    }catch(e){
      print(e);
      _passwordResetLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut(Function goToAuth) async{
    await _auth.signOut();
    await _googleSignIn.signOut();
    await userPrefs.clear();
    goToAuth();
     print("signed out");
    // if(signedInUser == null){
    //   goToAuth();
    // }
    notifyListeners();
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  /* MOVIES MODEL */
  bool gridView = true;
  bool _moviesLoading = false;

  List<Movie> _movies = [];
  List<Movie> _likedMovies = [];
  dynamic movieStream;

  DatabaseReference movieDatabase = FirebaseDatabase.instance.reference().child('movies');

  List<Movie> get movies{
    return List.from(_movies);
  }

  List<Movie> get likedMovies{
    return List.from(_likedMovies);
  }

  bool get moviesLoading{
    return _moviesLoading;
  }

  Future<void> fetchLikedMovies() async{
    _moviesLoading = true;
    final List<Movie> _favoriteMovieList = [];
    _movies.forEach(
      (Movie currentMovie){
        if(currentMovie.isLiked && (_favoriteMovieList.contains(currentMovie) == false)){
          _favoriteMovieList.add(currentMovie);
        }
      }
    );
    _likedMovies = _favoriteMovieList;
    _moviesLoading = false;
    notifyListeners();
  }

  void fetchMovies() async{
    if(movies.length == 0){
      _moviesLoading = true;
      http.Response response = await http.get('https://youtvapi.firebaseio.com/movies.json');
      // print(json.decode(response.body));
      final Map<String, dynamic> responseData = json.decode(response.body);
      responseData.forEach(
        (String id, dynamic movieDetails){
          final dynamic movieGallery = movieDetails['gallery'];
          final dynamic movieCharacters = movieDetails['cast'];
          final List<GalleryImage> _fetchedGalleryPictures = [];
          final List<MovieCast> _fetchedMovieCharacters = [];
          movieGallery.forEach(
            (dynamic picId, dynamic picture){
              final GalleryImage image = GalleryImage(
                imageUrl: picture['imageUrl']
              );
              _fetchedGalleryPictures.add(image);
            }
          );
          movieCharacters.forEach(
            (dynamic castId, dynamic castDetails){
              final MovieCast movieCharacter = MovieCast(
                name: castDetails['name'],
                imageUrl: castDetails['imageUrl']
              );
              _fetchedMovieCharacters.add(movieCharacter);
            }
          );
          Movie _newMovie = Movie(
            id: id,
            title: movieDetails['title'],
            imageUrl: movieDetails['imageUrl'],
            isLiked : (movieDetails['likedUsers'] == null) ? false : (movieDetails['likedUsers'] as Map<String, dynamic>).containsKey(signedInUser.uid),
            categories: movieDetails['categories'],
            trailer: movieDetails['trailer'],
            description: movieDetails['description'],
            excerpt: movieDetails['excerpt'],
            commentStore: movieDetails['commentStore'],
            cast: _fetchedMovieCharacters,
            galleryImages: _fetchedGalleryPictures
          );
          _movies.add(_newMovie);
        }
      );
      _moviesLoading = false;
      notifyListeners();
    }
    // print(_movies.length);
  }

  //FUNCTION TO CHANGE LAYOUT VIEW
  void changeMovieView(){
    if(gridView == true){
      gridView = false;
    }else if(gridView == false){
      gridView = true;
    }
    notifyListeners();
  }

  //FUNCTION TO LIKE A MOVIE
  void likeMovie(Movie likedMovie) async{
    if(likedMovie.isLiked == false){
      likedMovie.isLiked = true;
      _likedMovies.add(likedMovie);
      await http.put('https://youtvapi.firebaseio.com/movies/${likedMovie.id}/likedUsers/${signedInUser.uid}.json', body: json.encode(true));
      notifyListeners();
    }else if(likedMovie.isLiked == true){
      likedMovie.isLiked = false;
      _likedMovies.remove(likedMovie);
      await http.delete('https://youtvapi.firebaseio.com/movies/${likedMovie.id}/likedUsers/${signedInUser.uid}.json');
      notifyListeners();
    }
    notifyListeners();
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /* SUBSCRIPTION MODEL */
  String fetchedAccessCode;
  PaymentCard cardToCharge;
  bool paymentCompleted = false;
  bool paymentInProgress = false;


  Future<void> chargeCard(BuildContext context, Function successfulPayment, Function failedPayment, String planCode, {String cardNumber, String cvv, int expiryMonth, int expiryYear}) async{
    paymentInProgress = true;
    try{
      http.Response response = await http.post('https://api.paystack.co/transaction/initialize', headers: {'Authorization' : 'Bearer sk_test_640f3e00f7f35c02a98d3e9eb39e0730e5de67f0'}, body: {'callback_url' : 'https://pre-youtvafrica.com/', 'plan' : planCode, 'email' : signedInUser.email});
      // print(response.body);
      Map<String, dynamic> responseData = json.decode(response.body);
      if(responseData.containsKey('data')){
        fetchedAccessCode = responseData['data']['access_code'];
        notifyListeners();
        print(fetchedAccessCode);

        cardToCharge = PaymentCard(
          number: cardNumber,
          cvc: cvv,
          expiryMonth: expiryMonth,
          expiryYear: expiryYear
        );
        notifyListeners();

        var currentCharge = Charge()
          ..accessCode = fetchedAccessCode
          ..card = cardToCharge;

        PaystackPlugin.chargeCard(context, 
          charge: currentCharge,
          beforeValidate: (Transaction transaction){},
          onSuccess: (Transaction transaction){
            successfulPayment();
            paymentInProgress = false;
            paymentCompleted = true;
            notifyListeners();
          },
          onError: (Object e, Transaction transaction){
            failedPayment();
            paymentInProgress = false;
            notifyListeners();
          },
        );
      }
    }catch(e){
      paymentInProgress = false;
      notifyListeners();
      print(e);
    }
    notifyListeners();
  }
  
}


// Future<void> chargeCard(BuildContext context, {String cardNumber, String cvv, int expiryMonth, int expiryYear}) async{
//     paymentInProgress = true;
//     try{
//       http.Response response = await http.post('https://api.paystack.co/transaction/initialize', headers: {'Authorization' : 'Bearer sk_test_640f3e00f7f35c02a98d3e9eb39e0730e5de67f0'}, body: {'callback_url' : 'https://pre-youtvafrica.com/', 'plan' : 'PLN_n18ffa5fj98uomc', 'email' : signedInUser.email});
//       // print(response.body);
//       Map<String, dynamic> responseData = json.decode(response.body);
//       if(responseData.containsKey('data')){
//         fetchedAccessCode = responseData['data']['access_code'];
//         notifyListeners();
//         print(fetchedAccessCode);

//         cardToCharge = PaymentCard(
//           number: cardNumber,
//           cvc: cvv,
//           expiryMonth: expiryMonth,
//           expiryYear: expiryYear
//         );
//         notifyListeners();
//         print('${cardNumber}, ${cvv}, ${expiryMonth}, ${expiryYear}');

//         var currentCharge = Charge()
//           ..accessCode = fetchedAccessCode
//           ..card = cardToCharge;

//         PaystackPlugin.chargeCard(context, 
//           charge: currentCharge,
//           beforeValidate: (Transaction transaction){},
//           onSuccess: (Transaction transaction){
//             paymentCompleted = true;
//             notifyListeners();
//           },
//           onError: (Object e, Transaction transaction){
//             paymentInProgress = false;
//             paymentCompleted = false;
//             notifyListeners();
//           },
//         );
//       }
//     }catch(e){
//       paymentInProgress = false;
//       notifyListeners();
//       print(e);
//     }
//     notifyListeners();
//   }