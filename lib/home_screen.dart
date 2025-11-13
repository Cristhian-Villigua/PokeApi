import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Lista que se muestra en pantalla (ya filtrada)
  List pokedex = [];

  /// Lista original completa sin filtros
  List allPokemon = [];

  /// Filtro por tipo
  String selectedType = 'Todos';

  /// Tipos disponibles
  List<String> availableTypes = ['Todos'];

  @override
  void initState() {
    super.initState();
    fetchPokemonData();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// Pokeball de fondo
          Positioned(
            top: -50,
            right: -50,
            child: Image.asset(
              'images/pokeball.png',
              width: 200,
            ),
          ),

          /// TÍTULO
          Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pokedex',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Cristhian Villigua',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Francisco Cedeño',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// CONTENIDO (filtro + grid)
          Positioned(
            top: 150,
            bottom: 60,
            width: width,
            child: Column(
              children: [
                /// 🔽 FILTRO POR TIPO
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButton<String>(
                      value: selectedType,
                      isExpanded: true,
                      underline: SizedBox(),
                      icon: Icon(Icons.keyboard_arrow_down),
                      items: availableTypes
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedType = value!;
                          _applyFilters();
                        });
                      },
                    ),
                  ),
                ),

                /// GRID DE POKÉMON
                Expanded(
                  child: pokedex.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.4,
                          ),
                          physics: BouncingScrollPhysics(),
                          itemCount: pokedex.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(5),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailScreen(
                                        heroTag: index,
                                        pokemonDetail: pokedex[index],
                                        color: _getTypeColor(
                                            pokedex[index]['type'][0]),
                                        pokedex: pokedex,
                                        currentIndex: index,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        _getTypeColor(pokedex[index]['type'][0]),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        bottom: -10,
                                        right: -10,
                                        child: Image.asset(
                                          'images/pokeball.png',
                                          height: 100,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 5,
                                        right: 5,
                                        child: Hero(
                                          tag: index,
                                          child: CachedNetworkImage(
                                            imageUrl: pokedex[index]['img'],
                                            height: 100,
                                            placeholder: (c, u) =>
                                                CircularProgressIndicator(),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 55,
                                        left: 15,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            pokedex[index]['type'][0],
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 30,
                                        left: 15,
                                        child: Text(
                                          pokedex[index]['name'],
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
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

          /// FOOTER
          Positioned(
            bottom: 45,
            width: width,
            child: Container(
              padding: EdgeInsets.all(10),
              color: Colors.black.withOpacity(0.8),
              child: Text(
                'Pokedex App - Powered by Cristhian Villigua & Francisco Cedeño',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// COLORES POR TIPO
  Color _getTypeColor(String type) {
    switch (type) {
      case "Grass":
        return Colors.greenAccent;
      case "Fire":
        return Colors.redAccent;
      case "Water":
        return Colors.blue;
      case "Poison":
        return Colors.deepPurpleAccent;
      case "Electric":
        return Colors.amber;
      case "Rock":
        return Colors.grey;
      case "Ground":
        return Colors.brown;
      case "Psychic":
        return Colors.indigo;
      case "Fighting":
        return Colors.orange;
      case "Bug":
        return Colors.lightGreenAccent;
      case "Ghost":
        return Colors.deepPurple;
      case "Normal":
        return Colors.black26;
      default:
        return Colors.pink;
    }
  }

  /// FILTRAR POR TIPO
  void _applyFilters() {
    List filtered = List.from(allPokemon);

    if (selectedType != 'Todos') {
      filtered = filtered
          .where((p) => (p['type'] as List).contains(selectedType))
          .toList();
    }

    setState(() => pokedex = filtered);
  }

  /// CARGAR JSON DESDE GITHUB
  void fetchPokemonData() {
    final url = Uri.https(
        'raw.githubusercontent.com', '/Biuni/PokemonGO-Pokedex/master/pokedex.json');

    http.get(url).then((value) {
      if (value.statusCode == 200) {
        final data = jsonDecode(value.body);

        allPokemon = data['pokemon'];
        availableTypes = _extractTypes(allPokemon);

        _applyFilters();
      }
    });
  }

  /// Obtener lista de tipos
  List<String> _extractTypes(List list) {
    final Set<String> types = {};

    for (var p in list) {
      for (var t in p['type']) {
        types.add(t.toString());
      }
    }

    return ['Todos', ...types.toList()..sort()];
  }
}
