import 'package:flutter/material.dart';
import 'screens/pokemon.dart';
import 'screens/perros.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'API Navigation',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
      routes: {
        '/pokemon': (context) => PokemonApp(),
        '/dog': (context) => DogApp(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF8E1),
      appBar: AppBar(
        title: Text('PokeApi vs DogApi',
        style: TextStyle(
            fontSize: 26, // Tamaño del texto
            fontWeight: FontWeight.bold, // Texto en negrita
            color: Colors.yellow[700], // Color del texto negro
            fontFamily: 'Roboto', // Familia de fuente opcional
            letterSpacing: 1.5, // Espaciado entre letras
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Imagen del Pokémon
            Image.asset(
              '../assets/images/pokemon.png', // Asegúrate de que la imagen esté en esta ruta
              width: 150, // Ajusta el tamaño de la imagen
              height: 150,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/pokemon');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow, // Fondo amarillo
                foregroundColor: Colors.black, // Letras negras
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: Text('Ver Pokémones'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/dog');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Fondo verde
                foregroundColor: Colors.white, // Letras blancas
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: Text('Ver Perritos'),
            ),
            SizedBox(height: 20),
            // Imagen del perro
            Image.asset(
              '../assets/images/perro.png', // Asegúrate de tener esta imagen en tu carpeta de assets
              width: 150,
              height: 150,
            ),
          ],
        ),
      ),
    );
  }
}
