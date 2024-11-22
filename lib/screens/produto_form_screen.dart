import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../services/api_service.dart';

class ProdutoFormScreen extends StatefulWidget {
  final Produto? produto;

  const ProdutoFormScreen({Key? key, this.produto}) : super(key: key);

  @override
  _ProdutoFormScreenState createState() => _ProdutoFormScreenState();
}

class _ProdutoFormScreenState extends State<ProdutoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String nome;
  late String descricao;
  late double preco;

  @override
  void initState() {
    super.initState();
    nome = widget.produto?.nome ?? '';
    descricao = widget.produto?.descricao ?? '';
    preco = widget.produto?.preco ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.produto == null ? 'Adicionar Produto' : 'Editar Produto'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // Campo Nome
              TextFormField(
                initialValue: nome,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  } else if (value.length < 3 || value.length > 25) {
                    return 'O nome deve ter entre 3 e 25 caracteres';
                  }
                  return null;
                },
                onSaved: (value) {
                  nome = value!;
                },
              ),
              SizedBox(height: 10),
              // Campo Descrição
              TextFormField(
                initialValue: descricao,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a descrição';
                  } else if (value.length < 3 || value.length > 100) {
                    return 'A descrição deve ter entre 3 e 100 caracteres';
                  }
                  return null;
                },
                onSaved: (value) {
                  descricao = value!;
                },
              ),
              SizedBox(height: 10),
              // Campo Preço
              TextFormField(
                initialValue: preco != 0.0 ? preco.toString() : '',
                decoration: InputDecoration(
                  labelText: 'Preço',
                  border: OutlineInputBorder(),
                  prefixText: 'R\$ ',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o preço';
                  } else {
                    double? price = double.tryParse(value.replaceAll(',', '.'));
                    if (price == null || price <= 0) {
                      return 'Por favor, insira um preço válido';
                    }
                  }
                  return null;
                },
                onSaved: (value) {
                  preco = double.parse(value!.replaceAll(',', '.'));
                },
              ),
              SizedBox(height: 20),
              // Botão Salvar
              ElevatedButton(
                child: Text('Salvar'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Produto novoProduto = Produto(
                      id: widget.produto?.id,
                      nome: nome,
                      descricao: descricao,
                      preco: preco,
                    );
                    if (widget.produto == null) {
                      // Criar novo produto
                      ApiService.createProduto(novoProduto).then((_) {
                        Navigator.pop(context, true);
                      }).catchError((error) {
                        // Exibir mensagem de erro
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erro ao criar produto: $error')),
                        );
                      });
                    } else {
                      // Atualizar produto existente
                      ApiService.updateProduto(novoProduto).then((_) {
                        Navigator.pop(context, true);
                      }).catchError((error) {
                        // Exibir mensagem de erro
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erro ao atualizar produto: $error')),
                        );
                      });
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
