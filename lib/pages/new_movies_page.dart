import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/util.dart';

class NewMoviesPage extends StatefulWidget {
  @override
  State<NewMoviesPage> createState() => _NewMoviesPageState();
}

class _NewMoviesPageState extends State<NewMoviesPage> {
  List<Movie> searchedmovies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData("upcoming");
  }

  Future<void> fetchData(String url_typ) async {
    final Uri url = Uri.parse(
        'https://api.themoviedb.org/3/movie/upcoming?api_key=6a215d3a3b85b4319eaa45038a6f11c0');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];

      if (url_typ == "upcoming") {
        setState(() {
          searchedmovies = results
              .map((movie) => Movie.fromJson(movie))
              .where((movie) => movie.title != null) // Check if title is not null
              .toList();
          isLoading = false;
        });

        // Print the first movie title for verification
        print('First movie title: ${searchedmovies.isNotEmpty ? searchedmovies[0].title : 'No movies available'}');
      }
    } else {
      print('API Request failed with status ${response.statusCode}');
    }
  }

  String extractDayFromDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return dateTime.day.toString();
  }

  String convertDateToMonthText(String dateString) {
    final DateTime dateTime = DateTime.parse(dateString);
    final List<String> monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final String monthText = monthNames[dateTime.month - 1];
    return monthText;
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
      body: Column(
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.79,
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: searchedmovies.length,
                            itemBuilder: (context, index) {
                              final Movie searchedMovies = searchedmovies[index];
                              return GestureDetector(
                                onTap: () {
                                  print('Item tapped: ${searchedMovies.id}');
                                  NavigationHelper.navigateToInfoPage(
                                    context,
                                    searchedMovies.id.toString(),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          alignment: Alignment.bottomLeft,
                                          height: 250,
                                          margin: EdgeInsets.only(right: 16),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                extractDayFromDate(searchedMovies.releaseDate), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                                              ),
                                              Text(
                                                convertDateToMonthText(searchedMovies.releaseDate), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                                              ),
                                            ],
                                          ),
                                        ),

                                        Container(
                                          width: 250,
                                          height: 250,
                                          alignment: Alignment.topRight,
                                          child: Column(
                                            children: [
                                              Container(
                                                child: Stack(
                                                  children: [
                                                    // Image
                                                    Container(
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(10),
                                                        child: Image.network(
                                                          searchedMovies.backPosterPath != null && searchedMovies.backPosterPath.isNotEmpty
                                                              ? 'https://image.tmdb.org/t/p/w500/${searchedMovies.backPosterPath}'
                                                              : 'assets/images/noposter.png',
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    // Play Button
                                                    Positioned(
                                                      bottom: 8,
                                                      right: 8,
                                                      child: Container(
                                                        padding: EdgeInsets.all(1),
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Colors.white,
                                                        ),
                                                        child: Icon(
                                                          Icons.play_arrow,
                                                          color: Colors.blue,
                                                          size: 35,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              Container(
                                                alignment: Alignment.topLeft,
                                                margin: EdgeInsets.symmetric(vertical: 5),
                                                child: Text(
                                                  searchedMovies.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                ),
                                              ),

                                              Container(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  searchedMovies.overview, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                                  maxLines: 3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}