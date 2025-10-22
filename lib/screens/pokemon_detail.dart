import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PokemonDetail extends StatefulWidget {
  final String name;
  final String url;

  const PokemonDetail({super.key, required this.name, required this.url});

  @override
  State<PokemonDetail> createState() => _PokemonDetailState();
}

class _PokemonDetailState extends State<PokemonDetail>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? pokemonData;
  bool isLoading = true;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    fetchPokemonDetail();
  }

  Future<void> fetchPokemonDetail() async {
    final response = await http.get(Uri.parse(widget.url));
    if (response.statusCode == 200) {
      setState(() {
        pokemonData = json.decode(response.body);
        isLoading = false;
      });
    } else {
      throw Exception('Error al cargar detalles del Pokémon');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final imageUrl = pokemonData!['sprites']['front_default'];
    final types = pokemonData!['types']
        .map((t) => t['type']['name'])
        .toList()
        .join(', ');
    final height = pokemonData!['height'];
    final weight = pokemonData!['weight'];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name.toUpperCase()),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: Tween<double>(begin: 1.0, end: 1.2).animate(
                CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
              ),
              child: Image.network(imageUrl, height: 250),
            ),
            const SizedBox(height: 20),
            Text(
              'Tipo: $types',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Altura: $height', style: const TextStyle(fontSize: 16)),
            Text('Peso: $weight', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
