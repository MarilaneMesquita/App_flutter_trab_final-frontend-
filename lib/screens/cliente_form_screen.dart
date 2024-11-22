import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../models/cliente.dart';
import '../services/api_service.dart';

class ClienteFormScreen extends StatefulWidget {
  final Cliente? cliente;

  const ClienteFormScreen({Key? key, this.cliente}) : super(key: key);

  @override
  _ClienteFormScreenState createState() => _ClienteFormScreenState();
}

class _ClienteFormScreenState extends State<ClienteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String nome;
  late String sobrenome;
  late String email;
  late int idade;
  late String foto;

  // URL da imagem padrão
  final String defaultImageUrl =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/User_icon_2.svg/2048px-User_icon_2.svg.png';

  @override
  void initState() {
    super.initState();
    nome = widget.cliente?.nome ?? '';
    sobrenome = widget.cliente?.sobrenome ?? '';
    email = widget.cliente?.email ?? '';
    idade = widget.cliente?.idade ?? 0;
    foto = widget.cliente?.foto ?? defaultImageUrl;
  }

  // Método para validar URLs
  bool isValidUrl(String url) {
    Uri? uri = Uri.tryParse(url);
    if (uri == null) return false;
    return uri.isAbsolute;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.cliente == null ? 'Adicionar Cliente' : 'Editar Cliente'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // Foto do Cliente
              GestureDetector(
                onTap: () {
                },
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(foto),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Campo Nome
              TextFormField(
                initialValue: nome,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
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
              SizedBox(height: 15),
              // Campo Sobrenome
              TextFormField(
                initialValue: sobrenome,
                decoration: InputDecoration(
                  labelText: 'Sobrenome',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o sobrenome';
                  } else if (value.length < 3 || value.length > 25) {
                    return 'O sobrenome deve ter entre 3 e 25 caracteres';
                  }
                  return null;
                },
                onSaved: (value) {
                  sobrenome = value!;
                },
              ),
              SizedBox(height: 15),
              // Campo Email
              TextFormField(
                initialValue: email,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o email';
                  } else if (!EmailValidator.validate(value)) {
                    return 'Por favor, insira um email válido';
                  }
                  return null;
                },
                onSaved: (value) {
                  email = value!;
                },
              ),
              SizedBox(height: 15),
              // Campo Idade
              TextFormField(
                initialValue: idade != 0 ? idade.toString() : '',
                decoration: InputDecoration(
                  labelText: 'Idade',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.cake),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a idade';
                  } else {
                    int? age = int.tryParse(value);
                    if (age == null || age <= 0 || age >= 120) {
                      return 'Por favor, insira uma idade válida (1-119)';
                    }
                  }
                  return null;
                },
                onSaved: (value) {
                  idade = int.parse(value!);
                },
              ),
              SizedBox(height: 15),
              // Campo Foto (URL)
              TextFormField(
                initialValue: foto == defaultImageUrl ? '' : foto,
                decoration: InputDecoration(
                  labelText: 'URL da Foto (Opcional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.image),
                ),
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value != null && value.isNotEmpty && !isValidUrl(value)) {
                    return 'Por favor, insira uma URL válida';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    foto = value.isNotEmpty ? value : defaultImageUrl;
                  });
                },
                onSaved: (value) {
                  foto = value != null && value.isNotEmpty ? value : defaultImageUrl;
                },
              ),
              SizedBox(height: 25),
              // Botão Salvar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text(
                    'Salvar',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Cliente novoCliente = Cliente(
                        id: widget.cliente?.id,
                        nome: nome,
                        sobrenome: sobrenome,
                        email: email,
                        idade: idade,
                        foto: foto,
                      );
                      if (widget.cliente == null) {
                        // Criar novo cliente
                        ApiService.createCliente(novoCliente).then((_) {
                          Navigator.pop(context, true);
                        }).catchError((error) {
                          // Exibir mensagem de erro
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Erro ao criar cliente: $error')),
                          );
                        });
                      } else {
                        // Atualizar cliente existente
                        ApiService.updateCliente(novoCliente).then((_) {
                          Navigator.pop(context, true);
                        }).catchError((error) {
                          // Exibir mensagem de erro
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Erro ao atualizar cliente: $error')),
                          );
                        });
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
