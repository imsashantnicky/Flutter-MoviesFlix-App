import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_moviesflix_app/pages/video_player_page.dart';
import 'dart:convert';
import '../utils/util.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class InfoPage extends StatefulWidget {
  final String id;

  InfoPage({required this.id});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
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
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    fetchData();
    fetchCast();
    fetchVideos();
    fetchMoviesData("toprated");
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/${widget.id}?api_key=6a215d3a3b85b4319eaa45038a6f11c0'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data != null) {
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
            isLoading = false;
          });
        }
      } else {
        print('API Request failed with status ${response.statusCode}');
        // Handle error here
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchCast() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(
        Uri.parse(
            'https://api.themoviedb.org/3/movie/${widget.id}/credits?api_key=6a215d3a3b85b4319eaa45038a6f11c0'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> castData = json.decode(response.body);
        setState(() {
          cast = List<Map<String, dynamic>>.from(castData['cast']);
          isLoading = false;
        });
      } else {
        print('API Request failed with status ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchVideos() async {
    setState(() {
      isLoading = true;
    });
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
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load videos');
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchMoviesData(String url_typ) async {
    setState(() {
      isLoading = true;
    });
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
            isLoading = false;
          });
        }
      } else {
        print('API Request failed with status ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        centerTitle: true,
        title: Image.asset(
          'assets/images/mainlogo.png',
          width: 130,
          height: 50,
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          if (posterPath!='')
            Image.network(
              'https://image.tmdb.org/t/p/w500$posterPath',
              fit: BoxFit.cover,
            ),

            // Overlay gradient covering the entire image
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.cyan.withOpacity(0.9),
                    Colors.black.withOpacity(0.9),
                    Colors.black.withOpacity(0.9),
                    // Use the same color for both ends to make it solid
                  ],
                ),
              ),
            ),

          //Main Content
          SingleChildScrollView(
            child: Column(
              children: [

                // LinearProgressIndicator
                if (isLoading)
                  Container(
                    child: LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: Colors.white30,
                    ),
                  ),



                if (!isLoading)
                Container(
                  child: Column(
                    children: [
                      //Top Banner
                      if (posterPath!='')
                        Container(
                          margin: EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              'https://image.tmdb.org/t/p/w500$posterPath',
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                              height: 500,
                            ),
                          ),
                        ),

                      //Title
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.symmetric(horizontal: 12),
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

                      //Overview
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                        child: Text(
                          "Overview",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        child: Text(
                          overview,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      //Released Data
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            //Status
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    child: Text(
                                      "Overview",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      status,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              width: 20,
                            ),

                            //Release Date
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    child: Text(
                                      "Release Date",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      releaseDate,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              width: 20,
                            ),

                            //Run Time
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    child: Text(
                                      "Run time",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      runtime.toString() + " min",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      //Top Cast
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Top Cast',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              height: 140,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: cast.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(horizontal: 8),
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 40,
                                          backgroundImage: NetworkImage(
                                            'https://image.tmdb.org/t/p/w200/${cast[index]['profile_path']}',
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          cast[index]['name'],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
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
                            Container(
                              height: 150,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: videosData.length,
                                itemBuilder: (context, index) {
                                  final video = videosData[index];

                                  return GestureDetector(
                                    onTap: () {
                                      // Handle video tap action
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              VideoPlayerPage(videoKey: video['key'], id: movieId.toString()),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(horizontal: 8),
                                      width: 200,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 200,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    'https://img.youtube.com/vi/${video['key']}/maxresdefault.jpg'),
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
                                },
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
          ),

        ],
      ),
    );
  }
}
