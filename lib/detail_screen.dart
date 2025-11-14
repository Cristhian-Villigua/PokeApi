import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final heroTag;
  final pokemonDetail;
  final Color color;
  final List pokedex;
  final int currentIndex;

  const DetailScreen({
    Key? key,
    this.heroTag,
    this.pokemonDetail,
    required this.color,
    required this.pokedex,
    required this.currentIndex,
  }) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late int currentIndex;
  late Map currentPokemon;
  late Color currentColor;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;
    currentPokemon = Map.from(widget.pokemonDetail);
    currentColor = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: currentColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          /// back button
          Positioned(
            top: 30,
            left: 5,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          /// name and number
          Positioned(
            top: 70,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  currentPokemon['name'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "#" + currentPokemon['num'],
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),

          /// type
          Positioned(
            top: 110,
            left: 22,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                currentPokemon['type'].join(", "),
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),

          /// pokeball background
          Positioned(
            top: height * 0.18,
            right: -30,
            child: Image.asset(
              'images/pokeball.png',
              height: 200,
            ),
          ),

          /// content card
          Positioned(
            bottom: 0,
            child: Container(
              width: width,
              height: height * 0.6,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    _infoRow(width, 'Name', currentPokemon['name']),
                    _infoRow(width, 'Height', currentPokemon['height']),
                    _infoRow(width, 'Weight', currentPokemon['weight']),
                    _infoRow(width, 'Spawn Time', currentPokemon['spawn_time']),
                    _infoRow(width, 'Weaknesses',
                        currentPokemon['weaknesses'].join(", ")),
                  ],
                ),
              ),
            ),
          ),

          /// main image
          Positioned(
            top: height * 0.2,
            left: (width / 2) - 100,
            child: Hero(
              tag: widget.heroTag,
              child: CachedNetworkImage(
                height: 200,
                width: 200,
                imageUrl: currentPokemon['img'],
              ),
            ),
          ),

          /// PREVIOUS / NEXT BUTTONS
          Positioned(
            bottom: 15,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: currentIndex > 0 ? _previous : null,
                  icon: Icon(Icons.arrow_back),
                  label: Text("Anterior"),
                ),
                ElevatedButton.icon(
                  onPressed:
                      currentIndex < widget.pokedex.length - 1 ? _next : null,
                  icon: Icon(Icons.arrow_forward),
                  label: Text("Siguiente"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(double width, String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Container(
            width: width * 0.3,
            child: Text(title,
                style: TextStyle(color: Colors.blueGrey, fontSize: 17)),
          ),
          Expanded(
            child: Text(value,
                style: TextStyle(color: Colors.black, fontSize: 17)),
          ),
        ],
      ),
    );
  }

  void _previous() {
    if (currentIndex <= 0) return;

    setState(() {
      currentIndex--;
      currentPokemon = widget.pokedex[currentIndex];
      currentColor = _typeColor(currentPokemon['type'][0]);
    });
  }

  void _next() {
    if (currentIndex >= widget.pokedex.length - 1) return;

    setState(() {
      currentIndex++;
      currentPokemon = widget.pokedex[currentIndex];
      currentColor = _typeColor(currentPokemon['type'][0]);
    });
  }

  /// color mapping
  Color _typeColor(String type) {
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
}
