import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_moviesflix_app/pages/video_player_page.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:convert';
import '../utils/util.dart';


class VideoPlayerPage extends StatefulWidget {
  final String videoKey;
  final String id;
  VideoPlayerPage({required this.videoKey, required this.id});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {

  bool adult = false;
  String backdropPath = '';
  int budget = 0;
  List<Map<String, dynamic>> genres = [];
  String homepage = '';
  String imdbId = '';
  String originalLanguage = '';
  String originalTitle = '';
  String overview = '';
  double popularity = 0;
  String posterPath = '';
  List<Map<String, dynamic>> productionCompanies = [];
  List<Map<String, dynamic>> productionCountries = [];
  String releaseDate = '';
  int revenue = 0;
  int runtime = 0;
  List<Map<String, dynamic>> spokenLanguages = [];
  String status = '';
  String tagline = '';
  String title = '';
  bool video = false;
  double voteAverage = 0;
  int voteCount = 0;

  List<Map<String, dynamic>> cast = [];
  List<Map<String, dynamic>> videosData = [];
  List<Movie> topratedmovies = [];
  int movieId = 0;
  late YoutubePlayerController _controller;


  @override
  void initState() {
    super.initState();
    fetchData();
    fetchCast();
    fetchVideos();
    fetchMoviesData("toprated");
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoKey,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        hideControls: true,
        hideThumbnail: true,
        controlsVisibleAtStart: true,
        showLiveFullscreenButton: true,
      ),
    );
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/${widget.id}?api_key=6a215d3a3b85b4319eaa45038a6f11c0'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        setState(() {
          adult = data['adult'];
          backdropPath = data['backdrop_path'];
          budget = data['budget'];
          title = data['title'];
          genres = List<Map<String, dynamic>>.from(data['genres']);
          homepage = data['homepage'];
          imdbId = data['imdb_id'];
          originalLanguage = data['original_language'];
          originalTitle = data['original_title'];
          overview = data['overview'];
          popularity = data['popularity'];
          posterPath = data['poster_path'];
          productionCompanies =
          List<Map<String, dynamic>>.from(data['production_companies']);
          productionCountries =
          List<Map<String, dynamic>>.from(data['production_countries']);
          releaseDate = data['release_date'];
          revenue = data['revenue'];
          runtime = data['runtime'];
          spokenLanguages =
          List<Map<String, dynamic>>.from(data['spoken_languages']);
          status = data['status'];
          tagline = data['tagline'];
          video = data['video'];
          voteAverage = data['vote_average'];
          voteCount = data['vote_count'];
        });
      } else {
        print('API Request failed with status ${response.statusCode}');
        // Handle error here
      }
    } catch (error) {
      print('Error: $error');
      // Handle error here
    }
  }

  Future<void> fetchCast() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api.themoviedb.org/3/movie/${widget.id}/credits?api_key=6a215d3a3b85b4319eaa45038a6f11c0'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> castData = json.decode(response.body);
        setState(() {
          cast = List<Map<String, dynamic>>.from(castData['cast']);
        });
      } else {
        print('API Request failed with status ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> fetchVideos() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api.themoviedb.org/3/movie/${widget.id}/videos?api_key=6a215d3a3b85b4319eaa45038a6f11c0'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        setState(() {
          videosData = List<Map<String, dynamic>>.from(results);
          movieId = data['id'];
        });
      } else {
        throw Exception('Failed to load videos');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> fetchMoviesData(String url_typ) async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/trending/movie/day?api_key=6a215d3a3b85b4319eaa45038a6f11c0'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        if (url_typ == "toprated") {
          setState(() {
            topratedmovies =
                results.map((movie) => Movie.fromJson(movie)).toList();
          });
        }
      } else {
        print('API Request failed with status ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      // Handle error here
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220.0,
            backgroundColor: Colors.cyan,
            centerTitle: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              expandedTitleScale: 50,
              titlePadding: EdgeInsets.only(left: 50.0, bottom: 8.0), // Adjust padding as needed
              background: Container(
                margin: EdgeInsets.only(top: 40.0),
                child: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                ),
              ),
              title: Image.asset(
                'assets/images/mainlogo.png',
                width: 120,
                height: 50,
              ),
            ),
          ),


          SliverList(
            delegate: SliverChildListDelegate(
              [
                //Title
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 12, right: 12, top: 16),
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),

                //Tagline
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  child: Text(
                    tagline,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),
                ),

                //Genres
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    children: [
                      Row(
                        children: genres.map<Widget>((genre) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.pink,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              genre['name'],
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),

                //Official Videos
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          'Official Videos',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 12),
                      ),
                      SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: videosData.map((video) {
                            return GestureDetector(
                              onTap: () {
                                // Handle video tap action
                                NavigationVideoHelperPop.navigateToInfoPage(
                                    context, video['key'], widget.id);
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage('https://img.youtube.com/vi/${video['key']}/maxresdefault.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      video['name'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),


                // Latest Movies
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "Latest Movies",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                ),
                Container(
                  height: 170,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: topratedmovies.length,
                    itemBuilder: (context, index) {
                      final Movie topratedMovies = topratedmovies[index];
                      return GestureDetector(
                        onTap: () {
                          print('Item tapped: ${topratedMovies.id}');
                          NavigationHelperPop.navigateToInfoPage(
                              context, topratedMovies.id.toString());
                        },
                        child: Container(
                          width: 120,
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              'https://image.tmdb.org/t/p/w500/${topratedMovies.posterPath}',
                              fit: BoxFit
                                  .cover, // Use BoxFit.cover to maintain aspect ratio
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),


                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
