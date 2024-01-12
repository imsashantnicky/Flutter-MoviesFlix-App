import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/util.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Movie> movies = [];
  List<Movie> featcheredmovies = [];
  List<Movie> upcomingmovies = [];
  List<Movie> topratedmovies = [];

  final Uri popularMoviesUrl = Uri.parse(
      'https://api.themoviedb.org/3/movie/popular?api_key=6a215d3a3b85b4319eaa45038a6f11c0');
  final Uri featcheredMoviesUrl = Uri.parse(
      'https://api.themoviedb.org/3/trending/movie/day?api_key=6a215d3a3b85b4319eaa45038a6f11c0');
  final Uri upcomingMoviesUrl = Uri.parse(
      'https://api.themoviedb.org/3/movie/upcoming?api_key=6a215d3a3b85b4319eaa45038a6f11c0');
  final Uri topratedMoviesUrl = Uri.parse(
      'https://api.themoviedb.org/3/movie/top_rated?api_key=6a215d3a3b85b4319eaa45038a6f11c0');

  int currentPage = 0;
  late PageController pageController;
  late Timer timer;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData(popularMoviesUrl, "popular");
    fetchData(featcheredMoviesUrl, "featchered");
    fetchData(upcomingMoviesUrl, "upcoming");
    fetchData(topratedMoviesUrl, "toprated");

    // Initialize the page controller and set up a timer
    pageController = PageController(initialPage: currentPage);
    timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (currentPage < featcheredmovies.length - 1) {
        currentPage++;
      } else {
        currentPage = 0;
      }

      pageController.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    // Cancel the timer and dispose of the page controller when the widget is disposed
    timer.cancel();
    pageController.dispose();
    super.dispose();
  }

  Future<void> fetchData(Uri url, String url_typ) async {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];

      if (url_typ == "featchered") {
        setState(() {
          featcheredmovies =
              results.map((movie) => Movie.fromJson(movie)).toList();
        });
      } else if (url_typ == "popular") {
        setState(() {
          movies = results.map((movie) => Movie.fromJson(movie)).toList();
        });
      } else if (url_typ == "upcoming") {
        setState(() {
          upcomingmovies =
              results.map((movie) => Movie.fromJson(movie)).toList();
        });
      } else if (url_typ == "toprated") {
        setState(() {
          topratedmovies =
              results.map((movie) => Movie.fromJson(movie)).toList();
          isLoading = false;
        });
      }
    } else {
      print('API Request failed with status ${response.statusCode}');
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
      drawer: Drawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // LinearProgressIndicator
            if (isLoading)
              Container(
                child: LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  backgroundColor: Colors.cyan,
                ),
              ),

            if (!isLoading)
            Container(
              child: Column(
                children: [
                  // Top Banner Design
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 320,
                    margin: EdgeInsets.only(bottom: 8),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        PageView.builder(
                          controller: pageController,
                          itemCount: featcheredmovies.length,
                          itemBuilder: (context, index) {
                            final Movie featuredMovies = featcheredmovies[index];
                            return GestureDetector(
                              onTap: () {
                                print('Item tapped: ${featuredMovies.id}');
                                NavigationHelper.navigateToInfoPage(
                                    context, featuredMovies.id.toString());
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.cyan, Colors.black],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      child: Image.network(
                                        'https://image.tmdb.org/t/p/w500/${featuredMovies.posterPath}',
                                        fit: BoxFit.contain,
                                        width: 400,
                                        height: 250,
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 30,
                                      margin: EdgeInsets.all(5),
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        featuredMovies.title,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 18),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              featcheredmovies.length > 5
                                  ? 5
                                  : featcheredmovies.length,
                              // Display only 4 dots or the number of movies if less than 4
                              (index) {
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Latest Movies
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "Latest Movies",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Container(
                    height: 170,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: upcomingmovies.length,
                      itemBuilder: (context, index) {
                        final Movie upcomingMovies = upcomingmovies[index];
                        return GestureDetector(
                          onTap: () {
                            print('Item tapped: ${upcomingMovies.id}');
                            NavigationHelper.navigateToInfoPage(
                                context, upcomingMovies.id.toString());
                          },
                          child: Container(
                            width: 120,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                'https://image.tmdb.org/t/p/w500/${upcomingMovies.posterPath}',
                                fit: BoxFit
                                    .cover, // Use BoxFit.cover to maintain aspect ratio
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Popular Movies
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 8, left: 8),
                    child: Text(
                      "Popular Movies",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Container(
                    height: 170,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        final Movie movie = movies[index];
                        return GestureDetector(
                          onTap: () {
                            print('Item tapped: ${movie.id}');
                            NavigationHelper.navigateToInfoPage(
                                context, movie.id.toString());
                          },
                          child: Container(
                            width: 120,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                                fit: BoxFit
                                    .cover, // Use BoxFit.cover to maintain aspect ratio
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Trending Movies
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 8, left: 8),
                    child: Text(
                      "Trending Movies",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        final Movie featuredMovies = featcheredmovies[index];
                        return GestureDetector(
                          onTap: () {
                            print('Item tapped: ${featuredMovies.id}');
                            NavigationHelper.navigateToInfoPage(
                                context, featuredMovies.id.toString());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                              gradient: LinearGradient(
                                colors: [Colors.cyan, Colors.cyan],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            width: 300,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    'https://image.tmdb.org/t/p/w500/${featuredMovies.backPosterPath}',
                                    fit: BoxFit.cover,
                                    width: 300,
                                    height: 170,
                                  ),
                                ),
                                Container(
                                  width: 300,
                                  height: 25,
                                  margin: EdgeInsets.all(5),
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    featuredMovies.title,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 18),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(featuredMovies.overview,
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                      maxLines: 3,
                                      textAlign: TextAlign.center),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        'IMDB : ${featuredMovies.rating}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Top Rated Movies
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 8, left: 8),
                    child: Text(
                      "Top Rated Movies",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                        final Movie topRatedMovies = topratedmovies[index];
                        return GestureDetector(
                          onTap: () {
                            print('Item tapped: ${topRatedMovies.id}');
                            NavigationHelper.navigateToInfoPage(
                                context, topRatedMovies.id.toString());
                          },
                          child: Container(
                            width: 120,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                'https://image.tmdb.org/t/p/w500/${topRatedMovies.posterPath}',
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
                    height: 8,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

