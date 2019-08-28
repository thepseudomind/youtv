import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped_models/main.dart';

class FavoritePage extends StatefulWidget {
  final MainModel model;

  FavoritePage(this.model);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {

  @override
  void initState() {
    widget.model.fetchLikedMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model){
        return RefreshIndicator(
          onRefresh: ()=> model.fetchLikedMovies(),
          child: Scaffold(
            appBar: AppBar(
              title: Text('Favorites')
            ),
            body: (model.likedMovies.length == 0) ? 
              Center(child: Text('No favorite movies')) : 
              ListView.builder(
                itemCount: model.likedMovies.length,
                itemBuilder: (BuildContext context, int index){
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey,
                          width: 0.5
                        ),
                        bottom: BorderSide(
                          color: Colors.grey,
                          width: 0.5
                        )
                      )
                    ),
                    child: GestureDetector(
                      onTap: (){
                        final int realIndex = model.movies.indexOf(model.likedMovies[index]);
                        Navigator.pushNamed(context, '/movies/' + realIndex.toString());
                      },
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: FadeInImage(
                              width: 60.0,
                              height: 120.0,
                              fit: BoxFit.cover,
                              image: NetworkImage(model.likedMovies[index].imageUrl),
                              placeholder: AssetImage('assets/grey.png')
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: ListTile(
                              title: Text(model.likedMovies[index].title, style: TextStyle(fontWeight: FontWeight.w700)),
                              subtitle: Text(model.likedMovies[index].excerpt)
                            )
                          )
                        ],
                      )
                    )
                  );
                }
              )
          )
        );
      }
    );
  }
}