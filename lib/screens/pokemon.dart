import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(PokemonApp());
}

class PokemonApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokémon API',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PokemonSearchScreen(),
    );
  }
}

class PokemonSearchScreen extends StatefulWidget {
  @override
  _PokemonSearchScreenState createState() => _PokemonSearchScreenState();
}

class _PokemonSearchScreenState extends State<PokemonSearchScreen> {
  Map<String, dynamic>? _selectedPokemonDetails;
  bool _isLoading = false;
  String? _errorMessage;

  // Función para obtener los detalles del Pokémon seleccionado
  Future<void> fetchPokemonDetails(String name) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$name');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _selectedPokemonDetails = {
            'name': data['name'],
            'image': data['sprites']['front_default'],
            'types': (data['types'] as List)
                .map((type) => type['type']['name'])
                .toList(),
            'weight': data['weight'],
            'height': data['height'],
            'stats': (data['stats'] as List).map((stat) {
              return {
                'name': stat['stat']['name'],
                'value': stat['base_stat'],
              };
            }).toList(),
          };
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Pokémon no encontrado.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al buscar el Pokémon.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PokeApi',
        style: TextStyle(
            fontSize: 26, // Tamaño del texto
            fontWeight: FontWeight.bold, // Texto en negrita
            color: Colors.yellow[600], // Color del texto negro
            fontFamily: 'Roboto', // Familia de fuente opcional
            letterSpacing: 1.5, // Espaciado entre letras
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final result = await showSearch(
                context: context,
                delegate: PokemonSearchDelegate(fetchPokemonDetails),
              );
              if (result != null) {
                fetchPokemonDetails(result);
              }
            },
          ),
        ],
      ),
      //-----------------------------------------
      body: _isLoading
    ? Center(child: CircularProgressIndicator())
    : _errorMessage != null
        ? Center(child: Text(_errorMessage!))
        : _selectedPokemonDetails == null
            ? Center(child: Text('Busca un Pokémon para ver sus detalles.'))
            : Center( // Este widget centra la tarjeta en toda la pantalla
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.all(16), // Margen externo
                    padding: EdgeInsets.all(16), // Espaciado interno
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12), // Bordes redondeados
                      border: Border.all(color: Colors.white54, width: 2), // Borde azul
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3), // Sombra ligera
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _selectedPokemonDetails!['image'] != null
                            ? Image.network(_selectedPokemonDetails!['image'])
                            : Icon(Icons.image_not_supported, size: 100),
                        SizedBox(height: 10),
                        Text(
                          _selectedPokemonDetails!['name'].toUpperCase(),
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Altura: ${_selectedPokemonDetails!['height']}',
                          style: TextStyle(fontSize: 18, color: Colors.black87),
                        ),
                        Text(
                          'Peso: ${_selectedPokemonDetails!['weight']}',
                          style: TextStyle(fontSize: 15, color: Colors.black87),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Tipos: ${(_selectedPokemonDetails!['types'] as List).join(', ')}',
                          style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Estadísticas:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 8),
                        ...(_selectedPokemonDetails!['stats'] as List).map((stat) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              '${stat['name']}: ${stat['value']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ),


    );
  }
}

class PokemonSearchDelegate extends SearchDelegate {
  final Function(String) onPokemonSelected;

  PokemonSearchDelegate(this.onPokemonSelected);

  Future<List<String>> fetchPokemonSuggestions(String query) async {
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=1000');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results
          .map<String>((pokemon) => pokemon['name'])
          .where((name) => name.contains(query.toLowerCase()))
          .toList();
    }
    return [];
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onPokemonSelected(query);
    close(context, query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: fetchPokemonSuggestions(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final suggestions = snapshot.data!;
        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final suggestion = suggestions[index];
            return ListTile(
              title: Text(suggestion),
              onTap: () {
                query = suggestion;
                close(context, suggestion);
              },
            );
          },
        );
      },
    );
  }
}
