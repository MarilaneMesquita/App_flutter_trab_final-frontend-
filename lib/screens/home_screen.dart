import 'package:flutter/material.dart';
import 'clientes_screen.dart';
import 'produtos_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key); // Construtor declarado como const

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        // Implementar itens do menu
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('CRUD App'),
              accountEmail: Text('Bem-vindo!'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40),
              ),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Clientes'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ClientesScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag),
              title: Text('Produtos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProdutosScreen()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('CRUD App'),
      ),
      body: Center(
        child: Text(
          'Bem-vindo a Papelex',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
