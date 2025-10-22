import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'screens/pokemon_detail.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokemon App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List _pokemonList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    feachPokemon();
  }

  Future<void> feachPokemon() async{
    const url = 'https://pokeapi.co/api/v2/pokemon?limit=50';
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      final data = json.decode(response.body);
      setState((){
        _pokemonList = data['results'];
        _isLoading = false;
      });
    } else {
      throw Exception('failed to load pokemon');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokedex',
          style: TextStyle(color: Colors.white)
        ),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: _isLoading
      ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
          itemCount: _pokemonList.length,
          itemBuilder: (context, index){
            final pokemon = _pokemonList[index];
            final pokeId = index + 1;
            final imageUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$pokeId.png';
            return ListTile(
                leading: Hero(
                  tag: pokemon['name'],
                  child: Image.network(imageUrl),
                ),
                title: Text(
                  pokemon['name'].toString().toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PokemonDetail(
                    name: pokemon['name'],
                    url: pokemon['url'],
                    ),
                  ),
                  );
                },
            );

          },
        ),
    );
  }
}