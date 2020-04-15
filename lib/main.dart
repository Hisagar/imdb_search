import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_search/imdb.dart';
import 'package:http/http.dart' as http;
import 'package:numberpicker/numberpicker.dart';

void main() => runApp(MyMovieApp());

class MyMovieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IMDb Searcher',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyMovieSearchPage(title: 'IMDb Searcher'),
    );
  }
}

class MyMovieSearchPage extends StatefulWidget {
  MyMovieSearchPage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MovieSearchPageState createState() => _MovieSearchPageState();
}

class _MovieSearchPageState extends State<MyMovieSearchPage> {


  TextEditingController editingController = TextEditingController();
  List<Imdb> _imdbList=List<Imdb>();
  int _selectedYear,strlen=0;
  String type;
  bool isSwitchedYear,isSwitchedType,isSearch,isFound;
  String dropdownValue = 'Movie';

  List <String> spinnerItems = [
    'Movie',
    'Series',
    'Episode',
  ] ;

  @override
  void initState() {
    _selectedYear= DateTime.now().year;
    type="Movie";
    isSwitchedYear=false;
    isSwitchedType=false;
    isFound=true;
    isSearch=false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar:AppBar(title: new Text(widget.title),),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onSubmitted: (val){
                    _imdbList.clear();
                   isSearch=true;
                    if(val.length!=0)
                    {
                      imdbDataFetch(val).then((value){
                        setState(() {
                          _imdbList.addAll(value);
                        });
                      });
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      strlen=value.length;
                    });
                  },
                  controller: editingController,
                  decoration: InputDecoration(
                      labelText: "Search",
                      hintText: "Search your movies and TV content",
                      suffixIcon: strlen > 0 ? IconButton(
                          onPressed: () {
                            editingController.clear();
                            setState(() {
                              strlen=0;

                            });
                          },
                          icon: Icon(Icons.clear, color: Colors.grey)
                      ) : null,
                      prefixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            _imdbList.clear();
                            isSearch=true;
                            if(editingController.text.length!=0)
                            {
                              imdbDataFetch(editingController.text).then((value){
                                setState(() {
                                  _imdbList.addAll(value);
                                });
                              });
                            }

                          }),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center ,
                crossAxisAlignment: CrossAxisAlignment.center ,
                children: <Widget>[
                  Transform.scale(scale: 0.75,
                    child: Switch(value: isSwitchedYear,
                      onChanged: (value){
                        setState(() {
                          isSwitchedYear=value;
                        });
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                    ),
                  )
                  ,
                  Text("Year"),
                  FlatButton(
                    child: Row(
                      children: <Widget>[
                        Text(_selectedYear.toString()),
                        Icon(Icons.calendar_today)
                      ],
                    ),
                    onPressed: _showDialog,
                  ),
                  Transform.scale(
                    scale: 0.75,
                    child: Switch(value: isSwitchedType,
                      onChanged: (value){
                        setState(() {
                          isSwitchedType=value;
                        });
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                    ),
                  ),

                  Text("Type"),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      icon: Icon(Icons.local_movies),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.black, fontSize: 14),

                      onChanged: (String data) {
                        setState(() {
                          dropdownValue = data;
                        });
                      },
                      items: spinnerItems.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),

                ],
              ),
              isSearch==true?
              new Center(
                child: new CircularProgressIndicator(),
              ):
              Expanded(
                  child: isFound==true?
                  ListView.builder(itemBuilder: (context,index)
                  {
                    return Column(
                      children: <Widget>[
                        Padding(padding:EdgeInsets.only(left: 48,right: 48),
                            child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(24.0),topLeft: Radius.circular(24.0))),
                              child: InkWell(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,  // add this
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(24.0),
                                        topRight: Radius.circular(24.0),
                                      ),
                                      child: Image.network(
                                          _imdbList[index].Poster,
                                          //width: 100,
                                          height: 250,
                                          fit:BoxFit.fill
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                        Padding(padding:EdgeInsets.only(left: 8,right: 8,bottom: 8),
                            child: Card(
                              elevation: 5,
                              //shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(24.0),topLeft: Radius.circular(24.0))),
                              child: InkWell(
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,  // add this
                                    children: <Widget>[
                                      Text(_imdbList[index].Title,textAlign: TextAlign.center,style: TextStyle(fontSize: 16),),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(

                                            children: <Widget>[
                                              Icon(Icons.tv),
                                              Padding(padding: EdgeInsets.only(left: 8),
                                              child:  Text(_imdbList[index].Genre,textAlign: TextAlign.center,style: TextStyle(fontSize: 12),),
                                              )
                                              ],
                                          ),
                                          Row(

                                            children: <Widget>[Icon(Icons.star,color: Colors.amber),

                                              Text(_imdbList[index].imdbRating,textAlign: TextAlign.center,style: TextStyle(fontSize: 12),),
                                            ],
                                          )
                                        ],
                                      ),
                                      Row(

                                        children: <Widget>[
                                          Icon(Icons.supervised_user_circle),
                                          Expanded(
                                            child: Text(_imdbList[index].Actors,overflow: TextOverflow.clip,
                                                style: TextStyle(fontSize: 12)
                                            ),
                                          )
                                          ,
                                        ],
                                      ),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(

                                            children: <Widget>[
                                              Icon(Icons.person_pin),
                                              Padding(padding: EdgeInsets.only(left: 8),
                                                child: Text(_imdbList[index].Director,textAlign: TextAlign.center,style: TextStyle(fontSize: 12),),
                                              )
                                              ],
                                          ),


                                        ],
                                      ),
                                      Row(

                                        children: <Widget>[Icon(Icons.movie),
                                          Padding(padding: EdgeInsets.only(left: 8),
                                            child:Text(_imdbList[index].Type,textAlign: TextAlign.center,style: TextStyle(fontSize: 12),),
                                          )
                                           ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(

                                            children: <Widget>[
                                              Icon(Icons.date_range),
                                              Padding(padding: EdgeInsets.only(left: 8),
                                                child: Text(_imdbList[index].Released,textAlign: TextAlign.center,style: TextStyle(fontSize: 12),),
                                              )
                                              ],
                                          ),
                                          Row(

                                            children: <Widget>[Icon(Icons.timer),

                                              Text(_imdbList[index].Runtime,textAlign: TextAlign.center,style: TextStyle(fontSize: 12),),
                                            ],
                                          ),

                                        ],
                                      ),
                                      Row(

                                        children: <Widget>[Icon(Icons.book),
                                          Expanded(
                                            child: Text(_imdbList[index].Plot,overflow: TextOverflow.clip,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 12)
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ))
                      ],
                    );
                  },
                    itemCount: _imdbList.length,
                  ):Text("Content not available")
              ),
            ],
          ),
        ),
      ),

    );

  }


  Future<List<Imdb>> imdbDataFetch(String title) async{
    setState(() {
      isFound=true;
    });
    String year=null,type=null;
    var url="http://www.omdbapi.com/?apikey=d7a78949&t="+title;
    if(isSwitchedYear)
      {
        year=_selectedYear.toString();
        url+="&y="+year;
      }
    if(isSwitchedType)
      {
        type=dropdownValue.toLowerCase();
        url+="&type="+type;
      }

    var response= await http.get(url);
    var imdbList= List<Imdb>();
    setState(() {
      isSearch=false;
    });
    if(response.statusCode==200)
      {

        var jsonData= json.decode(response.body);
        if(jsonData['Response']=="True")
          {

            imdbList.add(Imdb.fromJson(jsonData));

          }else
            {
              setState(() {
                isFound=false;
              });
            }

      }

    return imdbList;
  }

  void _showDialog() {


    showDialog<int>(
        context: context,

        builder: (BuildContext context) {
          return new NumberPickerDialog.integer(
            title: new Text("Year",textAlign: TextAlign.center,),
            minValue: 1888,
            maxValue: DateTime.now().year,
            initialIntegerValue: _selectedYear,
          );
        }
    ).then((value){
      if (value != null) {
        setState(() => _selectedYear = value);
      }
    });
  }

}
