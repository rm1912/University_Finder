import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:University_Finder/home_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  var session = [];
  var filteredSession = [];
  var country = '';
  var listC = 0;
  bool _isLoading = true;

  @override
  void initState() {
    country = HomePage.country;
    getData();
    super.initState();
  }

  getData() async {
    var url = Uri.parse('http://universities.hipolabs.com/search?country=$country');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      setState(() {
        session = decodedData;
        filteredSession = session;
        _isLoading = false;
      });

      setState(() {
        listC = session.length;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to filter universities based on the search query
  void filterUniversities(String query) {
    setState(() {
      filteredSession = session.where((university) {
        final name = university['name']?.toLowerCase() ?? '';
        return name.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          title: Text("Choose Your Dream University!"),
          centerTitle: true,
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
        ),
      ),
      body: Container(
        color: Colors.black,
        child: _isLoading
            ? _buildShimmerEffect()
            : StreamBuilder<Object>(
          stream: null,
          builder: (context, snapshot) {
            return StreamBuilder<Object>(
              stream: null,
              builder: (context, snapshot) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredSession.length,
                        itemBuilder: (BuildContext context, int index) {
                          final university = filteredSession[index];
                          return cardWidget(university);
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                // Implement the logic for navigating back here
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: Colors.white),
              label: Text('Back', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(primary: Colors.black),
            ),
            ElevatedButton.icon(
              onPressed: () {
                showSearch(context: context, delegate: UniversitySearch(session));
              },
              icon: Icon(Icons.search, color: Colors.white),
              label: Text('Search', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(primary: Colors.black),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Total Universities"),
                content: Text("You have selected $listC universities."),
                actions: <Widget>[
                  TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.info),
      ),
    );
  }

  cardWidget(var university) {
    return Container(
      height: 130,
      margin: const EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 20),
      decoration: BoxDecoration(
        color: Color(0xFF090909),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Left Side
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    university['name'] ?? '',
                    style: const TextStyle(fontSize: 17, color: Colors.white),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 10),
                  if (university['web_pages'] != null)
                    InkWell(
                      onTap: () {
                        launchUrl(Uri.parse(
                          university['web_pages']
                              .toString()
                              .replaceAll('[', '')
                              .replaceAll(']', ''),
                        ));
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.public,
                            color: Color.fromARGB(255, 8, 31, 180),
                            size: 25,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Website',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 8, 31, 180),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Right Side
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: ClipPath(
                clipper: DiagonalClipper(),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF536982), Colors.black],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (university['state-province'] != null)
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 15, color: Colors.white),
                              text: "State: ",
                              children: <TextSpan>[
                                TextSpan(
                                  text: university['state-province'] ?? '',
                                  style: const TextStyle(fontSize: 15, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        if (university['country'] != null)
                          Text(
                            university['country'] ?? '',
                            style: const TextStyle(color: Colors.white),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (ctx, i) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[300],
              radius: 30,
            ),
            title: Container(
              height: 12,
              width: double.infinity,
              color: Colors.grey[300],
            ),
            subtitle: Container(
              height: 10,
              width: 200,
              color: Colors.grey[300],
            ),
          ),
        );
      },
    );
  }
}

class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height * 0.7);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class UniversitySearch extends SearchDelegate {
  final List<dynamic> universities;

  UniversitySearch(this.universities);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView.builder(
      itemCount: universities.length,
      itemBuilder: (BuildContext context, int index) {
        final university = universities[index];
        return ListTile(
          title: Text(university['name'] ?? ''),
          subtitle: Text(university['country'] ?? ''),
          onTap: () {
            close(context, university);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<dynamic> suggestionList = query.isEmpty
        ? universities
        : universities.where((university) {
      final name = university['name']?.toLowerCase() ?? '';
      return name.contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (BuildContext context, int index) {
        final university = suggestionList[index];
        return ListTile(
          title: Text(university['name'] ?? ''),
          subtitle: Text(university['country'] ?? ''),
          onTap: () {
            close(context, university);
          },
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ResultPage(),
  ));
}
