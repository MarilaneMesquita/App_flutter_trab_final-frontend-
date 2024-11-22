import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../services/api_service.dart';
import 'produto_form_screen.dart';

class ProdutosScreen extends StatefulWidget {
  const ProdutosScreen({Key? key}) : super(key: key);

  @override
  _ProdutosScreenState createState() => _ProdutosScreenState();
}

class _ProdutosScreenState extends State<ProdutosScreen> {
  late Future<List<Produto>> futureProdutos;

  @override
  void initState() {
    super.initState();
    futureProdutos = ApiService.fetchProdutos();
  }

  void _refreshProdutos() {
    setState(() {
      futureProdutos = ApiService.fetchProdutos();
    });
  }

  void _confirmDelete(int produtoId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Exclusão'),
          content: Text('Tem certeza que deseja excluir este produto?'),
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
                ApiService.deleteProduto(produtoId).then((_) {
                  Navigator.of(context).pop();
                  _refreshProdutos();
                });
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildProdutoCard(Produto produto) {
    return GestureDetector(
      onTap: () {
        // Navegar para detalhes ou editar
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProdutoFormScreen(produto: produto),
          ),
        ).then((value) {
          if (value == true) {
            _refreshProdutos();
          }
        });
      },
      child: Card(
        elevation: 6,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nome do Produto
              Text(
                produto.nome,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              // Descrição do Produto
              Text(
                produto.descricao,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Spacer(),
              // Preço e Ações
              Row(
                children: [
                  // Preço do Produto
                  Text(
                    'R\$ ${produto.preco.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  // Botão de Ações
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'editar') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProdutoFormScreen(produto: produto),
                          ),
                        ).then((value) {
                          if (value == true) {
                            _refreshProdutos();
                          }
                        });
                      } else if (value == 'excluir') {
                        _confirmDelete(produto.id!);
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          value: 'editar',
                          child: Text('Editar'),
                        ),
                        PopupMenuItem(
                          value: 'excluir',
                          child: Text('Excluir'),
                        ),
                      ];
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

  Widget _buildProdutosGrid(List<Produto> produtos) {
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

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: produtos.length,
      itemBuilder: (context, index) {
        return _buildProdutoCard(produtos[index]);
      },
    );
  }

  Widget _buildBody() {
    return FutureBuilder<List<Produto>>(
      future: futureProdutos,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Produto> produtos = snapshot.data!;
          if (produtos.isEmpty) {
            return Center(
              child: Text(
                'Nenhum produto encontrado.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              _refreshProdutos();
            },
            child: _buildProdutosGrid(produtos),
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
        title: Text('Produtos'),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Adicionar Produto',
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProdutoFormScreen(),
            ),
          ).then((value) {
            if (value == true) {
              _refreshProdutos();
            }
          });
        },
      ),
    );
  }
}
