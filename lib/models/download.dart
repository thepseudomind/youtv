import 'package:flutter/material.dart';
  
class Download{
  String name, src;
  bool status;

  Download(
    {
      @required this.name,
      @required this.src,
      this.status
    }
  );
}