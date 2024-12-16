import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(DogApp());
}

class DogApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Dog',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DogHomePage(),
    );
  }
}

class DogHomePage extends StatefulWidget {
  @override
  _DogHomePageState createState() => _DogHomePageState();
}

class _DogHomePageState extends State<DogHomePage> {
  String? _imageUrl;
  bool _isLoading = false;

  Future<void> fetchRandomDog() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('https://random.dog/woof.json');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _imageUrl = data['url'];
          _isLoading = false;
        });
      } else {
        throw Exception('Error al cargar la imagen del perro.');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRandomDog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DogApi',
        style: TextStyle(
            fontSize: 26, // Tamaño del texto
            fontWeight: FontWeight.bold, // Texto en negrita
            color: Colors.green, // Color del texto negro
            fontFamily: 'Roboto', // Familia de fuente opcional
            letterSpacing: 1.5, // Espaciado entre letras
          ),
        
        ),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : _imageUrl != null
                ? Image.network(_imageUrl!)
                : Text('No se pudo cargar la imagen.'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchRandomDog,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
