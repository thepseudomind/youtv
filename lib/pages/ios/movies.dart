import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../utilities/utils.dart';

import '../../scoped_models/main.dart';

class MoviesPage extends StatefulWidget {
  final MainModel model;

  MoviesPage(this.model);

  @override
  createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage>{

  @override
  void initState() {
    widget.model.fetchMovies();
    super.initState();
  }

  Widget movieLayout(MainModel model){
    return GridView.builder(
      itemCount: model.movies.length,
      itemBuilder: (BuildContext context, int index){
        return GestureDetector(
          onTap: (){
            Navigator.pushNamed(context, '/movies/' + index.toString());
          },
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(model.movies[index].imageUrl),
                fit: BoxFit.cover
              )
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    height: 100.0,
                    color: Colors.black54,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(model.movies[index].title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                        ),
                        SizedBox(height: 2.0),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(model.movies[index].categories, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300)),
                        )
                      ],
                    )
                  ),
                )
                  ],
            )
          ),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model){
        return Scaffold(
          appBar: AppBar(
            backgroundColor: (model.darkMode) ? Color(0xFF20242F) : Theme.of(context).primaryColor,
            leading: Container(),
            title: Text('YOUtv ', style: TextStyle(color: Colors.white)),
            actions: <Widget>[
              GestureDetector(
                onTap: ()=> Navigator.pushNamed(context, '/profile'),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 1.0
                    ),
                    shape: BoxShape.circle
                  ),
                  child: Icon(Icons.person, color: Colors.white),
                  padding: EdgeInsets.all(5.0),
                  margin: EdgeInsets.only(right: 10.0),
                )
              )
            ],
          ),
          body: CupertinoPageScaffold(
            child: (model.moviesLoading) ? Center(child: CupertinoActivityIndicator(radius: 16.0)) : movieLayout(model)
          )
        );
      }
    );
  }
}
