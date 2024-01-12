import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/util.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Movie> searchedmovies = [];
  bool isTextFieldEmpty = true;

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchData(String searchInputTxt, String url_typ) async {
    final Uri url = Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=6a215d3a3b85b4319eaa45038a6f11c0&query=' +
            searchInputTxt);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];

      if (url_typ == "search") {
        setState(() {
          searchedmovies =
              results.map((movie) => Movie.fromJson(movie)).toList();
        });
      }
    } else {
      print('API Request failed with status ${response.statusCode}');
    }
  }

  String extractYearFromDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return dateTime.year.toString();
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
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    isTextFieldEmpty = value.isEmpty;
                    fetchData(value, "search");
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
              ),
            ),
            if (!isTextFieldEmpty)
              Container(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "Results",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height *
                          0.65, // Adjust the multiplier as needed
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
                              child: Row(
                                children: [
                                  Container(
                                    height: 80,
                                    width: 150,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        'https://image.tmdb.org/t/p/w500/${searchedMovies.backPosterPath}',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 80,
                                    child: Column(
                                      children: [
                                        Container(
                                          child: Text(
                                            searchedMovies.title,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                            maxLines: 1,
                                          ),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 5,
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            extractYearFromDate(
                                                searchedMovies.releaseDate),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11),
                                            maxLines: 1,
                                          ),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 1),
                                        ),
                                        Container(
                                          child: Text(
                                            searchedMovies.overview,
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 10),
                                            maxLines: 2,
                                          ),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
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
            if (isTextFieldEmpty)
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 140),
                  child: Opacity(
                    opacity: 0.8,
                    child: Image.asset(
                      'assets/images/empty_movie_icon.png',
                      fit: BoxFit.cover,
                      height: 150,
                      width: 200,
                    ),
                  ),
                ),
              ),

            Container(
              child: Text(
                "Explore your favorait movies!", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black38, fontSize: 18),
              )
            ),

          ],
        ),
      ),
    );
  }
}
