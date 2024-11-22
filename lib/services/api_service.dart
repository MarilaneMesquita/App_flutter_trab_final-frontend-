import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cliente.dart';
import '../models/produto.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:4000';

  // Métodos para Clientes
  static Future<List<Cliente>> fetchClientes() async {
    final response = await http.get(Uri.parse('$baseUrl/clientes'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((cliente) => Cliente.fromJson(cliente)).toList();
    } else {
      throw Exception('Falha ao carregar clientes');
    }
  }

  static Future<Cliente> createCliente(Cliente cliente) async {
    final response = await http.post(
      Uri.parse('$baseUrl/clientes'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(cliente.toJson()),
    );
    if (response.statusCode == 201) {
      return Cliente.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao criar cliente');
    }
  }

  static Future<void> deleteCliente(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/clientes/$id'));
    if (response.statusCode != 200) {
      throw Exception('Falha ao deletar cliente');
    }
  }

  static Future<Cliente> updateCliente(Cliente cliente) async {
    final response = await http.put(
      Uri.parse('$baseUrl/clientes/${cliente.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(cliente.toJson()),
    );
    if (response.statusCode == 200) {
      return Cliente.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao atualizar cliente');
    }
  }

  // Métodos para Produtos
  static Future<List<Produto>> fetchProdutos() async {
    final response = await http.get(Uri.parse('$baseUrl/produtos'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((produto) => Produto.fromJson(produto)).toList();
    } else {
      throw Exception('Falha ao carregar produtos');
    }
  }

  static Future<Produto> createProduto(Produto produto) async {
    final response = await http.post(
      Uri.parse('$baseUrl/produtos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(produto.toJson()),
    );
    if (response.statusCode == 201) {
      return Produto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao criar produto');
    }
  }

  static Future<void> deleteProduto(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/produtos/$id'));
    if (response.statusCode != 200) {
      throw Exception('Falha ao deletar produto');
    }
  }

  static Future<Produto> updateProduto(Produto produto) async {
    final response = await http.put(
      Uri.parse('$baseUrl/produtos/${produto.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(produto.toJson()),
    );
    if (response.statusCode == 200) {
      return Produto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao atualizar produto');
    }
  }
}
