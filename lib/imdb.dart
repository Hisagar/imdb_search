import 'package:http/http.dart';

class Imdb{
  String Title
  ,Year
  ,Rated
  ,Released
  ,Runtime
  ,Genre
  ,Director
  ,Writer
  ,Actors
  ,Plot
  ,Language
  ,Country
  ,Awards
  ,Poster
  ,Metascore
  ,imdbRating
  ,imdbVotes
  ,imdbID
  ,Type
  ,totalSeasons
  ,Response;


  Imdb(this.Title, this.Year, this.Rated, this.Released,
      this.Runtime, this.Genre, this.Director, this.Writer, this.Actors,
      this.Plot, this.Language, this.Country, this.Awards, this.Poster,
      this.Metascore, this.imdbRating, this.imdbVotes,
      this.imdbID, this.Type, this.totalSeasons, this.Response);

  Imdb.fromJson(Map<String,dynamic> json){

    Title= json['Title'];
    Year= json['Year'];
    Rated= json['Rated'];
    Released= json['Released'];
    Runtime= json['Runtime'];
    Genre= json['Genre'];
    Director= json['Director'];
    Writer= json['Writer'];
    Actors= json['Actors'];
    Plot= json['Plot'];
    Language= json['Language'];
    Country= json['Country'];
    Awards= json['Awards'];
    Poster= json['Poster'];
    Metascore= json['Metascore'];
    imdbRating= json['imdbRating'];
    imdbVotes= json['imdbVotes'];
    imdbID= json['imdbID'];
    Type= json['Type'];
    totalSeasons= json['totalSeasons'];
    Response= json['Response'];;

  }

}