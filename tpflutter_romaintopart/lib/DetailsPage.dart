import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:tpflutter_romaintopart/SearchPage.dart';

class DetailsPage extends StatelessWidget {
  DetailsPage({super.key, required this.id});

late String id;
  @override
  Widget build(BuildContext context) {
    return DetailsPageFilm(id: id,);
  }
}

class DetailsPageFilm extends StatefulWidget {
  DetailsPageFilm({super.key, required this.id});

  late String id;

  @override
  DetailsPageFilmState createState() => DetailsPageFilmState();
}
class DetailsPageFilmState extends State<DetailsPageFilm> {
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Détails du film'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage()));
              
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
    Uri uri =Uri.http('www.omdbapi.com','',{'i': widget.id,'apikey' : 'efbad62e'});
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
          CircularProgressIndicator(color: Colors.deepOrange,strokeCap: StrokeCap.round),
        ],
      ),
    );
  }

  Widget affichage() {

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '${film['Title']}',
            style: const TextStyle(
                color: Colors.amberAccent,
                fontSize: 30.0,
                fontWeight: FontWeight.bold),
          ),
          Text(
            '${film['Year']}',
            style: const TextStyle(color: Colors.white),
          ),
          const Padding(padding: EdgeInsets.all(15.0)),
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            decoration: const BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.white,
                  offset: Offset(0.0, 7.0),
                  spreadRadius: 3.0,
                  blurRadius: 15.0)
            ]),
            child:
                Image.network('${film['Poster']}')
          ),
          const Padding(padding: EdgeInsets.all(15.0)),
          Text('Synopsis:', style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold ),),
          Text(
            '${film['Plot']}',
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
            softWrap: true,
          ),
          const Padding(padding: EdgeInsets.all(15.0)),
              Text('Acteurs:', style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold ),),
          Text(
                '${film['Actors']}',
                style: const TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () async {
    },
    child:  Text("Regarder ${film['Title']}" ,style: const TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold ),),style: ElevatedButton.styleFrom(primary: Colors.deepOrange),)
        ],
      ),
    );
  }
}