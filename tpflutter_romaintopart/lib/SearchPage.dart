import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

import 'package:tpflutter_romaintopart/DetailsPage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Map<String, dynamic> film;
  bool dataOK = false;

  late String searchTitle = "";
  List<String> recherche = <String>[];
  List<String> titresRecherches = <String>[]; // Nouvelle liste pour stocker les titres

  Future<void> recupFilmSearch(String search) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setStringList('recherche', <String>[search]);

    recherche = prefs.getStringList('recherche') ?? [];

    titresRecherches.add(search);
    await prefs.setStringList('titresRecherches', titresRecherches);

    setState(() {
      dataOK = false;
    });

    Uri uri = Uri.http(
        'www.omdbapi.com', '', {'s': search, 'apikey': 'efbad62e'});
    http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      film = convert.jsonDecode(response.body) as Map<String, dynamic>;

      setState(() {
        dataOK = true;
      });
    }
  }

  @override
  void initState() {
    rechercheprecedentes();
    super.initState();
  }

  Future<void> rechercheprecedentes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    recherche = prefs.getStringList('recherche') ?? [];
    titresRecherches = prefs.getStringList('titresRecherches') ?? [];
    setState(() {
      dataOK = false;
    });
  }

  late final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Page'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _controller,
                onChanged: (value) {
                },
                onSubmitted: (value) async {
                  setState(() {
                    searchTitle = value;
                  });
                  await recupFilmSearch(searchTitle);
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Search',
                ),
              ),
              dataOK
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: 200,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailsPageFilm(
                                      id: film['Search'][index]['imdbID'],
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 180,
                                      width: 100,
                                      child: Image.network(
                                        film['Search'][index]['Poster'],
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: film['Search'].length,
                      ),
                    )
                  : ListTile(
                      title: titresRecherches.isEmpty
                          ? const Text('Pas de recherche')
                          : Column(
                              children: [const Text('Titres des recherches précédentes:'),
                                for (var item in titresRecherches.reversed) GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      searchTitle = item;
                                    });
                                    recupFilmSearch(searchTitle);
                                  
                                  },
                                  child: Text(item, style: const TextStyle(fontSize: 20),)),
                              ],
                            ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
