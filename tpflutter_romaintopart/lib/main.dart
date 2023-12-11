import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tpflutter_romaintopart/DetailsPage.dart';
import 'dart:convert' as convert;

import 'package:tpflutter_romaintopart/SearchPage.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Omdb Demo pour prépa TP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  late Map<String, dynamic> film;
  bool dataOK = false;

  @override
  void initState() {
    recupFilm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TP Topart Romain'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SearchPage()));
            },
          )
        ],
        backgroundColor: Colors.black,
      ),
      body: dataOK ? affichage() : attente(),
      backgroundColor: Colors.blueGrey[900],
    );
  }

  Future<void> recupFilm() async {
    Uri uri =
        Uri.http('www.omdbapi.com', '', {'apikey': 'efbad62e', 's': 'avatar'});
    http.Response response = await http.get(uri);
    if (response.statusCode == 200) {
      film = convert.jsonDecode(response.body) as Map<String, dynamic>;
      setState(() {
        dataOK = !dataOK;
      });
    }
  }

  Widget attente() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('En attente des données',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold)),
          CircularProgressIndicator(
              color: Colors.deepOrange, strokeCap: StrokeCap.round),
        ],
      ),
    );
  }

  Widget affichage() {
  return SingleChildScrollView(
    child: Column(
      children: [
        const SizedBox(height: 10,),
        const Text(
          'Les films à la une',
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10,),
        CarouselSlider(
          options: CarouselOptions(
            enlargeFactor: 0.0,
            autoPlayCurve: accelerateEasing,
            disableCenter: true,
            pageSnapping: false,
            autoPlay: true,
            aspectRatio: 1.0,
            enlargeCenterPage: true,
          ),
          items: film['Search'].map<Widget>((item) {
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailsPage(
                                  id: item['imdbID'],
                                )));
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1.0),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Image.network(
                      item['Poster'],
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 10,),
        Text('Parcourez les différentes catégories',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold ),),
        const SizedBox(height: 10,),
        ListTile(
          title: Text('Action',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold ),),
        ),
        ListTile(
          title: Text('Aventure',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold ),),
        ),
        ListTile(
          title: Text('Comédie',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold ),),
        ),
        ListTile(
          title: Text('Drame',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold ),),
        ),
        ListTile(
          title: Text('Fantastique',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold ),),
        ),
  
      ],
    ),
  );
}

}
