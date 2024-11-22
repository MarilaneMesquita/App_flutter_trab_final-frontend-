import 'package:flutter/material.dart';
import '../models/cliente.dart';
import '../services/api_service.dart';
import 'cliente_form_screen.dart';

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({Key? key}) : super(key: key);

  @override
  _ClientesScreenState createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  late Future<List<Cliente>> futureClientes;

  @override
  void initState() {
    super.initState();
    futureClientes = ApiService.fetchClientes();
  }

  void _refreshClientes() {
    setState(() {
      futureClientes = ApiService.fetchClientes();
    });
  }

  void _confirmDelete(int clienteId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Exclusão'),
          content: Text('Tem certeza que deseja excluir este cliente?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Excluir'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                ApiService.deleteCliente(clienteId).then((_) {
                  Navigator.of(context).pop();
                  _refreshClientes();
                });
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildClienteCard(Cliente cliente) {
    return GestureDetector(
      onTap: () {
        // Navegar para detalhes ou editar
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClienteFormScreen(cliente: cliente),
          ),
        ).then((value) {
          if (value == true) {
            _refreshClientes();
          }
        });
      },
      child: Card(
        elevation: 6,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: EdgeInsets.all(8), // Reduzido para economizar espaço
          child: Column(
            mainAxisSize: MainAxisSize.min, // Adicionado para evitar overflow
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Foto do Cliente
              CircleAvatar(
                radius: 30,
                backgroundImage: cliente.foto != null && cliente.foto!.isNotEmpty
                    ? NetworkImage(cliente.foto!)
                    : AssetImage('assets/images/default_avatar.png') as ImageProvider,
              ),
              SizedBox(height: 5),
              // Nome do Cliente
              Text(
                '${cliente.nome} ${cliente.sobrenome}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 3),
              // Email do Cliente
              Text(
                cliente.email,
                style: TextStyle(fontSize: 13, color: Colors.grey[700]), 
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 3),
              // Idade do Cliente
              Text(
                'Idade: ${cliente.idade}',
                style: TextStyle(fontSize: 13, color: Colors.grey[700]), 
              ),
              SizedBox(height: 5), 
              // Botões de Ações
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    iconSize: 20,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClienteFormScreen(cliente: cliente),
                        ),
                      ).then((value) {
                        if (value == true) {
                          _refreshClientes();
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    iconSize: 20,
                    onPressed: () {
                      _confirmDelete(cliente.id!);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClientesGrid(List<Cliente> clientes) {
    // Determinar o número de colunas com base na largura da tela
    int crossAxisCount = 2; // Valor padrão

    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= 1200) {
      crossAxisCount = 5;
    } else if (screenWidth >= 900) {
      crossAxisCount = 4;
    } else if (screenWidth >= 600) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 2;
    }

    // Ajustar o childAspectRatio com base no número de colunas
    double childAspectRatio = 0.8;

    if (crossAxisCount >= 4) {
      childAspectRatio = 0.9; // Cartões mais largos em telas maiores
    } else if (crossAxisCount == 2) {
      childAspectRatio = 0.9; // Aumentar a altura em dispositivos móveis
    }

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: clientes.length,
      itemBuilder: (context, index) {
        return _buildClienteCard(clientes[index]);
      },
    );
  }

  Widget _buildBody() {
    return FutureBuilder<List<Cliente>>(
      future: futureClientes,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Cliente> clientes = snapshot.data!;
          if (clientes.isEmpty) {
            return Center(
              child: Text(
                'Nenhum cliente encontrado.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              _refreshClientes();
            },
            child: _buildClientesGrid(clientes),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Erro: ${snapshot.error}',
              style: TextStyle(color: Colors.red),
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clientes'),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Adicionar Cliente',
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClienteFormScreen(),
            ),
          ).then((value) {
            if (value == true) {
              _refreshClientes();
            }
          });
        },
      ),
    );
  }
}
