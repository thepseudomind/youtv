import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped_models/main.dart';


class MoviesPage extends StatefulWidget {
  @override
  _MoviesPageState createState() => _MoviesPageState();
  
  final MainModel model;

  MoviesPage(this.model);
}

class _MoviesPageState extends State<MoviesPage> {
  ScrollController _controller;
  
  @override
  void initState() {
    widget.model.fetchMovies();
    super.initState();
  }

  //CONTROL BAR
  Widget controlBar(MainModel model){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: (model.darkMode) ? Colors.black54 : Colors.grey,
          width: 0.5
        )
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: (){},
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Colors.grey,
                        width: 1.0
                      )
                    )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.sort),
                      SizedBox(width: 10.0),
                      Text('Filters')
                    ],
                  ),
                )
              )
            )
          ),
          Expanded(
            flex: 4,
            child: GestureDetector(
              onTap: (){
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    height: 150,
                    child: ListWheelScrollView(
                      itemExtent: 35.0,
                      controller: _controller,
                      useMagnifier: true,
                      children: <Widget>[
                        ListTile(
                          title: Text('Most liked', style: TextStyle(fontSize: 18.0)),
                        ),
                        Divider(),
                        ListTile(
                          title: Text('Most liked', style: TextStyle(fontSize: 18.0)),
                        ),
                        ListTile(
                          title: Text('Most liked', style: TextStyle(fontSize: 18.0)),
                        ),
                        Divider(),
                        ListTile(
                          title: Text('Most liked', style: TextStyle(fontSize: 18.0)),
                        )
                      ]
                    )
                  )
                );
              },
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: (model.darkMode) ? Colors.black54 : Colors.grey,
                        width: 1.0
                      )
                    )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.import_export),
                      SizedBox(width: 10.0),
                      Text('Popularity')
                    ],
                  ),
                )
              )
            ),
          ),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: (){
                model.changeMovieView();
              },
              child: Center(
                child: (model.gridView) ? Icon(Icons.reorder) : Icon(Icons.apps) 
              )
            ),
          )
        ],
      )
    );
  }

  Widget movieLayout(MainModel model){
    if(model.gridView){
      return Expanded( //GRIDVIEW
        child: GridView.builder(
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
                        height: 75.0,
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
        ),
      );
    }else{
      return Expanded(
        child: ListView.builder(
          itemCount: model.movies.length,
          itemBuilder: (BuildContext context, int index){ //LISTVIEW
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
                  Navigator.pushNamed(context, '/movies/' + index.toString());
                },
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: FadeInImage(
                        width: 60.0,
                        height: 120.0,
                        fit: BoxFit.cover,
                        image: NetworkImage(model.movies[index].imageUrl),
                        placeholder: AssetImage('assets/grey.png')
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: ListTile(
                        title: Text(model.movies[index].title, style: TextStyle(fontWeight: FontWeight.w700)),
                        subtitle: Text(model.movies[index].excerpt)
                      )
                    )
                  ],
                )
              )
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model){
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // controlBar(model),
              (model.moviesLoading) ? Center(child: CircularProgressIndicator()) : movieLayout(model)
            ],
          ),
          floatingActionButton: FloatingActionButton(
            // mini: true,
            tooltip: 'Layout',
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: ()=> model.changeMovieView(),
            child: (model.gridView) ? Icon(Icons.reorder, color: (model.darkMode) ? Colors.orangeAccent: Colors.white) : Icon(Icons.apps, color: (model.darkMode) ? Colors.orangeAccent: Colors.white),
          ),
        );
      }
    );
  }
}