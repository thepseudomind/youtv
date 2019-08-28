import 'package:flutter/material.dart';
import '../utilities/utils.dart';
import './movie.dart';

class User{
  String emailAddress, password, firstName, lastName, phoneNumber;
  subscriptionStatus currentSubscription;
  List<Movie> movies;

  User({
    @required this.emailAddress, 
    @required this.password,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.movies,
    this.currentSubscription
  });
  
}