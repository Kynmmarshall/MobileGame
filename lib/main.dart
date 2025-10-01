import 'package:flutter/material.dart';
import 'package:game/firstpage.dart';
import 'package:game/secondpage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/FirstPage': (context) => FirstPage(),
        '/SecondPage': (context) => SecondPage(),
        '/HomePage': (context) => HomeScreen(),
      },
      home: const HomeScreen(), // Use separate widget
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: const Text("KYNM Game"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 118, 240, 144),
        elevation: 0,
        actions: [
          ElevatedButton(onPressed: () => '/HomePage', child: const Icon(Icons.home, color: Colors.black, size: 30)),
          const Padding(padding: EdgeInsets.only(right: 10)),
          const Icon(Icons.search, color: Colors.black, size: 30),
          const Padding(padding: EdgeInsets.only(right: 10)),
          const Icon(Icons.menu, color: Colors.black, size: 30),
          const Padding(padding: EdgeInsets.only(right: 10)),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text(
            "GO TO FIRST PAGE",
            style: TextStyle(color: Colors.green),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/FirstPage');
          },
        ),
      ),
    );
  }
}