// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import './movie_cast.dart';
import './gallery_image.dart';

class Movie{

  final String title, imageUrl, categories, trailer, excerpt, description, commentStore;
  final List<MovieCast> cast;
  final List<GalleryImage> galleryImages;
  bool isLiked;
  String id;

  Movie(
    {
      @required this.title,
      @required this.imageUrl,
      @required this.categories,
      @required this.trailer,
      @required this.description,
      @required this.excerpt,
      @required this.cast,
      @required this.galleryImages,
      @required this.commentStore,
      this.isLiked,
      this.id
    }
  );

}